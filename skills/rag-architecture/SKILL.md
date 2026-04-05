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
