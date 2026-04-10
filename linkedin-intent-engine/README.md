# LinkedIn Intent Engine (MVP)

Automated lead qualification pipeline that processes LinkedIn engagement data, filters relevant prospects, classifies companies, and scores leads for targeted outreach.

---

## Overview

This project is an end-to-end workflow built using n8n and AI agents to identify high-intent leads from LinkedIn engagement data.

The system ingests raw engagement data, removes irrelevant profiles, enriches company and persona information using AI, and assigns a lead score to prioritize outreach.

It simulates a real-world GTM (Go-To-Market) automation system used in sales and RevOps environments.

---

## Workflow Breakdown

### 1. Data Ingestion
- Triggered by new rows in Google Sheets (LinkedIn engagement data)
- Captures:
  - Name
  - Job title
  - Company
  - Industry
  - Engagement type (Like, Comment, Repost)

---

### 2. Lead Filtering
- Removes irrelevant personas using regex filtering  
- Excludes roles such as:
  - Recruiters
  - Students
  - Consultants
  - Agencies  

---

### 3. Company Classification (AI Agent)
- Uses an LLM to classify companies into categories:
  - Neobank  
  - Digital Wallet  
  - Payment Processor  
  - Remittance Platform  
  - Fintech Infrastructure  
  - Not Relevant  

- Determines whether the company is relevant for fraud detection solutions

---

### 4. Persona & Risk Analysis (AI Agent)
- Assigns:
  - **Fraud Exposure** (High / Medium / Low)
  - **Persona Type** (Fraud, Risk, Tech, Payments, Other)
  - **Persona Score**
  - **Fraud Insight** (contextual outreach angle)

---

### 5. Lead Scoring Engine

Custom JavaScript logic calculates a total lead score based on:

- **Engagement Signal**
  - Like = 1  
  - Comment = 3  
  - Repost = 4  

- **Company Relevance**
  - Fintech classification  
  - Fraud exposure level  

- **Persona Value**
  - Fraud roles weighted highest  

---

### 6. Lead Tiering

Final leads are grouped into priority tiers:

- **Tier 1 (High Priority)**
- **Tier 2 (Medium Priority)**
- **Tier 3 (Low Priority)**

---

### 7. Output & Storage
- Qualified leads are stored in Google Sheets
- Includes enriched fields:
  - Company category
  - Fraud exposure
  - Persona type
  - Lead score
  - Tier classification

---

## Tech Stack

- **n8n** – Workflow orchestration  
- **Google Sheets API** – Data source and storage  
- **AI Agents (LLMs)** – Classification and enrichment  
- **JavaScript (n8n Code Node)** – Scoring logic  

---

## Example Output

```json
{
  "name": "Sarah Khan",
  "title": "Head of Fraud",
  "company": "PayFast",
  "company_category": "Payment Processor",
  "fraud_exposure": "High",
  "persona_type": "Fraud",
  "total_score": 17,
  "tier": "Tier 1"
}
