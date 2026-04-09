---
name: rag-architecture
description: Use when building RAG pipelines - document ingestion, chunking, embedding, vector search, retrieval, reranking, and generation with context
---

# RAG Architecture

## Overview

RAG (Retrieval-Augmented Generation) grounds LLM responses in your data. The quality of retrieval determines the quality of generation — garbage in, hallucination out.

## When to Use

- Building Q&A over documents, knowledge bases, or codebases
- Reducing hallucinations by grounding responses in source data
- Adding domain-specific knowledge to LLMs without fine-tuning
- Building search + AI answer features

## RAG Pipeline

```
Documents → Chunk → Embed → Index → Query → Retrieve → Rerank → Generate
```

### 1. Chunking Strategy

| Strategy | Chunk Size | Best For |
|----------|-----------|----------|
| Fixed-size | 500-1000 tokens | Simple, fast |
| Semantic (paragraph/section) | Varies | Documents with clear structure |
| Recursive text splitter | 500-1000 with overlap | General purpose (recommended start) |
| Sentence-based | 3-5 sentences | Precise retrieval needed |

**Rules:**
- Start with 512 tokens, 50-token overlap
- Too small → loses context. Too large → dilutes relevance.
- Always preserve metadata (source, page, section)

### 2. Embedding Models

| Model | Dimensions | Quality | Cost |
|-------|-----------|---------|------|
| OpenAI text-embedding-3-small | 1536 | Good | $ |
| OpenAI text-embedding-3-large | 3072 | Best | $$ |
| Cohere embed-v3 | 1024 | Great | $ |
| Open-source (BGE, E5) | 768-1024 | Good | Free |

### 3. Vector Store

| Store | Managed | Best For |
|-------|---------|----------|
| Pinecone | ✅ | Production, zero-ops |
| Weaviate | ✅/Self | Hybrid search |
| pgvector | Self | Already using Postgres |
| Chroma | Self | Prototyping, local dev |
| Qdrant | ✅/Self | High performance |

### 4. Retrieval + Reranking

```
Query → Embed → Top-K vector search (k=20)
     → Rerank with cross-encoder (keep top 5)
     → Inject into LLM prompt as context
```

- Always rerank — vector similarity alone misses nuance
- Use Cohere Rerank or cross-encoder models
- Return 3-5 chunks, not 20

## Hybrid Search

Semantic search alone misses exact keyword matches. Combine both:

```python
from rank_bm25 import BM25Okapi
import numpy as np

def hybrid_search(query, docs, chunks, top_k=20, alpha=0.5):
    """alpha=0.5 weights semantic and keyword equally"""
    
    # Semantic search (dense retrieval)
    query_embedding = embed(query)
    semantic_scores = cosine_similarity(query_embedding, chunk_embeddings)
    
    # BM25 keyword search (sparse retrieval)
    bm25 = BM25Okapi([chunk.split() for chunk in chunks])
    keyword_scores = bm25.get_scores(query.split())
    
    # Normalize both to [0,1]
    semantic_norm = (semantic_scores - semantic_scores.min()) / (semantic_scores.max() - semantic_scores.min() + 1e-8)
    keyword_norm = (keyword_scores - keyword_scores.min()) / (keyword_scores.max() - keyword_scores.min() + 1e-8)
    
    # Reciprocal Rank Fusion (RRF) — often better than weighted sum
    combined = alpha * semantic_norm + (1 - alpha) * keyword_norm
    
    return [chunks[i] for i in combined.argsort()[-top_k:][::-1]]
```

**When hybrid beats pure semantic:**
- Exact product names, codes, IDs (BM25 excels at exact match)
- Technical terminology not in embedding training data
- Short queries where semantic embedding is noisy
- Legal/medical documents with precise terminology

**Reciprocal Rank Fusion (RRF)** is often better than weighted scores — doesn't require normalization, robust to score scale differences.

## Query Expansion & HyDE

Improve retrieval by transforming the query before embedding:

**HyDE (Hypothetical Document Embeddings):**
```python
def hyde_retrieval(query, llm, vector_store, top_k=5):
    # Generate a hypothetical answer to use as the search query
    hypothetical = llm.generate(
        f"Write a paragraph that would be a good answer to: {query}"
    )
    # Embed the hypothetical answer — often better than embedding the question
    embedding = embed(hypothetical)
    return vector_store.search(embedding, top_k=top_k)
```

**Multi-query retrieval:**
```python
def multi_query_retrieval(query, llm, vector_store, n_queries=3):
    # Generate alternative phrasings of the same question
    alternatives = llm.generate(
        f"Generate {n_queries} different ways to ask this question: {query}"
    )
    # Retrieve for each phrasing, deduplicate
    all_results = []
    for q in [query] + alternatives:
        all_results.extend(vector_store.search(embed(q), top_k=3))
    return deduplicate_by_id(all_results)
```

**When to use:**
- HyDE: when queries are short or ambiguous (expands the semantic surface)
- Multi-query: when a question can be asked in many ways
- Combine both for maximum recall on complex queries

### 5. Generation Prompt

```
Answer the question based ONLY on the provided context.
If the context doesn't contain the answer, say "I don't know."

Context:
{retrieved_chunks}

Question: {user_query}
Answer:
```

## Evaluation Metrics

| Metric | Measures | Target |
|--------|----------|--------|
| Retrieval recall@5 | Are relevant docs in top 5? | >85% |
| Answer faithfulness | Is answer grounded in context? | >90% |
| Answer relevance | Does answer address the question? | >85% |

## Agentic RAG & Long-Context Tradeoffs

**Agentic RAG** — agent decides what to retrieve and when:

```python
def agentic_rag_step(agent_state):
    # Agent decides: do I need more context?
    if agent_state.confidence < 0.7:
        # Formulate specific retrieval query based on current context
        retrieval_query = agent_state.llm.generate(
            f"What specific information do I need to answer: {agent_state.original_query}\n"
            f"Given what I know so far: {agent_state.current_context}"
        )
        new_context = vector_store.search(retrieval_query, top_k=3)
        agent_state.context.extend(new_context)
    return agent_state
```

**Long-context models vs RAG:**

| Approach | Best for | Tradeoffs |
|----------|---------|-----------|
| RAG | Large corpora (>1M tokens), dynamic content | Retrieval errors, chunking artifacts |
| Long-context (200K+) | Smaller corpora, complex cross-doc reasoning | Higher cost, "lost in the middle" effect |
| Hybrid | Medium corpora needing deep reasoning | Complexity, cost |

**"Lost in the middle" effect:** LLMs attend better to beginning and end of context. For long contexts, put most critical info at the start or end, not the middle.

**Document refresh strategy:**
```python
# Track document versions — re-embed when source changes
def should_reindex(doc_id, source_hash):
    stored_hash = index.get_hash(doc_id)
    return stored_hash != source_hash

# Incremental indexing — only reprocess changed docs
changed_docs = [d for d in corpus if should_reindex(d.id, d.hash)]
batch_embed_and_index(changed_docs)
```

## Anti-Patterns

| Pattern | Fix |
|---------|-----|
| Chunk too large (2000+ tokens) | Reduce to 500-1000 |
| No reranking | Add cross-encoder reranker |
| No source attribution | Always return source metadata |
| Embedding query same as document | Use query-specific embedding or HyDE |

## Integration

- **magic-powers:prompt-engineering** — design generation prompts
- **magic-powers:llm-evaluation** — measure RAG quality
- **magic-powers:performance-optimization** — optimize retrieval latency
