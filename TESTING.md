# Testing Guide

Comprehensive testing guide for AI ChatBot Web.

## Table of Contents

1. [Testing Philosophy](#testing-philosophy)
2. [Test Types](#test-types)
3. [Running Tests](#running-tests)
4. [Writing Tests](#writing-tests)
5. [Test Coverage](#test-coverage)
6. [Manual Testing](#manual-testing)
7. [Performance Testing](#performance-testing)
8. [Security Testing](#security-testing)

## Testing Philosophy

### Why We Test

- **Quality Assurance**: Ensure code works as intended
- **Prevent Regressions**: Catch bugs before they reach production
- **Documentation**: Tests serve as executable documentation
- **Refactoring Safety**: Make changes with confidence
- **Team Collaboration**: Shared understanding of expected behavior

### Testing Pyramid

```
        /\
       /  \
      / E2E \
     /--------\
    /Integration\
   /--------------\
  /   Unit Tests   \
 /------------------\
```

- **70% Unit Tests**: Fast, focused, isolated
- **20% Integration Tests**: Component interactions
- **10% E2E Tests**: Full user workflows

## Test Types

### Unit Tests

Test individual functions and components in isolation.

**Example - Testing Utility Function:**

```typescript
// helpers.test.ts
import { formatTimestamp, calculateTokens } from '@/utils/helpers';

describe('formatTimestamp', () => {
  it('should format recent timestamps as "Just now"', () => {
    const now = Date.now();
    expect(formatTimestamp(now)).toBe('Just now');
  });

  it('should format minutes ago correctly', () => {
    const fiveMinutesAgo = Date.now() - 5 * 60 * 1000;
    expect(formatTimestamp(fiveMinutesAgo)).toBe('5m ago');
  });

  it('should format hours ago correctly', () => {
    const twoHoursAgo = Date.now() - 2 * 60 * 60 * 1000;
    expect(formatTimestamp(twoHoursAgo)).toBe('2h ago');
  });
});

describe('calculateTokens', () => {
  it('should estimate token count for simple text', () => {
    const text = 'Hello world';
    expect(calculateTokens(text)).toBeGreaterThan(0);
  });

  it('should handle empty strings', () => {
    expect(calculateTokens('')).toBe(0);
  });
});
```

**Example - Testing React Component:**

```typescript
// MessageItem.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import MessageItem from '@/components/MessageItem';

describe('MessageItem', () => {
  const mockMessage = {
    id: '1',
    role: 'user' as const,
    content: 'Test message',
    timestamp: Date.now(),
  };

  it('should render user message correctly', () => {
    render(<MessageItem message={mockMessage} index={0} />);
    expect(screen.getByText('Test message')).toBeInTheDocument();
  });

  it('should show copy button on hover', async () => {
    render(<MessageItem message={mockMessage} index={0} />);
    const messageElement = screen.getByText('Test message').closest('div');
    
    fireEvent.mouseEnter(messageElement!);
    
    const copyButton = await screen.findByLabelText('Copy message');
    expect(copyButton).toBeVisible();
  });

  it('should copy message to clipboard', async () => {
    const clipboardSpy = jest.spyOn(navigator.clipboard, 'writeText');
    
    render(<MessageItem message={mockMessage} index={0} />);
    const messageElement = screen.getByText('Test message').closest('div');
    
    fireEvent.mouseEnter(messageElement!);
    const copyButton = await screen.findByLabelText('Copy message');
    fireEvent.click(copyButton);
    
    expect(clipboardSpy).toHaveBeenCalledWith('Test message');
  });
});
```

### Integration Tests

Test how components work together.

**Example - Testing Chat Flow:**

```typescript
// chat-integration.test.tsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { useChatStore } from '@/store/chatStore';
import MainScreen from '@/components/MainScreen';

describe('Chat Integration', () => {
  beforeEach(() => {
    useChatStore.getState().clearAllData();
  });

  it('should complete full chat flow', async () => {
    render(<MainScreen />);

    // Create new conversation
    const createButton = screen.getByLabelText('New conversation');
    fireEvent.click(createButton);

    // Type message
    const input = screen.getByPlaceholderText('Type your message...');
    fireEvent.change(input, { target: { value: 'Hello AI' } });

    // Send message
    const sendButton = screen.getByLabelText('Send message');
    fireEvent.click(sendButton);

    // Wait for response
    await waitFor(() => {
      expect(screen.getByText('Hello AI')).toBeInTheDocument();
    });

    // Verify conversation created
    const state = useChatStore.getState();
    expect(state.conversations.length).toBe(1);
    expect(state.conversations[0].messages.length).toBeGreaterThan(0);
  });
});
```

### End-to-End Tests

Test complete user workflows using tools like Playwright or Cypress.

**Example - E2E Test with Playwright:**

```typescript
// e2e/chat.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Chat Application', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:3000');
  });

  test('should start a conversation', async ({ page }) => {
    // Click start button
    await page.click('text=Start Conversation');

    // Wait for main screen
    await expect(page.locator('textarea[placeholder*="Type your message"]')).toBeVisible();

    // Type and send message
    await page.fill('textarea[placeholder*="Type your message"]', 'Hello');
    await page.press('textarea[placeholder*="Type your message"]', 'Enter');

    // Verify message appears
    await expect(page.locator('text=Hello')).toBeVisible();
  });

  test('should switch themes', async ({ page }) => {
    await page.click('text=Start Conversation');

    // Click theme toggle
    await page.click('[aria-label="Toggle theme"]');

    // Verify dark theme applied
    const html = page.locator('html');
    await expect(html).toHaveClass(/dark/);
  });

  test('should open sidebar', async ({ page }) => {
    await page.click('text=Start Conversation');

    // Click menu button
    await page.click('[aria-label="Toggle sidebar"]');

    // Verify sidebar visible
    await expect(page.locator('text=AI ChatBot')).toBeVisible();
  });
});
```

## Running Tests

### Setup

```bash
# Install dependencies
npm install

# Install test dependencies
npm install --save-dev @testing-library/react @testing-library/jest-dom jest
```

### Run Commands

```bash
# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm test -- --coverage

# Run specific test file
npm test MessageItem.test.tsx

# Run tests matching pattern
npm test -- --testNamePattern="should render"
```

### Configuration

**jest.config.js:**

```javascript
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/$1',
    '\\.(css|less|scss|sass)$': 'identity-obj-proxy',
  },
  collectCoverageFrom: [
    'components/**/*.{ts,tsx}',
    'lib/**/*.{ts,tsx}',
    'utils/**/*.{ts,tsx}',
    '!**/*.d.ts',
    '!**/node_modules/**',
  ],
  coverageThresholds: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
};
```

**jest.setup.js:**

```javascript
import '@testing-library/jest-dom';

// Mock next/router
jest.mock('next/router', () => ({
  useRouter: () => ({
    push: jest.fn(),
    pathname: '/',
    query: {},
    asPath: '/',
  }),
}));

// Mock window.matchMedia
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: jest.fn().mockImplementation(query => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: jest.fn(),
    removeListener: jest.fn(),
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    dispatchEvent: jest.fn(),
  })),
});
```

## Writing Tests

### Best Practices

**1. Arrange-Act-Assert Pattern:**

```typescript
it('should format timestamp correctly', () => {
  // Arrange
  const timestamp = Date.now() - 5 * 60 * 1000;
  
  // Act
  const result = formatTimestamp(timestamp);
  
  // Assert
  expect(result).toBe('5m ago');
});
```

**2. Descriptive Test Names:**

```typescript
// ❌ Bad
it('works', () => { });

// ✅ Good
it('should format timestamps less than 60 seconds as "Just now"', () => { });
```

**3. Test One Thing:**

```typescript
// ❌ Bad - testing multiple things
it('should work', () => {
  expect(add(1, 2)).toBe(3);
  expect(subtract(5, 2)).toBe(3);
  expect(multiply(2, 3)).toBe(6);
});

// ✅ Good - separate tests
it('should add two numbers', () => {
  expect(add(1, 2)).toBe(3);
});

it('should subtract two numbers', () => {
  expect(subtract(5, 2)).toBe(3);
});
```

**4. Use Test Doubles:**

```typescript
// Mock API calls
jest.mock('@/lib/api', () => ({
  chatAPI: {
    sendMessage: jest.fn().mockResolvedValue({
      success: true,
      data: { message: { content: 'Response' } }
    }),
  },
}));

// Mock hooks
jest.mock('@/hooks/useChat', () => ({
  useChat: () => ({
    sendMessage: jest.fn(),
    isLoading: false,
  }),
}));
```

### Testing Async Code

```typescript
it('should handle async operations', async () => {
  const promise = asyncFunction();
  await expect(promise).resolves.toBe('success');
});

it('should handle errors', async () => {
  const promise = asyncFunctionThatFails();
  await expect(promise).rejects.toThrow('Error message');
});
```

### Testing Hooks

```typescript
import { renderHook, act } from '@testing-library/react';
import { useChat } from '@/hooks/useChat';

it('should send message', async () => {
  const { result } = renderHook(() => useChat());
  
  await act(async () => {
    await result.current.sendMessage('Hello');
  });
  
  expect(result.current.isLoading).toBe(false);
});
```

## Test Coverage

### Measuring Coverage

```bash
# Generate coverage report
npm test -- --coverage

# View HTML report
open coverage/lcov-report/index.html
```

### Coverage Goals

- **Overall**: 80%+
- **Critical Paths**: 100%
- **UI Components**: 70%+
- **Utilities**: 90%+
- **API Layer**: 85%+

### Coverage Reports

```bash
# Text summary
npm test -- --coverage --coverageReporters=text

# HTML report
npm test -- --coverage --coverageReporters=html

# Multiple formats
npm test -- --coverage --coverageReporters=text --coverageReporters=lcov
```

## Manual Testing

### Test Checklist

#### Functional Testing

- [ ] Start new conversation
- [ ] Send messages
- [ ] Receive responses
- [ ] Stream responses
- [ ] Cancel streaming
- [ ] Switch models
- [ ] Change themes
- [ ] Open/close sidebar
- [ ] Search conversations
- [ ] Export conversations
- [ ] Import conversations
- [ ] Delete conversations
- [ ] Adjust settings
- [ ] Use keyboard shortcuts

#### UI/UX Testing

- [ ] Responsive on mobile
- [ ] Responsive on tablet
- [ ] Responsive on desktop
- [ ] Animations smooth
- [ ] Transitions work
- [ ] Loading states clear
- [ ] Error states helpful
- [ ] Empty states appropriate
- [ ] Touch gestures work
- [ ] Keyboard navigation works

#### Browser Testing

- [ ] Chrome latest
- [ ] Firefox latest
- [ ] Safari latest
- [ ] Edge latest
- [ ] Mobile Chrome
- [ ] Mobile Safari

#### Accessibility Testing

- [ ] Screen reader compatible
- [ ] Keyboard navigable
- [ ] Focus indicators visible
- [ ] Color contrast sufficient
- [ ] Alt text for images
- [ ] ARIA labels present

## Performance Testing

### Load Time Testing

```bash
# Lighthouse CLI
npm install -g lighthouse
lighthouse http://localhost:3000 --view

# WebPageTest
# Use https://www.webpagetest.org/
```

### Bundle Size Analysis

```bash
# Analyze bundle
npm run build
npm run analyze

# Check specific imports
npm install -g source-map-explorer
source-map-explorer 'build/static/js/*.js'
```

### Performance Benchmarks

```typescript
// performance.test.ts
describe('Performance', () => {
  it('should render list of 1000 messages in < 100ms', () => {
    const messages = Array.from({ length: 1000 }, (_, i) => ({
      id: String(i),
      role: 'user',
      content: `Message ${i}`,
      timestamp: Date.now(),
    }));

    const start = performance.now();
    render(<MessageList messages={messages} />);
    const end = performance.now();

    expect(end - start).toBeLessThan(100);
  });
});
```

## Security Testing

### Automated Security Tests

```bash
# npm audit
npm audit

# Snyk scan
npx snyk test

# OWASP dependency check
npm install -g owasp-dependency-check
dependency-check package.json
```

### Manual Security Testing

- [ ] Input validation working
- [ ] XSS protection active
- [ ] CSRF protection enabled
- [ ] API rate limiting works
- [ ] Authentication secure (if applicable)
- [ ] Session management secure
- [ ] Sensitive data encrypted
- [ ] HTTPS enforced

### Penetration Testing

```bash
# OWASP ZAP
zap-cli quick-scan http://localhost:3000

# Burp Suite
# Manual testing with Burp Suite Community
```

## Continuous Integration

### GitHub Actions

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          
      - name: Install dependencies
        run: |
          cd src
          npm ci
          
      - name: Run tests
        run: |
          cd src
          npm test -- --coverage
          
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./src/coverage/lcov.info
```

## Debugging Tests

### Debug Mode

```bash
# Run tests in debug mode
node --inspect-brk node_modules/.bin/jest --runInBand

# Then open chrome://inspect in Chrome
```

### VS Code Debugging

```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Jest Debug",
      "program": "${workspaceFolder}/node_modules/.bin/jest",
      "args": ["--runInBand", "--no-cache"],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen"
    }
  ]
}
```

## Test Data

### Fixtures

```typescript
// fixtures/messages.ts
export const mockMessages = [
  {
    id: '1',
    role: 'user' as const,
    content: 'Hello',
    timestamp: Date.now(),
  },
  {
    id: '2',
    role: 'assistant' as const,
    content: 'Hi there!',
    timestamp: Date.now(),
  },
];

// Use in tests
import { mockMessages } from './fixtures/messages';
```

### Factories

```typescript
// factories/message.factory.ts
export function createMessage(overrides = {}) {
  return {
    id: Math.random().toString(),
    role: 'user',
    content: 'Test message',
    timestamp: Date.now(),
    ...overrides,
  };
}

// Use in tests
const message = createMessage({ content: 'Custom content' });
```

## Resources

### Documentation
- [Jest Docs](https://jestjs.io/)
- [React Testing Library](https://testing-library.com/react)
- [Playwright Docs](https://playwright.dev/)

### Learning
- [Kent C. Dodds Testing Course](https://testingjavascript.com/)
- [Testing JavaScript Podcast](https://testingjavascript.com/podcast)

---

**Remember**: Good tests make confident developers! 🧪
