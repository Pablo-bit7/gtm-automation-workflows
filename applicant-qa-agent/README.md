# Applicant Q&A Agent / Talent Profile RAG Chatbot

A retrieval-grounded chatbot that lets recruiters and hiring managers ask questions about a candidate and get accurate, source-backed answers — instead of skimming a CV.

https://za-pharma-intel.mywire.org/webhook/4a765da8-0247-400e-874b-1a15d5f8d0b7/chat

---

## Overview

This system turns a candidate's personal statement, skills breakdown, project history, portfolio, and CV into a queryable knowledge base. Documents are ingested from Google Drive, chunked and embedded into a vector store, and exposed through a public chat widget backed by an LLM agent that answers strictly from retrieved content — with no hallucinated claims about the candidate's experience.

The result is an always-available, self-service interview screen that scales a single candidate's story across unlimited recruiter conversations.

---

## Key Features

### 1. Automated Knowledge Ingestion
- Pulls all documents (Personal Statement, Skills, Projects, Portfolio, CV) from a designated Google Drive folder
- Batch-processes files via a loop, converting native Google Docs to plain text on download
- Chunks and embeds each document using Gemini embeddings, then writes vectors into a Supabase vector store
- Re-runnable on demand to refresh the knowledge base as the candidate's profile evolves

### 2. Retrieval-Grounded Chat Agent
- Public, embeddable chat interface for recruiters to ask questions directly
- AI Agent (Gemini) treats the vector store as a callable **tool** rather than a static context dump — it retrieves only what's relevant to each question
- System prompt constrains the agent to answer *only* from retrieved information, explicitly instructed to respond "I don't have that information in my profile" rather than guess or fabricate
- Conversation memory (buffer window) maintains context across a multi-turn Q&A session

### 3. Decoupled Ingestion & Serving
- Ingestion pipeline and chat pipeline are fully independent workflows sharing only the vector store
- Knowledge base can be refreshed without touching or redeploying the chat agent

---

## Tech Stack

- **n8n** – Workflow orchestration (ingestion pipeline + chat trigger)
- **Google Drive API** – Source document storage and retrieval
- **Supabase (pgvector)** – Vector store for embedded document chunks
- **Google Gemini** – Embeddings (`gemini-embedding-001`) and chat completion
- **LangChain nodes (n8n)** – Agent orchestration, tool-based retrieval, conversational memory

---

## Purpose

This project demonstrates:

- **Retrieval-Augmented Generation (RAG) architecture** — end-to-end, from raw source documents to a grounded conversational interface
- **Agentic tool use** — the LLM decides when and how to query the knowledge base, rather than receiving all context up front
- **Guardrailed AI behavior** — explicit prompt constraints to prevent hallucination, a critical consideration when an AI is representing a real person's qualifications
- **Pipeline separation** — decoupling data ingestion from serving, a standard pattern in production RAG systems

---

## Future Improvements

- Schedule automatic re-ingestion when source documents change (Drive trigger instead of manual run)
- Add source citation to chat responses so recruiters can see which document backs each answer
- Track and log unanswered questions to identify gaps in the knowledge base

---

## Author

**Paballo Mogane**
Junior Python Developer | Automation Engineer
