# ZA Pharma Intel — Ingress & Signal Engine (MVP)

Automated applicant intake, human-in-the-loop approval, and AI-powered feedback triage system built for a closed-alpha pilot program.

---

## Overview

Running a closed pilot means every applicant and every piece of feedback needs to be reviewed before it moves forward — but doing that manually across email, spreadsheets, and Slack DMs doesn't scale past a handful of users.

This system replaces that manual process with a single event-driven pipeline. Applicants apply through a public form, get automatically deduplicated and priority-ranked, and are routed to a Slack channel where a reviewer can approve or reject them with one click. Approved pilot users can then submit structured feedback ("signals"), which are automatically triaged by an AI agent for priority and sentiment, logged to a system-of-record spreadsheet, and — on reviewer approval — converted directly into a GitHub issue for the engineering team.

The result is a two-way intake system that keeps humans in control of every decision, while removing all of the manual data entry and cross-referencing around it.

---

## Key Features

### 1. Applicant Intake & Deduplication
- Public form trigger captures name, email, organization, LinkedIn, and role
- Automatic lookup against the existing applicant sheet to detect and gracefully handle duplicate submissions
- Priority routing based on email domain (professional/corporate addresses are flagged high-priority over generic consumer domains)

### 2. Slack-Based Human Approval
- New applicants and feedback signals post directly into dedicated Slack review channels using Block Kit
- Reviewers approve or reject with a single button click — no dashboard, no context switching
- A single webhook and routing layer distinguishes applicant decisions from signal decisions based on originating Slack channel

### 3. Automated Applicant Lifecycle Emails
- Confirmation email on submission
- Separate messaging for duplicate applications
- Distinct approval and rejection emails, with approved applicants receiving onboarding instructions and the MCP connection endpoint

### 4. AI-Powered Feedback Triage
- Approved pilot users submit structured feedback (category, operational impact, description)
- An AI Agent (Google Gemini) classifies each submission by priority (1–5), sentiment, a concise summary, and a recommended action (Investigate / Monitor / Escalate / Ignore)
- Output is enforced against a strict JSON schema with automatic retry and correction on validation failure, preventing malformed or hallucinated fields from reaching the review queue

### 5. GitHub Issue Automation
- Reviewer-approved signals are automatically converted into GitHub issues, pre-filled with the description, impact, priority, and signal ID
- Closes the loop between user feedback and the engineering backlog without manual copy-paste

### 6. System of Record
- Every applicant and signal is logged to Google Sheets with timezone-normalized timestamps (SAST), giving a fully auditable history of submissions, decisions, and reviewers

---

## Tech Stack

- **n8n** – Workflow orchestration and webhook routing
- **Google Sheets API** – Applicant and signal system-of-record storage
- **Gmail API** – Transactional lifecycle emails
- **Slack API** – Interactive Block Kit approvals and webhook actions
- **GitHub API** – Automated issue creation
- **Google Gemini (LangChain node)** – LLM-based feedback triage
- **JavaScript (n8n Code Node)** – Payload parsing, ID generation, and timestamp normalization

---

## Purpose

This project demonstrates:

- **Event-driven system design** — routing two independent intake flows (applicants and feedback) through shared infrastructure without cross-contamination
- **Human-in-the-loop automation** — using Slack as a lightweight approval interface instead of building a custom admin panel
- **LLM integration with guardrails** — structured output schemas, validation, and automatic retry logic to keep AI classification reliable in a production pipeline
- **Cross-system orchestration** — Google Sheets, Gmail, Slack, and GitHub operating as one coherent workflow rather than disconnected tools

---

## Author

**Paballo Mogane**
Junior Python Developer | Automation Engineer
