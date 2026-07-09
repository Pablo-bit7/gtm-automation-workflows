# Workflow Automation Systems

Collection of production-style automation systems built using n8n and AI agents, spanning go-to-market operations, applicant intake, and human-in-the-loop review pipelines.

---

## Overview

This repository contains a set of end-to-end automation workflows designed to remove manual bottlenecks from operational processes — lead qualification, applicant vetting, and feedback triage — by combining event-driven orchestration with AI-powered classification.

Each project is self-contained, exported directly from a live n8n instance, and reflects real system design decisions: deduplication, human-in-the-loop approval, structured LLM output validation, and multi-channel notification (Slack, Gmail, Google Sheets, GitHub).

---

## Projects

### 1. LinkedIn Intent Engine
Automated lead qualification pipeline that processes LinkedIn engagement data, filters relevant prospects, classifies companies, and scores leads for targeted outreach.

**Key Features:**
- Real-time trigger from Google Sheets
- Persona and company filtering
- AI-powered company classification
- Fraud exposure and persona scoring
- Lead tiering system for prioritization

`./linkedin-intent-engine`

---

### 2. Ingress & Signal Engine
Applicant intake and pilot-feedback triage system for a closed-alpha SaaS product. Handles application deduplication, priority routing, Slack-based human approval, AI-powered feedback classification, and automated GitHub issue creation — all from two public-facing forms.

**Key Features:**
- Applicant deduplication and priority routing by email domain
- Slack interactive approval workflow (Approve/Reject) with full audit trail in Google Sheets
- Automated applicant lifecycle emails (received, duplicate, approved, rejected)
- AI Agent (Gemini) triage of pilot feedback: priority scoring, sentiment, summary, recommended action
- Structured output validation with auto-retry on schema failure
- Approved signals auto-converted into GitHub issues

`./ingress-signal-engine`

---

### 3. Applicant Q&A Agent / Talent Profile RAG Chatbot
Retrieval-grounded chatbot that answers recruiter questions about a candidate using only ingested source documents (CV, portfolio, skills, project history). Built on a Supabase vector store with a decoupled ingestion pipeline and a public-facing conversational agent.

**Key Features:**
- Automated document ingestion and embedding from Google Drive into a vector store
- Agentic, tool-based retrieval — the LLM queries the knowledge base only when relevant
- Strict grounding: answers only from retrieved content, explicitly refuses to speculate
- Conversational memory for multi-turn Q&A
- Fully decoupled ingestion and serving workflows

`./applicant-qa-agent`

---

## Usage

Each project folder contains:
- Exported workflow (`.json`)
- Project-specific README with setup and explanation

To use:
1. Import the workflow into your n8n instance
2. Configure credentials (Google Sheets, Gmail, Slack, GitHub, etc.)
3. Run and test with sample data

---

## Tech Stack

- **n8n** – Workflow orchestration
- **Google Sheets / Gmail API** – Data storage and notifications
- **Slack API** – Human-in-the-loop review and interactive approvals
- **GitHub API** – Issue automation
- **AI Agents (LLMs)** – Classification, triage, retrieval-augmented Q&A, and enrichment
- **Supabase (pgvector)** – Vector storage for retrieval-augmented generation
- **JavaScript (n8n Code Node)** – Custom scoring and parsing logic

---

## Author

**Paballo Mogane**
Junior Python Developer | Automation Engineer
