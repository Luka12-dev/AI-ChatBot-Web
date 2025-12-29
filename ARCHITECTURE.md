# Architecture Documentation

Comprehensive architecture overview of AI ChatBot Web.

## Table of Contents

1. [System Overview](#system-overview)
2. [Architecture Principles](#architecture-principles)
3. [Frontend Architecture](#frontend-architecture)
4. [Backend Architecture](#backend-architecture)
5. [Data Flow](#data-flow)
6. [State Management](#state-management)
7. [API Design](#api-design)
8. [Security Architecture](#security-architecture)

## System Overview

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         Client Layer                        │
├─────────────────────────────────────────────────────────────┤
│  Browser (Chrome, Firefox, Safari, Edge)                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Next.js    │  │    React     │  │  TypeScript  │       │
│  │  Framework   │  │    18.2.0    │  │    5.3.3     │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ HTTP/WebSocket
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                      Application Layer                      │
├─────────────────────────────────────────────────────────────┤
│  Node.js Backend Server                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Express    │  │  WebSocket   │  │     CORS     │       │
│  │    Server    │  │    Server    │  │   Middleware │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ API Calls
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                       AI Provider Layer                     │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │    Ollama    │  │    OpenAI    │  │  Anthropic   │       │
│  │  (Local AI)  │  │   (Cloud)    │  │   (Cloud)    │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
                           │
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                         Data Layer                          │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │ localStorage │  │  IndexedDB   │  │  PostgreSQL  │       │
│  │   (Client)   │  │   (Client)   │  │  (Optional)  │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

### Technology Stack

**Frontend**:
- Framework: Next.js 14
- UI Library: React 18
- Language: TypeScript 5.3
- Styling: Tailwind CSS 3.3
- Animations: Framer Motion 10
- State: Zustand 4.4

**Backend**:
- Runtime: Node.js 18+
- Framework: Express 4
- WebSocket: ws 8
- Real-time: Server-Sent Events

**AI Integration**:
- Local: Ollama API
- Cloud: OpenAI SDK, Anthropic SDK

**Build Tools**:
- Compiler: SWC
- Bundler: Webpack 5 (via Next.js)
- Package Manager: npm

## Architecture Principles

### 1. Separation of Concerns

Each layer has a specific responsibility:

**Presentation Layer**: UI components and user interactions
**Business Logic Layer**: Application logic and data processing
**Data Access Layer**: API calls and data persistence
**Infrastructure Layer**: Configuration and external services

### 2. Component-Based Architecture

```
components/
├── atoms/           # Basic building blocks
├── molecules/       # Combinations of atoms
├── organisms/       # Complex components
└── templates/       # Page layouts
```

### 3. Unidirectional Data Flow

```
User Action → Store Update → Component Re-render → UI Update
```

### 4. API-First Design

All backend functionality exposed through REST API:
- Versioned endpoints
- Consistent response format
- Clear error messages
- Comprehensive documentation

### 5. Progressive Enhancement

Core functionality works without JavaScript:
- Server-side rendering
- Graceful degradation
- Accessible by default

### 6. Security by Design

- Input validation at all layers
- Output encoding
- HTTPS only in production
- No sensitive data in client
- Rate limiting
- CORS configuration

## Frontend Architecture

### Component Structure

```typescript
// Component Organization
src/
├── components/
│   ├── StartScreen.tsx      // Landing page
│   ├── MainScreen.tsx       // Main chat interface
│   ├── Header.tsx           // Top navigation
│   ├── Sidebar.tsx          // Swipeable sidebar
│   ├── MessageList.tsx      // Message container
│   ├── MessageItem.tsx      // Individual message
│   ├── ChatInput.tsx        // Message input
│   ├── SettingsModal.tsx    // Settings dialog
│   └── sidebar/             // Sidebar components
│       ├── ModelSelector.tsx
│       ├── LanguageSelector.tsx
│       └── AdvancedSettings.tsx
```

### Component Hierarchy

```
App
└── _app.tsx (Global wrapper)
    └── index.tsx (Root page)
        ├── StartScreen (Initial view)
        │   ├── Feature cards
        │   ├── Model counter
        │   └── Action buttons
        └── MainScreen (Chat interface)
            ├── Header
            │   ├── Menu button
            │   ├── Title
            │   ├── Status
            │   └── Actions
            ├── Sidebar (Conditional)
            │   ├── Models tab
            │   ├── Settings tab
            │   └── History tab
            ├── MessageList
            │   └── MessageItem (Multiple)
            └── ChatInput
                ├── TextArea
                └── Send button
```

### Routing Strategy

**File-based routing** (Next.js):

```
pages/
├── _app.tsx         → All pages wrapper
├── _document.tsx    → HTML document
├── index.tsx        → / (Home)
├── 404.tsx          → Not found (future)
└── api/             → API routes (unused, using separate backend)
```

### State Management Strategy

**Zustand stores**:

```typescript
// Store Organization
store/
├── chatStore.ts     // Conversations and messages
└── modelStore.ts    // AI models and status

// Store Structure
interface ChatStore {
  // State
  conversations: Conversation[];
  currentConversationId: string | null;
  settings: AppSettings;
  
  // Actions
  createConversation: () => void;
  addMessage: (id: string, message: Message) => void;
  updateSettings: (settings: Partial<AppSettings>) => void;
}
```

**State persistence**:
- Zustand persist middleware
- localStorage for client-side
- Automatic serialization/deserialization

### Rendering Strategy

**Server-Side Rendering (SSR)**:
- Initial page load is server-rendered
- Fast First Contentful Paint
- SEO friendly

**Client-Side Rendering (CSR)**:
- Dynamic updates after hydration
- Interactive features
- Real-time updates

**Hybrid approach**:
```typescript
// Server-rendered initial content
export async function getServerSideProps() {
  return { props: {} };
}

// Client-side interactivity
export default function Page() {
  const [data, setData] = useState(null);
  
  useEffect(() => {
    // Client-side data fetching
  }, []);
}
```

## Backend Architecture

### Server Structure

```javascript
// backend/server.js
const express = require('express');
const cors = require('cors');
const http = require('http');
const WebSocket = require('ws');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.get('/api/ping', pingHandler);
app.get('/api/status', statusHandler);
app.get('/api/models', modelsHandler);
app.post('/api/chat', chatHandler);
app.post('/api/chat/stream', streamHandler);

// WebSocket
wss.on('connection', wsHandler);

server.listen(PORT);
```

### API Endpoint Design

**RESTful conventions**:

```
GET    /api/resource      # List all
GET    /api/resource/:id  # Get one
POST   /api/resource      # Create
PUT    /api/resource/:id  # Update
DELETE /api/resource/:id  # Delete
```

**Response format**:

```typescript
interface APIResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}
```

### Request Processing Flow

```
1. Request arrives
   ↓
2. CORS middleware checks origin
   ↓
3. Body parser parses JSON
   ↓
4. Route handler processes request
   ↓
5. Validation checks input
   ↓
6. Business logic executes
   ↓
7. External API called (if needed)
   ↓
8. Response formatted
   ↓
9. Response sent to client
```

### Error Handling Strategy

```javascript
// Centralized error handler
app.use((err, req, res, next) => {
  console.error('Error:', err);
  
  res.status(err.status || 500).json({
    success: false,
    error: process.env.NODE_ENV === 'production'
      ? 'Internal server error'
      : err.message
  });
});
```

### Streaming Architecture

**Server-Sent Events (SSE)**:

```javascript
async function streamHandler(req, res) {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  
  const stream = await getAIStream(req.body);
  
  for await (const chunk of stream) {
    res.write(`data: ${JSON.stringify(chunk)}\n\n`);
  }
  
  res.write('data: [DONE]\n\n');
  res.end();
}
```

## Data Flow

### Message Sending Flow

```
1. User types message
   ↓
2. ChatInput validates input
   ↓
3. useChat hook called
   ↓
4. Message added to store
   ↓
5. API request sent
   ↓
6. Backend receives request
   ↓
7. Request validated
   ↓
8. AI provider called
   ↓
9. Response streamed back
   ↓
10. Frontend processes chunks
    ↓
11. UI updates in real-time
    ↓
12. Complete message stored
```

### State Update Flow

```
Action Dispatched
   ↓
Store Updated (Zustand)
   ↓
Subscribers Notified
   ↓
Components Re-render
   ↓
UI Updated
```

### Conversation Persistence

```
User Action
   ↓
Store Updated
   ↓
Persist Middleware Triggered
   ↓
localStorage.setItem()
   ↓
Data Saved
```

## State Management

### Zustand Architecture

**Store creation**:

```typescript
export const useChatStore = create<ChatState>()(
  persist(
    (set, get) => ({
      // State
      conversations: [],
      
      // Actions
      addMessage: (id, message) => {
        set(state => ({
          conversations: state.conversations.map(conv =>
            conv.id === id
              ? { ...conv, messages: [...conv.messages, message] }
              : conv
          )
        }));
      }
    }),
    {
      name: 'ai-chatbot-storage',
      storage: createJSONStorage(() => localStorage)
    }
  )
);
```

### State Structure

```typescript
// Global State
{
  // Chat Store
  conversations: Conversation[],
  currentConversationId: string | null,
  settings: AppSettings,
  sidebarOpen: boolean,
  isStreaming: boolean,
  
  // Model Store
  models: AIModel[],
  systemStatus: SystemStatus,
  isLoading: boolean
}
```

### State Access Patterns

**Read state**:
```typescript
const conversations = useChatStore(state => state.conversations);
```

**Update state**:
```typescript
const addMessage = useChatStore(state => state.addMessage);
addMessage(id, message);
```

**Subscribe to changes**:
```typescript
useEffect(() => {
  const unsubscribe = useChatStore.subscribe(
    state => state.conversations,
    (conversations) => {
      console.log('Conversations updated:', conversations);
    }
  );
  
  return unsubscribe;
}, []);
```

## API Design

### Endpoint Structure

**Base URL**: `http://localhost:5000/api`

**Endpoints**:

```
Health & Status:
  GET  /ping                  → Health check
  GET  /version               → API version
  GET  /status                → System status

Models:
  GET  /models                → List models
  GET  /models/:name          → Get model info
  POST /models/download       → Download model
  DEL  /models/:name          → Delete model

Chat:
  POST /chat                  → Send message
  POST /chat/stream           → Stream response
```

### Request/Response Patterns

**Standard request**:
```json
{
  "messages": [
    {
      "role": "user",
      "content": "Hello"
    }
  ],
  "model": "llama2",
  "settings": {
    "temperature": 0.7,
    "maxTokens": 2048
  }
}
```

**Standard response**:
```json
{
  "success": true,
  "data": {
    "message": {
      "role": "assistant",
      "content": "Hi there!",
      "model": "llama2"
    }
  }
}
```

**Error response**:
```json
{
  "success": false,
  "error": "Model not available"
}
```

### API Versioning

**Current**: v1 (implicit)
**Future**: `/api/v2/...`

**Version strategy**:
- Major version in URL path
- Minor versions backward compatible
- Deprecation warnings for old versions

### Rate Limiting

**Strategy**:
```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,  // 15 minutes
  max: 100,                   // 100 requests per window
  message: 'Too many requests'
});

app.use('/api/', limiter);
```

## Security Architecture

### Authentication (Future)

**JWT-based**:
```
Client                  Server
  |                        |
  | 1. Login request       |
  |----------------------->|
  |                        | 2. Verify credentials
  |                        | 3. Generate JWT
  | 4. Return JWT          |
  |<-----------------------|
  |                        |
  | 5. API request + JWT   |
  |----------------------->|
  |                        | 6. Verify JWT
  |                        | 7. Process request
  | 8. Return response     |
  |<-----------------------|
```

### Authorization

**Role-based** (future):
- Admin: Full access
- User: Limited to own data
- Guest: Read-only

### Data Protection

**In transit**:
- HTTPS in production
- TLS 1.2+
- Strong cipher suites

**At rest**:
- localStorage (client-side)
- Encrypted database (server-side, optional)
- API keys in environment variables

### Input Validation

**Multiple layers**:

```typescript
// 1. Client-side
function validateMessage(content: string) {
  if (!content || content.length === 0) {
    throw new Error('Message cannot be empty');
  }
  if (content.length > 32000) {
    throw new Error('Message too long');
  }
}

// 2. Server-side
app.post('/api/chat', (req, res) => {
  const { messages, model } = req.body;
  
  if (!Array.isArray(messages)) {
    return res.status(400).json({
      success: false,
      error: 'Invalid messages format'
    });
  }
  
  // Process request
});
```

### CORS Configuration

```javascript
app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  credentials: true,
  optionsSuccessStatus: 200
}));
```

## Scalability Considerations

### Horizontal Scaling

**Load balancing**:
```nginx
upstream backend {
    least_conn;
    server 127.0.0.1:5000;
    server 127.0.0.1:5001;
    server 127.0.0.1:5002;
}
```

**Stateless design**:
- No session state in backend
- Client-side state management
- Scalable to multiple instances

### Vertical Scaling

**Resource optimization**:
- Efficient algorithms
- Memory management
- CPU optimization
- Database indexing

### Caching Strategy

**Multiple layers**:
```
Browser Cache
    ↓
CDN Cache
    ↓
Application Cache
    ↓
Database
```

## Future Architecture

### Planned Enhancements

1. **Microservices**:
   - Separate services for different AI providers
   - Independent scaling
   - Better fault isolation

2. **Event-Driven Architecture**:
   - Message queue (RabbitMQ/Kafka)
   - Async processing
   - Better scalability

3. **Database Integration**:
   - PostgreSQL for persistence
   - Redis for caching
   - MongoDB for logs

4. **API Gateway**:
   - Centralized entry point
   - Authentication/Authorization
   - Rate limiting
   - Request routing

---

**This architecture provides**:
- Scalability
- Maintainability
- Security
- Performance
- Developer experience

For implementation details, see the code in the repository.
