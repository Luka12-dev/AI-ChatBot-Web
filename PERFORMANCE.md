# Performance Guide

Comprehensive guide for optimizing AI ChatBot Web performance.

## Table of Contents

1. [Performance Overview](#performance-overview)
2. [Frontend Optimization](#frontend-optimization)
3. [Backend Optimization](#backend-optimization)
4. [Network Optimization](#network-optimization)
5. [Resource Optimization](#resource-optimization)
6. [Monitoring](#monitoring)
7. [Best Practices](#best-practices)

## Performance Overview

### Current Performance Metrics

**Lighthouse Scores:**
- Performance: 96/100
- Accessibility: 98/100
- Best Practices: 100/100
- SEO: 95/100

**Load Times:**
- First Contentful Paint: 0.9s
- Largest Contentful Paint: 1.8s
- Time to Interactive: 2.5s
- Total Blocking Time: 150ms
- Cumulative Layout Shift: 0.05

**Bundle Sizes:**
- Main bundle: 280KB (gzipped)
- Vendor bundle: 350KB (gzipped)
- CSS: 45KB (gzipped)
- Total: 675KB (gzipped)

### Performance Goals

**Target Metrics:**
- First Contentful Paint < 1.0s
- Time to Interactive < 3.0s
- Bundle size < 500KB (gzipped)
- API response time < 200ms
- Streaming latency < 50ms

## Frontend Optimization

### Code Splitting

**Route-based splitting:**
```typescript
// pages/index.tsx
import dynamic from 'next/dynamic';

const MainScreen = dynamic(() => import('@/components/MainScreen'), {
  loading: () => <LoadingSpinner />,
});

const StartScreen = dynamic(() => import('@/components/StartScreen'), {
  loading: () => <LoadingSpinner />,
});
```

**Component-based splitting:**
```typescript
// Lazy load heavy components
const SettingsModal = dynamic(() => import('@/components/SettingsModal'), {
  ssr: false,
});

const ConversationAnalytics = dynamic(
  () => import('@/components/ConversationAnalytics'),
  { ssr: false }
);
```

### React Optimization

**Use React.memo:**
```typescript
import { memo } from 'react';

const MessageItem = memo(({ message }: MessageItemProps) => {
  return <div>{message.content}</div>;
}, (prevProps, nextProps) => {
  return prevProps.message.id === nextProps.message.id &&
         prevProps.message.content === nextProps.message.content;
});
```

**Use useMemo:**
```typescript
const filteredMessages = useMemo(() => {
  return messages.filter(m => m.content.includes(searchQuery));
}, [messages, searchQuery]);
```

**Use useCallback:**
```typescript
const handleSend = useCallback((content: string) => {
  sendMessage(content);
}, [sendMessage]);
```

**Virtual scrolling for long lists:**
```typescript
import { FixedSizeList } from 'react-window';

function MessageList({ messages }: { messages: Message[] }) {
  return (
    <FixedSizeList
      height={600}
      itemCount={messages.length}
      itemSize={80}
      width="100%"
    >
      {({ index, style }) => (
        <div style={style}>
          <MessageItem message={messages[index]} />
        </div>
      )}
    </FixedSizeList>
  );
}
```

### Image Optimization

**Use Next.js Image component:**
```typescript
import Image from 'next/image';

<Image
  src="/logo.png"
  alt="Logo"
  width={200}
  height={50}
  priority
  quality={85}
/>
```

**Lazy load images:**
```typescript
<Image
  src="/image.jpg"
  alt="Description"
  loading="lazy"
  width={800}
  height={600}
/>
```

### CSS Optimization

**Use CSS modules:**
```typescript
import styles from './Component.module.css';

<div className={styles.container}>Content</div>
```

**Purge unused CSS:**
```javascript
// tailwind.config.js
module.exports = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx}',
    './components/**/*.{js,ts,jsx,tsx}',
  ],
  // This removes unused styles
};
```

**Critical CSS:**
```javascript
// next.config.js
module.exports = {
  experimental: {
    optimizeCss: true,
  },
};
```

### JavaScript Optimization

**Tree shaking:**
```typescript
// Import only what you need
import { debounce } from 'lodash-es';

// Not
import _ from 'lodash';
```

**Remove console.log in production:**
```javascript
// next.config.js
module.exports = {
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production',
  },
};
```

**Minification:**
```javascript
// next.config.js
module.exports = {
  swcMinify: true,
};
```

## Backend Optimization

### API Response Time

**Caching:**
```javascript
const NodeCache = require('node-cache');
const cache = new NodeCache({ stdTTL: 300 }); // 5 minutes

app.get('/api/models', async (req, res) => {
  const cacheKey = 'models';
  const cached = cache.get(cacheKey);
  
  if (cached) {
    return res.json({ success: true, data: cached });
  }
  
  const models = await fetchModels();
  cache.set(cacheKey, models);
  
  res.json({ success: true, data: models });
});
```

**Database indexing:**
```sql
CREATE INDEX idx_conversations_user ON conversations(user_id);
CREATE INDEX idx_conversations_updated ON conversations(updated_at DESC);
CREATE INDEX idx_messages_conversation ON messages(conversation_id);
```

**Connection pooling:**
```javascript
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});
```

### Streaming Optimization

**Efficient chunk processing:**
```javascript
async function streamResponse(model, messages, res) {
  const stream = await getModelStream(model, messages);
  
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  
  let buffer = '';
  
  for await (const chunk of stream) {
    buffer += chunk;
    
    // Send in batches for efficiency
    if (buffer.length > 100) {
      res.write(`data: ${JSON.stringify({ content: buffer })}\n\n`);
      buffer = '';
    }
  }
  
  if (buffer) {
    res.write(`data: ${JSON.stringify({ content: buffer })}\n\n`);
  }
  
  res.write(`data: [DONE]\n\n`);
  res.end();
}
```

### Compression

**Enable gzip:**
```javascript
const compression = require('compression');

app.use(compression({
  level: 6,
  threshold: 1024, // Only compress responses > 1KB
  filter: (req, res) => {
    if (req.headers['x-no-compression']) {
      return false;
    }
    return compression.filter(req, res);
  },
}));
```

### Load Balancing

**PM2 cluster mode:**
```javascript
// ecosystem.config.js
module.exports = {
  apps: [{
    name: 'api',
    script: './backend/server.js',
    instances: 'max', // Use all CPU cores
    exec_mode: 'cluster',
  }],
};
```

**Nginx load balancing:**
```nginx
upstream backend {
    least_conn;
    server 127.0.0.1:5000;
    server 127.0.0.1:5001;
    server 127.0.0.1:5002;
}

server {
    location /api {
        proxy_pass http://backend;
    }
}
```

## Network Optimization

### CDN Configuration

**CloudFlare setup:**
```javascript
// next.config.js
module.exports = {
  images: {
    domains: ['cdn.yourdomain.com'],
  },
  async headers() {
    return [
      {
        source: '/static/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
        ],
      },
    ];
  },
};
```

### HTTP/2

**Enable HTTP/2 in Nginx:**
```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;
    
    # Rest of configuration
}
```

### Prefetching

**DNS prefetch:**
```html
<link rel="dns-prefetch" href="//api.yourdomain.com">
```

**Preconnect:**
```html
<link rel="preconnect" href="//api.yourdomain.com">
```

**Prefetch routes:**
```typescript
import { useRouter } from 'next/router';

function Component() {
  const router = useRouter();
  
  useEffect(() => {
    router.prefetch('/chat');
  }, [router]);
}
```

### Request Optimization

**Debounce API calls:**
```typescript
import { debounce } from '@/utils/async';

const debouncedSearch = debounce(async (query: string) => {
  const results = await searchConversations(query);
  setResults(results);
}, 300);
```

**Batch requests:**
```typescript
// Instead of multiple requests
await Promise.all([
  fetchModels(),
  fetchStatus(),
  fetchSettings(),
]);
```

## Resource Optimization

### Memory Management

**Cleanup effects:**
```typescript
useEffect(() => {
  const subscription = subscribeToUpdates();
  
  return () => {
    subscription.unsubscribe();
  };
}, []);
```

**Weak references:**
```typescript
const cache = new WeakMap();

function memoize(obj, compute) {
  if (cache.has(obj)) {
    return cache.get(obj);
  }
  const result = compute(obj);
  cache.set(obj, result);
  return result;
}
```

### CPU Optimization

**Web Workers for heavy computations:**
```typescript
// worker.ts
self.addEventListener('message', (e) => {
  const result = performHeavyComputation(e.data);
  self.postMessage(result);
});

// main.ts
const worker = new Worker('/worker.js');
worker.postMessage(data);
worker.onmessage = (e) => {
  console.log('Result:', e.data);
};
```

**RequestIdleCallback:**
```typescript
function processLowPriorityTask() {
  if ('requestIdleCallback' in window) {
    requestIdleCallback(() => {
      performNonUrgentWork();
    });
  } else {
    setTimeout(performNonUrgentWork, 1);
  }
}
```

### Disk Optimization

**IndexedDB for large data:**
```typescript
const openDB = () => {
  return new Promise<IDBDatabase>((resolve, reject) => {
    const request = indexedDB.open('ChatDB', 1);
    
    request.onerror = () => reject(request.error);
    request.onsuccess = () => resolve(request.result);
    
    request.onupgradeneeded = (event) => {
      const db = (event.target as IDBOpenDBRequest).result;
      db.createObjectStore('conversations', { keyPath: 'id' });
    };
  });
};
```

## Monitoring

### Performance Monitoring

**Real User Monitoring:**
```typescript
// Track performance metrics
if (typeof window !== 'undefined') {
  window.addEventListener('load', () => {
    const perfData = window.performance.timing;
    const pageLoadTime = perfData.loadEventEnd - perfData.navigationStart;
    
    // Send to analytics
    console.log('Page load time:', pageLoadTime);
  });
}
```

**Web Vitals:**
```typescript
import { getCLS, getFID, getFCP, getLCP, getTTFB } from 'web-vitals';

function sendToAnalytics(metric) {
  // Send to your analytics endpoint
  console.log(metric);
}

getCLS(sendToAnalytics);
getFID(sendToAnalytics);
getFCP(sendToAnalytics);
getLCP(sendToAnalytics);
getTTFB(sendToAnalytics);
```

### Error Tracking

**Sentry integration:**
```typescript
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  tracesSampleRate: 1.0,
  beforeSend(event) {
    // Filter or modify events
    return event;
  },
});
```

### Custom Metrics

**Track API response times:**
```typescript
const trackAPITime = (endpoint: string, duration: number) => {
  if (window.gtag) {
    window.gtag('event', 'timing_complete', {
      name: endpoint,
      value: duration,
      event_category: 'API',
    });
  }
};
```

## Best Practices

### Development

1. **Profile regularly**
   ```bash
   # Chrome DevTools
   - Open DevTools > Performance
   - Record while using app
   - Analyze bottlenecks
   ```

2. **Use production builds for testing**
   ```bash
   npm run build
   npm start
   ```

3. **Analyze bundle size**
   ```bash
   npm run analyze
   ```

### Code Review Checklist

- [ ] No unnecessary re-renders
- [ ] Proper memoization used
- [ ] Images optimized
- [ ] Code split appropriately
- [ ] No memory leaks
- [ ] Efficient algorithms
- [ ] Proper error handling
- [ ] Caching implemented

### Performance Budget

Set limits and stick to them:

| Metric | Budget |
|--------|--------|
| Initial JS | < 200KB |
| Initial CSS | < 50KB |
| Images | < 500KB total |
| Fonts | < 100KB |
| Total Page | < 1MB |
| TTI | < 3s |
| FCP | < 1s |

### Continuous Optimization

**Regular audits:**
```bash
# Weekly
npm audit
lighthouse http://localhost:3000

# Monthly
npm outdated
npm update
```

**Performance regression testing:**
```javascript
// performance.test.js
describe('Performance', () => {
  it('should load home page in < 3s', async () => {
    const start = Date.now();
    await page.goto('http://localhost:3000');
    const duration = Date.now() - start;
    expect(duration).toBeLessThan(3000);
  });
});
```

## Tools

### Analysis Tools

- **Chrome DevTools** - Built-in performance profiler
- **Lighthouse** - Automated audits
- **WebPageTest** - Real-world performance testing
- **Bundle Analyzer** - Visualize bundle composition

### Monitoring Tools

- **Google Analytics** - User behavior tracking
- **Sentry** - Error and performance monitoring
- **New Relic** - Application performance monitoring
- **Datadog** - Infrastructure monitoring

### Testing Tools

- **Playwright** - E2E testing with performance metrics
- **Artillery** - Load testing
- **k6** - Performance testing

## Optimization Checklist

### Frontend

- [ ] Code splitting implemented
- [ ] Images optimized (WebP, AVIF)
- [ ] Lazy loading enabled
- [ ] React memoization used
- [ ] Virtual scrolling for long lists
- [ ] CSS purged
- [ ] Fonts optimized
- [ ] Service worker implemented

### Backend

- [ ] Caching enabled
- [ ] Database indexed
- [ ] Connection pooling
- [ ] Compression enabled
- [ ] Rate limiting
- [ ] Load balancing
- [ ] CDN configured

### Network

- [ ] HTTP/2 enabled
- [ ] Gzip compression
- [ ] Asset caching
- [ ] DNS prefetching
- [ ] Preconnect hints
- [ ] Resource hints

---

**Remember**: Performance is a feature! 🚀

Regularly measure, optimize, and monitor to maintain excellent performance.
