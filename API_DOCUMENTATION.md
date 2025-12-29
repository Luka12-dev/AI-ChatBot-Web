# API Documentation

Complete API reference for the AI ChatBot backend server.

## Table of Contents

1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Base URL](#base-url)
4. [Endpoints](#endpoints)
5. [Data Models](#data-models)
6. [Error Handling](#error-handling)
7. [Rate Limiting](#rate-limiting)
8. [WebSocket API](#websocket-api)
9. [Examples](#examples)

## Overview

The AI ChatBot backend provides a REST API for interacting with various AI models including local Ollama models and cloud providers like OpenAI and Anthropic.

### Features

- **Multiple AI Providers**: Ollama, OpenAI, Anthropic
- **Streaming Responses**: Real-time token streaming
- **Model Management**: List, download, and manage AI models
- **Conversation History**: (Client-side storage)
- **WebSocket Support**: Real-time bidirectional communication

### API Version

Current Version: `v1.0.0`

## Authentication

### API Keys

Some endpoints require API keys for cloud providers:

**OpenAI:**
```http
Authorization: Bearer sk-...
```

**Anthropic:**
```http
x-api-key: sk-ant-...
```

**Local Models (Ollama):**
No authentication required for local models.

### Headers

**Required Headers:**
```http
Content-Type: application/json
```

**Optional Headers:**
```http
Authorization: Bearer <token>
x-api-key: <key>
```

## Base URL

**Development:**
```
http://localhost:5000
```

## Endpoints

### Health Check

#### GET /api/ping

Check if the server is running.

**Request:**
```http
GET /api/ping HTTP/1.1
Host: localhost:5000
```

**Response:**
```json
{
  "success": true,
  "message": "pong"
}
```

**Status Codes:**
- `200 OK`: Server is running

---

#### GET /api/version

Get API version information.

**Request:**
```http
GET /api/version HTTP/1.1
Host: localhost:5000
```

**Response:**
```json
{
  "success": true,
  "data": {
    "version": "1.0.0"
  }
}
```

**Status Codes:**
- `200 OK`: Success

---

#### GET /api/status

Get system status and available models.

**Request:**
```http
GET /api/status HTTP/1.1
Host: localhost:5000
```

**Response:**
```json
{
  "success": true,
  "data": {
    "backend": "online",
    "ollama": "online",
    "models": [
      {
        "name": "llama2",
        "size": "3.8GB",
        "modified": "2024-01-15T10:30:00Z"
      }
    ],
    "version": "1.0.0",
    "uptime": 3600
  }
}
```

**Status Codes:**
- `200 OK`: Success
- `503 Service Unavailable`: Backend or Ollama offline

---

### Models

#### GET /api/models

List all available models.

**Request:**
```http
GET /api/models HTTP/1.1
Host: localhost:5000
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "name": "llama2",
      "size": "3825205776",
      "modified": "2024-01-15T10:30:00Z",
      "digest": "sha256:abc123...",
      "details": {
        "format": "gguf",
        "family": "llama",
        "parameterSize": "7B",
        "quantizationLevel": "Q4_0"
      }
    }
  ]
}
```

**Status Codes:**
- `200 OK`: Success
- `500 Internal Server Error`: Failed to fetch models

---

#### GET /api/models/:modelName

Get information about a specific model.

**Parameters:**
- `modelName` (path): Name of the model

**Request:**
```http
GET /api/models/llama2 HTTP/1.1
Host: localhost:5000
```

**Response:**
```json
{
  "success": true,
  "data": {
    "name": "llama2",
    "size": "3825205776",
    "modified": "2024-01-15T10:30:00Z",
    "digest": "sha256:abc123...",
    "details": {
      "format": "gguf",
      "family": "llama",
      "parameterSize": "7B",
      "quantizationLevel": "Q4_0"
    }
  }
}
```

**Status Codes:**
- `200 OK`: Success
- `404 Not Found`: Model not found
- `500 Internal Server Error`: Failed to fetch model info

---

#### POST /api/models/download

Download a new model.

**Request Body:**
```json
{
  "model": "llama2"
}
```

**Request:**
```http
POST /api/models/download HTTP/1.1
Host: localhost:5000
Content-Type: application/json

{
  "model": "llama2"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Model llama2 download started. Please use the model download script."
}
```

**Status Codes:**
- `200 OK`: Download initiated
- `400 Bad Request`: Invalid model name
- `500 Internal Server Error`: Download failed

**Note:** Actual download happens via Ollama CLI. This endpoint is informational.

---

#### DELETE /api/models/:modelName

Delete a model.

**Parameters:**
- `modelName` (path): Name of the model to delete

**Request:**
```http
DELETE /api/models/llama2 HTTP/1.1
Host: localhost:5000
```

**Response:**
```json
{
  "success": true,
  "message": "Model deleted successfully"
}
```

**Status Codes:**
- `200 OK`: Model deleted
- `404 Not Found`: Model not found
- `500 Internal Server Error`: Deletion failed

---

### Chat

#### POST /api/chat

Send a chat message and get a response.

**Request Body:**
```json
{
  "messages": [
    {
      "role": "user",
      "content": "Hello, how are you?"
    }
  ],
  "model": "llama2",
  "settings": {
    "temperature": 0.7,
    "maxTokens": 2048,
    "topP": 0.9,
    "frequencyPenalty": 0,
    "presencePenalty": 0,
    "systemPrompt": "You are a helpful assistant."
  }
}
```

**Request:**
```http
POST /api/chat HTTP/1.1
Host: localhost:5000
Content-Type: application/json

{
  "messages": [
    {
      "role": "user",
      "content": "What is React?"
    }
  ],
  "model": "llama2",
  "settings": {
    "temperature": 0.7,
    "maxTokens": 2048,
    "topP": 0.9,
    "frequencyPenalty": 0,
    "presencePenalty": 0,
    "systemPrompt": "You are a helpful assistant."
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "message": {
      "role": "assistant",
      "content": "React is a JavaScript library for building user interfaces...",
      "model": "llama2"
    },
    "usage": {
      "promptTokens": 15,
      "completionTokens": 150,
      "totalTokens": 165
    }
  }
}
```

**Status Codes:**
- `200 OK`: Success
- `400 Bad Request`: Invalid request body
- `401 Unauthorized`: Missing or invalid API key (for cloud models)
- `500 Internal Server Error`: Chat failed

---

#### POST /api/chat/stream

Send a chat message and stream the response.

**Request Body:**
Same as `/api/chat`

**Request:**
```http
POST /api/chat/stream HTTP/1.1
Host: localhost:5000
Content-Type: application/json

{
  "messages": [
    {
      "role": "user",
      "content": "Write a short poem"
    }
  ],
  "model": "llama2",
  "settings": {
    "temperature": 0.9,
    "maxTokens": 500,
    "topP": 0.95,
    "frequencyPenalty": 0,
    "presencePenalty": 0,
    "systemPrompt": "You are a creative poet."
  }
}
```

**Response:**
Server-Sent Events (SSE) stream:

```
data: {"content":"Roses ","done":false}

data: {"content":"are ","done":false}

data: {"content":"red,\n","done":false}

data: {"content":"Violets ","done":false}

data: {"content":"are ","done":false}

data: {"content":"blue...","done":false}

data: {"content":"","done":true}

data: [DONE]
```

**Headers:**
```http
Content-Type: text/event-stream
Cache-Control: no-cache
Connection: keep-alive
```

**Status Codes:**
- `200 OK`: Stream started
- `400 Bad Request`: Invalid request
- `401 Unauthorized`: Missing API key
- `500 Internal Server Error`: Stream failed

**Client Implementation:**
```javascript
const response = await fetch('/api/chat/stream', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(request)
});

const reader = response.body.getReader();
const decoder = new TextDecoder();

while (true) {
  const { done, value } = await reader.read();
  if (done) break;
  
  const chunk = decoder.decode(value);
  const lines = chunk.split('\n');
  
  for (const line of lines) {
    if (line.startsWith('data: ')) {
      const data = line.slice(6);
      if (data === '[DONE]') break;
      
      const parsed = JSON.parse(data);
      console.log(parsed.content);
    }
  }
}
```

---

## Data Models

### Message

Represents a single message in a conversation.

```typescript
interface Message {
  id: string;              // Unique identifier
  role: 'user' | 'assistant' | 'system';  // Message role
  content: string;         // Message text
  timestamp: number;       // Unix timestamp
  model?: string;          // Model that generated (for assistant messages)
  tokens?: number;         // Token count
  streaming?: boolean;     // Whether message is being streamed
}
```

### Conversation

Represents a conversation thread.

```typescript
interface Conversation {
  id: string;                    // Unique identifier
  title: string;                 // Conversation title
  messages: Message[];           // Array of messages
  createdAt: number;             // Creation timestamp
  updatedAt: number;             // Last update timestamp
  model: string;                 // Default model for conversation
  settings: ConversationSettings; // Conversation settings
}
```

### ConversationSettings

Configuration for a conversation.

```typescript
interface ConversationSettings {
  temperature: number;       // 0.0 - 2.0, controls randomness
  maxTokens: number;         // Maximum tokens in response
  topP: number;              // 0.0 - 1.0, nucleus sampling
  frequencyPenalty: number;  // 0.0 - 2.0, reduces repetition
  presencePenalty: number;   // 0.0 - 2.0, encourages new topics
  systemPrompt: string;      // System instructions
}
```

### ChatRequest

Request body for chat endpoints.

```typescript
interface ChatRequest {
  messages: Message[];              // Conversation history
  model: string;                    // Model to use
  settings: ConversationSettings;   // Generation settings
  stream?: boolean;                 // Enable streaming (optional)
}
```

### ChatResponse

Response from chat endpoint.

```typescript
interface ChatResponse {
  message: Message;           // Generated message
  usage?: {                   // Token usage (cloud models)
    promptTokens: number;
    completionTokens: number;
    totalTokens: number;
  };
}
```

### APIResponse

Standard API response wrapper.

```typescript
interface APIResponse<T = any> {
  success: boolean;    // Request success status
  data?: T;            // Response data (if successful)
  error?: string;      // Error message (if failed)
  message?: string;    // Additional message
}
```

### ModelInfo

Information about an AI model.

```typescript
interface ModelInfo {
  name: string;         // Model name/ID
  size: string;         // Model size in bytes
  modified: string;     // Last modified date (ISO 8601)
  digest: string;       // Model hash
  details?: {
    format: string;           // Model format (e.g., "gguf")
    family: string;           // Model family
    parameterSize: string;    // Number of parameters
    quantizationLevel: string; // Quantization level
  };
}
```

### SystemStatus

Current system status.

```typescript
interface SystemStatus {
  backend: 'online' | 'offline';   // Backend status
  ollama: 'online' | 'offline';    // Ollama status
  models: ModelInfo[];              // Available models
  version: string;                  // API version
  uptime: number;                   // Server uptime in seconds
}
```

---

## Error Handling

### Error Response Format

All errors follow this format:

```json
{
  "success": false,
  "error": "Error message describing what went wrong"
}
```

### Common Error Codes

| Code | Description | Solution |
|------|-------------|----------|
| `400` | Bad Request | Check request format and parameters |
| `401` | Unauthorized | Provide valid API key |
| `404` | Not Found | Resource doesn't exist |
| `429` | Too Many Requests | Slow down request rate |
| `500` | Internal Server Error | Check server logs |
| `503` | Service Unavailable | Wait and retry |

### Error Examples

**Missing Required Field:**
```json
{
  "success": false,
  "error": "Invalid messages format"
}
```

**Invalid API Key:**
```json
{
  "success": false,
  "error": "OpenAI API key required"
}
```

**Model Not Available:**
```json
{
  "success": false,
  "error": "Selected model is not available"
}
```

**Rate Limit:**
```json
{
  "success": false,
  "error": "Rate limit exceeded. Please wait before trying again."
}
```

### Client-Side Error Handling

```javascript
try {
  const response = await fetch('/api/chat', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(chatRequest)
  });
  
  const data = await response.json();
  
  if (!data.success) {
    throw new Error(data.error || 'Unknown error');
  }
  
  return data.data;
} catch (error) {
  console.error('API Error:', error.message);
  // Handle error appropriately
}
```

---

## Rate Limiting

### Local Models (Ollama)

No rate limits. Performance limited only by hardware.

### Cloud Providers

#### OpenAI

- **Tier 1** (Free): 3 RPM, 40,000 TPM
- **Tier 2** ($5 spent): 60 RPM, 80,000 TPM
- **Tier 3** ($50 spent): 3,500 RPM, 90,000 TPM
- **Tier 4** ($100 spent): 5,000 RPM, 150,000 TPM

#### Anthropic

- **Free Tier**: 50 requests/day
- **Paid Tier**: Rate limits based on plan

**RPM**: Requests Per Minute
**TPM**: Tokens Per Minute

### Handling Rate Limits

**Exponential Backoff:**
```javascript
async function retryWithBackoff(fn, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (error.statusCode === 429 && i < maxRetries - 1) {
        const delay = Math.pow(2, i) * 1000;
        await new Promise(resolve => setTimeout(resolve, delay));
        continue;
      }
      throw error;
    }
  }
}
```

---

## WebSocket API

### Connection

```javascript
const ws = new WebSocket('ws://localhost:5000');

ws.onopen = () => {
  console.log('Connected');
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Received:', data);
};

ws.onerror = (error) => {
  console.error('WebSocket error:', error);
};

ws.onclose = () => {
  console.log('Disconnected');
};
```

### Sending Messages

```javascript
ws.send(JSON.stringify({
  type: 'chat',
  data: {
    messages: [...],
    model: 'llama2',
    settings: {...}
  }
}));
```

### Receiving Messages

```javascript
ws.onmessage = (event) => {
  const message = JSON.parse(event.data);
  
  switch (message.type) {
    case 'connected':
      console.log('Connection established');
      break;
    case 'chunk':
      console.log('Streaming chunk:', message.content);
      break;
    case 'complete':
      console.log('Response complete');
      break;
    case 'error':
      console.error('Error:', message.error);
      break;
  }
};
```

---

## Examples

### Basic Chat

```javascript
const response = await fetch('http://localhost:5000/api/chat', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    messages: [
      {
        role: 'user',
        content: 'What is the capital of France?'
      }
    ],
    model: 'llama2',
    settings: {
      temperature: 0.7,
      maxTokens: 100,
      topP: 0.9,
      frequencyPenalty: 0,
      presencePenalty: 0,
      systemPrompt: 'You are a helpful assistant.'
    }
  })
});

const data = await response.json();
console.log(data.data.message.content);
```

### Streaming Chat

```javascript
const response = await fetch('http://localhost:5000/api/chat/stream', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    messages: [
      {
        role: 'user',
        content: 'Tell me a story'
      }
    ],
    model: 'llama2',
    settings: {
      temperature: 0.9,
      maxTokens: 500,
      topP: 0.95,
      frequencyPenalty: 0,
      presencePenalty: 0,
      systemPrompt: 'You are a creative storyteller.'
    }
  })
});

const reader = response.body.getReader();
const decoder = new TextDecoder();
let fullResponse = '';

while (true) {
  const { done, value } = await reader.read();
  if (done) break;
  
  const chunk = decoder.decode(value);
  const lines = chunk.split('\n');
  
  for (const line of lines) {
    if (line.startsWith('data: ')) {
      const data = line.slice(6);
      if (data === '[DONE]') break;
      
      try {
        const parsed = JSON.parse(data);
        if (!parsed.done) {
          fullResponse += parsed.content;
          console.log(parsed.content);
        }
      } catch (e) {
        // Skip invalid JSON
      }
    }
  }
}

console.log('Full response:', fullResponse);
```

### Using OpenAI

```javascript
const response = await fetch('http://localhost:5000/api/chat', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer sk-...'
  },
  body: JSON.stringify({
    messages: [
      {
        role: 'user',
        content: 'Explain quantum computing'
      }
    ],
    model: 'gpt-4-turbo',
    settings: {
      temperature: 0.7,
      maxTokens: 500,
      topP: 1.0,
      frequencyPenalty: 0,
      presencePenalty: 0,
      systemPrompt: 'You are a knowledgeable science teacher.'
    }
  })
});

const data = await response.json();
console.log(data.data.message.content);
console.log('Tokens used:', data.data.usage.totalTokens);
```

### Multi-turn Conversation

```javascript
const messages = [];

// First message
messages.push({
  role: 'user',
  content: 'What is React?'
});

let response = await chat(messages);
messages.push({
  role: 'assistant',
  content: response.message.content
});

// Follow-up
messages.push({
  role: 'user',
  content: 'How do I create a component?'
});

response = await chat(messages);
messages.push({
  role: 'assistant',
  content: response.message.content
});

// Helper function
async function chat(messages) {
  const response = await fetch('http://localhost:5000/api/chat', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      messages,
      model: 'llama2',
      settings: {
        temperature: 0.7,
        maxTokens: 1000,
        topP: 0.9,
        frequencyPenalty: 0,
        presencePenalty: 0,
        systemPrompt: 'You are a helpful coding assistant.'
      }
    })
  });
  
  const data = await response.json();
  return data.data;
}
```

### Error Handling with Retry

```javascript
async function chatWithRetry(request, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const response = await fetch('http://localhost:5000/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request)
      });
      
      const data = await response.json();
      
      if (!response.ok) {
        throw new Error(data.error || `HTTP ${response.status}`);
      }
      
      return data.data;
    } catch (error) {
      console.error(`Attempt ${i + 1} failed:`, error.message);
      
      if (i === maxRetries - 1) {
        throw error;
      }
      
      // Exponential backoff
      const delay = Math.pow(2, i) * 1000;
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
}

// Usage
try {
  const result = await chatWithRetry({
    messages: [...],
    model: 'llama2',
    settings: {...}
  });
  console.log(result.message.content);
} catch (error) {
  console.error('Failed after retries:', error);
}
```

---

## Best Practices

### Performance

1. **Use Streaming**: For better user experience
2. **Batch Requests**: Group multiple operations when possible
3. **Cache Responses**: Store common queries
4. **Optimize Token Usage**: Use appropriate max_tokens

### Security

1. **Never Expose API Keys**: Keep keys server-side
2. **Validate Input**: Sanitize user input
3. **Rate Limit**: Implement client-side throttling
4. **HTTPS Only**: Use secure connections in production

### Reliability

1. **Implement Retries**: Handle temporary failures
2. **Timeout Requests**: Set reasonable timeouts
3. **Monitor Usage**: Track API calls and tokens
4. **Graceful Degradation**: Have fallbacks

---

For more information, visit:
- GitHub: https://github.com/Luka12-dev/AI-ChatBot-Web
- YouTube: https://www.youtube.com/@LukaCyber-s4b7o
