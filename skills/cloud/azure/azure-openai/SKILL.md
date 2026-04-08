---
name: azure-openai
description: Use when integrating Azure OpenAI Service, deploying GPT/embedding models, building RAG applications with Azure AI Search, implementing prompt engineering patterns, or studying for Azure AI Engineer Associate (AI-102) or AI-200.
---

# Azure OpenAI

## When to Use
- Deploying and integrating GPT-4o, GPT-4, GPT-3.5-turbo, or embedding models on Azure
- Building RAG (Retrieval-Augmented Generation) pipelines with Azure AI Search
- Designing prompt engineering patterns (system messages, few-shot, chain-of-thought)
- Implementing Responsible AI with Content Safety filtering
- Choosing between standard and provisioned deployment for throughput requirements
- Preparing for Azure AI Engineer Associate (AI-102) or AI-200 exam

## Core Jobs

### 1. Model Deployment
| Model Family | Use Case |
|--------------|---------|
| **GPT-4o** | Latest multimodal; text + vision; balanced cost/performance |
| **GPT-4** | High-quality reasoning; complex tasks |
| **GPT-3.5-turbo** | Fast, cost-effective; simple tasks, high volume |
| **text-embedding-ada-002 / text-embedding-3-*** | Vector embeddings for semantic search |
| **DALL-E 3** | Image generation from text |
| **Whisper** | Speech-to-text transcription |

- Deployment types:
  | Type | Throughput | Billing | Best For |
  |------|-----------|---------|---------|
  | **Standard** | Shared; TPM/RPM limits | Pay-per-token | Variable workloads |
  | **Provisioned (PTU)** | Reserved capacity | Hourly PTU rate | Predictable, high-throughput |
  | **Global Standard** | Globally routed | Pay-per-token | Overflow capacity |

- TPM = Tokens Per Minute; RPM = Requests Per Minute; quotas per deployment per region

### 2. RAG (Retrieval-Augmented Generation)
- Pattern: User query → retrieve relevant chunks → pass as context to LLM → generate grounded response
- Azure implementation:
  1. **Document ingestion**: chunk documents → generate embeddings → index in Azure AI Search
  2. **Retrieval**: embed user query → search AI Search (vector, keyword, or hybrid) → return top-k chunks
  3. **Generation**: send chunks + query to Azure OpenAI → GPT generates answer citing retrieved context
- Azure AI Search capabilities:
  - **Vector search**: cosine similarity on embedding vectors
  - **Keyword search**: BM25 full-text search
  - **Hybrid search**: combine vector + keyword scores (recommended)
  - **Semantic ranking**: rerank hybrid results using language understanding
- Chunking strategy: fixed-size (tokens), sentence-based, or semantic chunking; overlap recommended

### 3. Prompt Engineering Patterns
| Pattern | Description | When to Use |
|---------|-------------|------------|
| **System message** | Persona, instructions, constraints | Always; sets model behavior |
| **Few-shot examples** | Input-output examples in prompt | Specific output format required |
| **Chain-of-thought** | "Think step by step" instruction | Complex reasoning tasks |
| **JSON mode** | `response_format: {type: "json_object"}` | Structured output for parsing |
| **Tool/function calling** | Define functions; model decides to call | Agent-style applications |

- System message persists across conversation turns; user/assistant messages are conversation history
- Temperature: 0 = deterministic; 1+ = creative; use 0 for RAG grounding, 0.7 for creative tasks
- Max tokens: limit output length; prevent runaway token consumption

### 4. Content Safety
- **Azure AI Content Safety** = content moderation for inputs and outputs
- Content filters applied by default; categories: Hate, Violence, Sexual, Self-Harm
- Severity levels: Safe, Low, Medium, High; configurable threshold per category (requires approval)
- **Custom blocklist**: add domain-specific prohibited terms
- **Groundedness detection**: detect hallucinations (responses not grounded in retrieved context)
- **Prompt Shield**: detect jailbreak attempts and indirect prompt injection
- All content safety events logged; reviewable in Azure AI Studio

### 5. Function Calling / Tools
- Define JSON schema of available functions; model includes function call in response when appropriate
- Client-side execution: parse model's function call → execute → return result → model generates final answer
- Use cases: search the web, query database, get current time, call external API
- **Parallel function calling**: model can call multiple functions in one response (GPT-4o, GPT-4-turbo)
- `tool_choice: "auto"` = model decides; `"required"` = must call a tool; specific tool name = force specific tool

### 6. Fine-Tuning
| Aspect | Detail |
|--------|--------|
| Available models | GPT-4o mini, GPT-3.5-turbo |
| Data format | JSONL with `{messages: [{role, content}]}` per example |
| Min training examples | 10 (recommended: 50-100+) |
| Use case | Domain-specific tone/format; not for adding new knowledge |

- Fine-tuning ≠ RAG: fine-tuning adjusts model behavior/style; RAG provides retrieval-time knowledge
- Rule of thumb: try prompt engineering + few-shot first; fine-tune only when prompt alone is insufficient
- Fine-tuned model deployed like standard model; billed per token + training compute

## Key Concepts
- **PTU (Provisioned Throughput Units)** — reserved capacity; predictable latency; no rate limits during reservation
- **RAG** — retrieval at inference time; grounds model in current data; no retraining needed
- **Vector search** — cosine similarity on embeddings; finds semantically similar content
- **Hybrid search** — vector + keyword combined; better retrieval quality than either alone
- **System message** — model persona and instructions; persists across all turns in a conversation
- **Content filter** — default content safety filters; configure severity thresholds per category
- **JSON mode** — force model to output valid JSON; always include JSON instruction in system/user message

## Checklist
- [ ] Azure OpenAI (not direct OpenAI API) used for enterprise compliance and private networking?
- [ ] PTU deployment evaluated for predictable high-throughput workloads?
- [ ] RAG implemented with Azure AI Search hybrid search + semantic ranking?
- [ ] System message crafted with clear persona, instructions, and constraints?
- [ ] Content Safety filters reviewed and custom blocklist configured for domain?
- [ ] JSON mode used for structured output instead of prompt-only JSON instructions?
- [ ] Private endpoint configured on Azure OpenAI resource for VNet isolation?

## Output Format
- 🔴 **Critical** — Azure OpenAI public endpoint used for sensitive data without Private Endpoint
- 🔴 **Critical** — no content safety filtering on user-facing application (default filters disabled)
- 🟡 **Warning** — vector-only search without hybrid search (misses keyword-matched exact terminology)
- 🟡 **Warning** — temperature set to 1+ for RAG application (encourages hallucination; use 0 for grounding)
- 🟢 **Suggestion** — enable semantic ranking on Azure AI Search for best RAG retrieval quality

## Exam Tips
- **Azure OpenAI ≠ OpenAI API** — Azure = enterprise features: private endpoints, RBAC, Entra ID auth, compliance certifications
- **PTU (Provisioned Throughput Units) = reserved capacity** — predictable latency; no rate limit surprises; billed hourly regardless of usage
- **RAG = retrieval + generation** — Azure AI Search provides retrieval (vector/hybrid); OpenAI generates grounded answer; no model retraining
- **Vector search = semantic similarity; keyword = exact match; hybrid = both** — hybrid recommended for RAG; semantic ranking reranks hybrid results
- **System message = persona + instructions; persists across turns** — always set for production apps; defines model's behavior throughout conversation
- **Responsible AI: content filters always on by default** — configure severity thresholds per category (requires Microsoft approval for lower thresholds)
