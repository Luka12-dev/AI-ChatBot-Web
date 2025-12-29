# Contributing to AI ChatBot Web

Thank you for your interest in contributing to AI ChatBot Web! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Development Setup](#development-setup)
4. [Project Structure](#project-structure)
5. [Coding Standards](#coding-standards)
6. [Commit Guidelines](#commit-guidelines)
7. [Pull Request Process](#pull-request-process)
8. [Testing](#testing)
9. [Documentation](#documentation)
10. [Community](#community)

## Code of Conduct

### Our Pledge

We as members, contributors, and leaders pledge to make participation in our community a harassment-free experience for everyone, regardless of age, body size, visible or invisible disability, ethnicity, sex characteristics, gender identity and expression, level of experience, education, socio-economic status, nationality, personal appearance, race or religion and orientation.

### Our Standards

**Positive behavior includes:**

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Unacceptable behavior includes:**

- The use of sexualized language or imagery
- Trolling, insulting or derogatory comments
- Public or private harassment
- Publishing others' private information
- Other conduct which could reasonably be considered inappropriate

### Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported to the project team. All complaints will be reviewed and investigated promptly and fairly.

## Getting Started

### Prerequisites

Before you begin, ensure you have:

- Node.js v18 or higher
- npm or yarn
- Git
- Ollama (for testing local models)
- A code editor (VS Code recommended)

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:

```bash
git clone https://github.com/Luka12-dev/AI-ChatBot-Web.git
cd AI-ChatBot-Web
```

3. Add upstream remote:

```bash
git remote add upstream https://github.com/Luka12-dev/AI-ChatBot-Web.git
```

### Create a Branch

Create a branch for your changes:

```bash
git checkout -b feature/your-feature-name
```

**Branch Naming Conventions:**

- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Adding tests
- `chore/` - Maintenance tasks

Examples:
- `feature/add-dark-mode`
- `fix/api-connection-timeout`
- `docs/update-installation-guide`

## Development Setup

### Install Dependencies

```bash
cd src
npm install
```

### Environment Setup

Create `.env` file in `src/backend/`:

```env
PORT=5000
OLLAMA_HOST=http://localhost:11434
NODE_ENV=development
```

### Start Development Servers

Terminal 1 (Frontend):
```bash
cd src
npm run dev
```

Terminal 2 (Backend):
```bash
cd src
npm run server:dev
```

### Verify Setup

1. Open http://localhost:3000
2. Check console for errors
3. Verify Ollama connection
4. Test sending a message

## Project Structure

```
AI-ChatBot-Web/
├── src/
│   ├── components/          # React components
│   │   ├── StartScreen.tsx  # Start screen
│   │   ├── MainScreen.tsx   # Main chat interface
│   │   ├── Sidebar.tsx      # Swipeable sidebar
│   │   ├── Header.tsx       # Top header bar
│   │   ├── MessageList.tsx  # Message display
│   │   ├── MessageItem.tsx  # Individual message
│   │   ├── ChatInput.tsx    # Message input
│   │   └── sidebar/         # Sidebar components
│   ├── pages/               # Next.js pages
│   │   ├── _app.tsx         # App wrapper
│   │   ├── _document.tsx    # Document setup
│   │   └── index.tsx        # Home page
│   ├── hooks/               # Custom React hooks
│   │   ├── useChat.ts       # Chat functionality
│   │   ├── useTheme.ts      # Theme management
│   │   └── useKeyboard.ts   # Keyboard shortcuts
│   ├── store/               # State management
│   │   ├── chatStore.ts     # Chat state
│   │   └── modelStore.ts    # Model state
│   ├── lib/                 # Core utilities
│   │   ├── api.ts           # API client
│   │   ├── constants.ts     # Constants
│   │   ├── streaming.ts     # Stream handling
│   │   └── validation.ts    # Input validation
│   ├── utils/               # Helper functions
│   │   ├── helpers.ts       # General helpers
│   │   ├── array.ts         # Array utilities
│   │   ├── object.ts        # Object utilities
│   │   ├── string.ts        # String utilities
│   │   ├── date.ts          # Date utilities
│   │   ├── markdown.ts      # Markdown processing
│   │   └── formatting.ts    # Formatting functions
│   ├── types/               # TypeScript types
│   │   └── index.ts         # Type definitions
│   ├── styles/              # Stylesheets
│   │   └── globals.css      # Global styles
│   ├── backend/             # Backend server
│   │   ├── server.js        # Express server
│   │   └── .env.example     # Environment template
│   └── public/              # Static assets
├── models/                  # Model download scripts
│   ├── download-model.ps1   # PowerShell script
│   ├── download-model.sh    # Bash script
│   └── download-model.bat   # Batch script
├── run.ps1                  # Launch script (Windows)
├── run.sh                   # Launch script (Linux/Mac)
├── README.md                # Project overview
├── INSTALLATION.md          # Install guide
├── USER_GUIDE.md            # User documentation
├── API_DOCUMENTATION.md     # API reference
└── CONTRIBUTING.md          # This file
```

### Key Directories

**Components**: React UI components. Each should be focused and reusable.

**Hooks**: Custom React hooks for shared logic. Follow the `use` prefix convention.

**Store**: Zustand stores for global state. Keep stores focused on specific domains.

**Utils**: Pure utility functions. Should be testable and side-effect free.

**Backend**: Node.js/Express server. Handles API requests and model communication.

## Coding Standards

### TypeScript

We use TypeScript for type safety. Follow these guidelines:

**Types vs Interfaces:**
```typescript
// Use interfaces for object shapes
interface User {
  id: string;
  name: string;
}

// Use types for unions, intersections
type Status = 'active' | 'inactive';
type UserWithStatus = User & { status: Status };
```

**Avoid `any`:**
```typescript
// Bad
function process(data: any) { }

// Good
function process(data: unknown) {
  if (typeof data === 'string') {
    // Now TypeScript knows data is string
  }
}
```

**Use explicit return types:**
```typescript
// Bad
function getUser(id: string) {
  return users.find(u => u.id === id);
}

// Good
function getUser(id: string): User | undefined {
  return users.find(u => u.id === id);
}
```

### React Components

**Functional Components:**
```typescript
// Use function declaration
export default function ComponentName({ prop }: Props) {
  return <div>{prop}</div>;
}

// Not arrow functions at top level
```

**Props Interface:**
```typescript
interface ComponentProps {
  title: string;
  onSubmit: (value: string) => void;
  optional?: number;
}

export default function Component({ title, onSubmit, optional }: ComponentProps) {
  // Component code
}
```

**State Management:**
```typescript
// Use appropriate hooks
const [value, setValue] = useState<string>('');
const memoizedValue = useMemo(() => expensiveOperation(), [dep]);
const callback = useCallback(() => { }, [dep]);
```

### File Naming

- Components: `PascalCase.tsx` (e.g., `MessageList.tsx`)
- Utilities: `camelCase.ts` (e.g., `helpers.ts`)
- Hooks: `useCamelCase.ts` (e.g., `useChat.ts`)
- Types: `camelCase.ts` or `PascalCase.ts`
- Constants: `SCREAMING_SNAKE_CASE` in files

### Code Style

**Formatting:**
- Use 2 spaces for indentation
- Max line length: 100 characters
- Use single quotes for strings
- Add trailing commas
- Use semicolons

**Naming:**
```typescript
// Variables and functions: camelCase
const userName = 'John';
function getUserById(id: string) { }

// Classes and interfaces: PascalCase
class UserManager { }
interface UserData { }

// Constants: SCREAMING_SNAKE_CASE
const MAX_RETRY_COUNT = 3;
const API_BASE_URL = 'https://api.example.com';

// Private members: _camelCase
class MyClass {
  private _internalState: number;
}
```

**Comments:**
```typescript
// Use // for single-line comments

/**
 * Use JSDoc for functions and classes
 * @param id - User identifier
 * @returns User object or undefined
 */
function getUser(id: string): User | undefined {
  return users.find(u => u.id === id);
}
```

### Best Practices

**DRY (Don't Repeat Yourself):**
```typescript
// Bad
function formatUserName(user: User) {
  return user.firstName + ' ' + user.lastName;
}
function formatAdminName(admin: Admin) {
  return admin.firstName + ' ' + admin.lastName;
}

// Good
function formatFullName(person: { firstName: string; lastName: string }) {
  return `${person.firstName} ${person.lastName}`;
}
```

**Single Responsibility:**
```typescript
// Bad - does too many things
function processUserDataAndSave(data: any) {
  const validated = validate(data);
  const transformed = transform(validated);
  const saved = save(transformed);
  sendEmail(saved);
  return saved;
}

// Good - focused responsibilities
function processUserData(data: UserInput): User {
  const validated = validateUserData(data);
  return transformUserData(validated);
}
```

**Error Handling:**
```typescript
// Always handle errors
try {
  await riskyOperation();
} catch (error) {
  console.error('Operation failed:', error);
  // Handle error appropriately
  throw new Error('Failed to complete operation');
}
```

## Commit Guidelines

### Commit Messages

Follow the Conventional Commits specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(chat): add streaming support for responses

Implement server-sent events for real-time message streaming.
This provides better user experience with immediate feedback.

Closes #123
```

```
fix(sidebar): correct swipe gesture on mobile devices

The swipe threshold was too high, making it difficult to open
the sidebar on mobile. Reduced threshold from 100px to 50px.

Fixes #456
```

```
docs(readme): update installation instructions

Added troubleshooting section for common Windows issues.
```

### Commit Best Practices

1. **Keep commits atomic**: One logical change per commit
2. **Write descriptive messages**: Explain what and why
3. **Reference issues**: Use "Closes #123" or "Fixes #456"
4. **Test before committing**: Ensure code works
5. **Commit often**: Don't wait too long between commits

## Pull Request Process

### Before Submitting

1. **Update your branch:**
```bash
git fetch upstream
git rebase upstream/main
```

2. **Run tests:**
```bash
npm test
npm run lint
```

3. **Build successfully:**
```bash
npm run build
```

4. **Update documentation** if needed

### Creating a Pull Request

1. Push your branch:
```bash
git push origin feature/your-feature-name
```

2. Go to GitHub and create a Pull Request

3. Fill out the PR template:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
Describe testing performed

## Screenshots
If applicable, add screenshots

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests added/updated
- [ ] All tests passing
```

### PR Guidelines

**Title Format:**
```
feat: Add dark mode toggle
fix: Resolve API timeout issue
docs: Update contribution guidelines
```

**Description Requirements:**
- Clear explanation of changes
- Reason for changes
- Any breaking changes
- Related issues

**Review Process:**
1. Automated checks must pass
2. At least one maintainer review required
3. Address review comments
4. Maintainer merges when approved

### After PR is Merged

1. Delete your branch:
```bash
git branch -d feature/your-feature-name
git push origin --delete feature/your-feature-name
```

2. Update your local main:
```bash
git checkout main
git pull upstream main
```

## Testing

### Running Tests

```bash
# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with coverage
npm test -- --coverage
```

### Writing Tests

**Component Tests:**
```typescript
import { render, screen } from '@testing-library/react';
import MessageItem from '@/components/MessageItem';

describe('MessageItem', () => {
  it('renders user message correctly', () => {
    const message = {
      id: '1',
      role: 'user',
      content: 'Hello',
      timestamp: Date.now(),
    };

    render(<MessageItem message={message} index={0} />);
    
    expect(screen.getByText('Hello')).toBeInTheDocument();
  });
});
```

**Utility Tests:**
```typescript
import { formatTimestamp } from '@/utils/helpers';

describe('formatTimestamp', () => {
  it('formats recent timestamps correctly', () => {
    const now = Date.now();
    expect(formatTimestamp(now)).toBe('Just now');
  });

  it('formats minutes ago', () => {
    const fiveMinutesAgo = Date.now() - 5 * 60 * 1000;
    expect(formatTimestamp(fiveMinutesAgo)).toBe('5m ago');
  });
});
```

### Test Coverage

Aim for:
- **80%+ overall coverage**
- **100% for critical paths**
- **All edge cases covered**

## Documentation

### Code Documentation

**Document complex logic:**
```typescript
/**
 * Processes streaming chunks from the AI model response.
 * 
 * This function handles the following:
 * - Decodes binary chunks to text
 * - Parses SSE format
 * - Accumulates partial JSON
 * - Emits complete messages
 * 
 * @param reader - ReadableStream reader
 * @param onChunk - Callback for each complete chunk
 * @throws {Error} If stream is interrupted or malformed
 */
async function processStream(
  reader: ReadableStreamDefaultReader,
  onChunk: (chunk: StreamChunk) => void
): Promise<void> {
  // Implementation
}
```

### README Updates

Update README.md when:
- Adding new features
- Changing setup process
- Modifying requirements
- Adding new dependencies

### API Documentation

Update API_DOCUMENTATION.md for:
- New endpoints
- Changed parameters
- New response formats
- Additional error codes

### User Guide

Update USER_GUIDE.md for:
- New UI features
- Changed workflows
- New keyboard shortcuts
- Updated settings

## Community

### Getting Help

**Questions:**
- Open a GitHub Discussion
- Check existing Issues
- Read documentation

**Bugs:**
- Search existing issues first
- Create detailed bug report
- Include reproduction steps
- Add system information

**Feature Requests:**
- Check if already requested
- Explain use case
- Describe expected behavior
- Consider implementation

### Communication Channels

- **GitHub Issues**: Bug reports and features
- **GitHub Discussions**: Questions and ideas
- **Pull Requests**: Code contributions
- **YouTube**: Video tutorials and updates

### Recognition

Contributors are recognized in:
- README.md contributors section
- Release notes
- Project documentation

Significant contributors may receive:
- Commit access
- Maintainer role
- Special thanks in releases

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

## Questions?

If you have questions about contributing, please:
1. Check this guide thoroughly
2. Search existing issues/discussions
3. Open a new discussion
4. Tag @Luka12-dev for urgent matters

Thank you for contributing to AI ChatBot Web! 🚀

---

**Last Updated**: December 2025
**Maintainer**: Luka12-dev
**GitHub**: https://github.com/Luka12-dev/AI-ChatBot-Web
