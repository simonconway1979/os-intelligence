---
tags:
  - type/context
  - status/validated
---

# Technical Writing Style

Use this when writing for engineers, technical documentation, or API docs.

## Characteristics

**Tone:** Precise, detailed, unambiguous
**Audience:** Engineers, developers, technical users
**Goal:** Clarity and accuracy over everything

## Rules

### 1. Be Precise
- Avoid: "The API is fast"
- Better: "The API responds in <[X]ms at p95"

- Avoid: "It handles a lot of data"
- Better: "It processes up to [X] requests/second"

### 2. Use Technical Terms Correctly
- Don't dumb down technical concepts
- Use industry-standard terminology
- Define terms only when ambiguous
- Assume technical literacy

### 3. Include Specifics
Always include:
- Exact version numbers
- Specific error codes
- Precise data types
- Complete code examples
- System requirements

### 4. Structure Logically
- Start with overview
- Provide complete context
- Show examples
- Cover edge cases
- Link to references

### 5. Code Examples
- Syntax highlighted
- Runnable (not pseudo-code)
- Cover common use cases
- Include error handling
- Show expected output

## Example

**Bad (Vague):**
```
The authentication system is secure and easy to use. Just add your credentials
and you're good to go!
```

**Good (Technical):**
```
## Authentication

API uses OAuth 2.0 with JWT bearer tokens.

**Token Lifespan:** [X] seconds
**Refresh:** Required after expiration
**Endpoint:** POST /api/v2/auth/token

**Request:**
```json
{
  "client_id": "your_client_id",
  "client_secret": "your_client_secret",
  "grant_type": "client_credentials"
}
```

**Response (200 OK):**
```json
{
  "access_token": "eyJhbGc...",
  "token_type": "Bearer",
  "expires_in": [X]
}
```

**Usage:**
```bash
curl -H "Authorization: Bearer [token]" \
     https://api.[your-domain].com/v2/[endpoint]
```

**Error Codes:**
- 401: Invalid credentials
- 429: Rate limit exceeded ([X] req/min)
- 500: Server error (retry with exponential backoff)
```

## When to Use
- Engineering PRDs
- Technical specifications
- API documentation
- Architecture decisions
- Release notes for developers
