# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Currently supported versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| 0.9.x   | :x:                |
| < 0.9   | :x:                |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

### How to Report

2. **GitHub Security**: Use GitHub's private security advisory feature
3. **Direct Message**: Contact maintainer @Luka12-dev on GitHub

### What to Include

Please include:
- Type of vulnerability
- Full paths of source file(s) affected
- Location of the affected code
- Step-by-step instructions to reproduce
- Proof-of-concept or exploit code (if possible)
- Impact of the vulnerability
- Suggested fix (if available)

### Response Timeline

- **Initial Response**: Within 48 hours
- **Vulnerability Assessment**: Within 1 week
- **Fix Development**: Within 2 weeks (for critical issues)
- **Patch Release**: As soon as fix is tested
- **Public Disclosure**: After patch is released

## Security Best Practices

### For Users

#### API Key Security

**Never share your API keys:**
```javascript
// ❌ Bad - Keys in code
const apiKey = 'sk-1234567890';

// ✅ Good - Keys in environment
const apiKey = process.env.OPENAI_API_KEY;
```

**Store keys securely:**
- Use environment variables
- Never commit `.env` files
- Rotate keys regularly
- Use key management services

#### Data Privacy

**Local models provide maximum privacy:**
- All processing happens on your machine
- No data sent to external servers
- Complete control over your data

**Cloud models considerations:**
- Data is sent to provider servers
- Review provider privacy policies
- Avoid sending sensitive information
- Use anonymous data when possible

#### Browser Security

**Keep browser updated:**
- Use latest browser version
- Enable automatic updates
- Use secure browsing mode

**Manage local storage:**
- Clear regularly if using shared computers
- Export important conversations
- Use private browsing for sensitive chats

### For Developers

#### Input Validation

**Always validate user input:**

```typescript
import { validateMessage, ValidationError } from '@/lib/validation';

function handleMessage(content: string) {
  try {
    validateMessage(content);
    // Process message
  } catch (error) {
    if (error instanceof ValidationError) {
      // Handle validation error
      console.error('Invalid input:', error.message);
    }
  }
}
```

**Sanitize HTML:**

```typescript
import { sanitizeHTML } from '@/lib/validation';

function displayUserContent(content: string) {
  const safe = sanitizeHTML(content);
  return <div dangerouslySetInnerHTML={{ __html: safe }} />;
}
```

#### API Security

**Rate limiting:**

```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per window
  message: 'Too many requests from this IP'
});

app.use('/api/', limiter);
```

**CORS configuration:**

```javascript
const cors = require('cors');

app.use(cors({
  origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
  credentials: true,
  optionsSuccessStatus: 200
}));
```

**Authentication (if implementing):**

```javascript
const jwt = require('jsonwebtoken');

function authenticateToken(req, res, next) {
  const token = req.headers['authorization']?.split(' ')[1];
  
  if (!token) {
    return res.sendStatus(401);
  }
  
  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
}
```

#### Secure Data Storage

**Encrypt sensitive data:**

```javascript
const crypto = require('crypto');

function encrypt(text, key) {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(key), iv);
  let encrypted = cipher.update(text);
  encrypted = Buffer.concat([encrypted, cipher.final()]);
  return iv.toString('hex') + ':' + encrypted.toString('hex');
}

function decrypt(text, key) {
  const parts = text.split(':');
  const iv = Buffer.from(parts.shift(), 'hex');
  const encrypted = Buffer.from(parts.join(':'), 'hex');
  const decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(key), iv);
  let decrypted = decipher.update(encrypted);
  decrypted = Buffer.concat([decrypted, decipher.final()]);
  return decrypted.toString();
}
```

**Hash passwords (if implementing auth):**

```javascript
const bcrypt = require('bcrypt');

async function hashPassword(password) {
  const saltRounds = 10;
  return await bcrypt.hash(password, saltRounds);
}

async function verifyPassword(password, hash) {
  return await bcrypt.compare(password, hash);
}
```

#### Dependency Security

**Keep dependencies updated:**

```bash
# Check for vulnerabilities
npm audit

# Fix vulnerabilities
npm audit fix

# Update dependencies
npm update
```

**Use package-lock.json:**
- Commit package-lock.json to repository
- Ensures consistent dependency versions
- Prevents supply chain attacks

**Review dependencies:**
- Check package download counts
- Review package source code
- Use tools like Snyk or Dependabot

## Security Features

### Built-in Security

#### Content Security Policy

**Implemented in Next.js config:**

```javascript
// next.config.js
const securityHeaders = [
  {
    key: 'X-DNS-Prefetch-Control',
    value: 'on'
  },
  {
    key: 'Strict-Transport-Security',
    value: 'max-age=63072000; includeSubDomains; preload'
  },
  {
    key: 'X-Frame-Options',
    value: 'SAMEORIGIN'
  },
  {
    key: 'X-Content-Type-Options',
    value: 'nosniff'
  },
  {
    key: 'X-XSS-Protection',
    value: '1; mode=block'
  },
  {
    key: 'Referrer-Policy',
    value: 'origin-when-cross-origin'
  },
  {
    key: 'Permissions-Policy',
    value: 'camera=(), microphone=(), geolocation=()'
  }
];
```

#### XSS Protection

**React's built-in protection:**
- Automatic escaping of values
- Safe JSX rendering
- Controlled `dangerouslySetInnerHTML` usage

**Additional measures:**
```typescript
// Sanitize user input
import DOMPurify from 'dompurify';

function sanitizeUserInput(input: string): string {
  return DOMPurify.sanitize(input, {
    ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'a'],
    ALLOWED_ATTR: ['href']
  });
}
```

#### CSRF Protection

**Token-based protection:**

```typescript
// Generate CSRF token
function generateCSRFToken(): string {
  return crypto.randomBytes(32).toString('hex');
}

// Validate CSRF token
function validateCSRFToken(token: string, storedToken: string): boolean {
  return crypto.timingSafeEqual(
    Buffer.from(token),
    Buffer.from(storedToken)
  );
}
```

#### SQL Injection Prevention

**If using database, use parameterized queries:**

```javascript
// ❌ Bad - vulnerable to SQL injection
const query = `SELECT * FROM users WHERE email = '${userEmail}'`;

// ✅ Good - parameterized query
const query = 'SELECT * FROM users WHERE email = $1';
const result = await db.query(query, [userEmail]);
```

### Environment Security

#### Development vs Production

**Development mode:**
- Detailed error messages
- Source maps enabled
- Debug logging
- Hot reload

**Production mode:**
- Generic error messages
- Source maps disabled
- Minimal logging
- Optimized builds

#### Environment Variables

**Required variables:**

```env
# Production
NODE_ENV=production
SESSION_SECRET=<strong-random-string>
JWT_SECRET=<strong-random-string>

# Optional but recommended
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX=100
```

**Generate secure secrets:**

```bash
# Generate random secret
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Or use openssl
openssl rand -hex 32
```

### Network Security

#### HTTPS Only

**Enforce HTTPS in production:**

```nginx
server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;
    
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    # Strong SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
    ssl_prefer_server_ciphers on;
}
```

#### Firewall Configuration

**UFW (Ubuntu):**

```bash
# Allow SSH, HTTP, HTTPS
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443

# Deny all other incoming
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Enable firewall
sudo ufw enable
```

**iptables:**

```bash
# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP/HTTPS
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Drop all other input
iptables -P INPUT DROP
```

## Vulnerability Disclosure

### Responsible Disclosure

We follow responsible disclosure principles:

1. **Report**: Security researcher reports vulnerability privately
2. **Acknowledge**: We acknowledge receipt within 48 hours
3. **Investigate**: We investigate and develop a fix
4. **Fix**: We release a patch
5. **Disclose**: Public disclosure after patch is available

### Hall of Fame

We recognize security researchers who help us:

- **Name** - Vulnerability type - Date
- (None yet - be the first!)

### Bounty Program

Currently, we do not offer a bug bounty program. However:
- All reports are acknowledged
- Significant findings are credited
- Contributors may receive special recognition

## Compliance and Standards

### Security Standards

We follow these security standards:

- **OWASP Top 10**: Addressing common web vulnerabilities
- **CWE/SANS Top 25**: Most dangerous software weaknesses
- **NIST Guidelines**: Cybersecurity framework
- **GDPR**: Data protection (where applicable)

### Regular Security Audits

**Internal audits:**
- Monthly dependency updates
- Quarterly code reviews
- Annual security assessments

**External audits:**
- Community security reviews
- Penetration testing (as needed)
- Third-party security audits (planned)

## Incident Response

### In Case of Breach

**If you suspect a security breach:**

1. **Stop**: Immediately stop using the affected system
2. **Document**: Record what happened
3. **Report**: Contact maintainers immediately
4. **Preserve**: Don't delete logs or evidence
5. **Wait**: Wait for instructions before proceeding

**What we'll do:**

1. **Assess**: Determine scope and impact
2. **Contain**: Limit further damage
3. **Eradicate**: Remove threat
4. **Recover**: Restore normal operations
5. **Review**: Learn and improve

### Security Incident Log

**No incidents reported** - This is a new release

## Security Configuration Checklist

### Production Deployment

- [ ] HTTPS enabled with valid certificate
- [ ] Security headers configured
- [ ] Rate limiting implemented
- [ ] CORS properly configured
- [ ] Environment variables secured
- [ ] Error messages are generic
- [ ] Logging configured (without sensitive data)
- [ ] Dependencies updated
- [ ] Firewall rules set
- [ ] Regular backups enabled

### Application Security

- [ ] Input validation on all user inputs
- [ ] Output encoding for all user data
- [ ] SQL queries parameterized (if using DB)
- [ ] Authentication implemented (if needed)
- [ ] Authorization checks in place
- [ ] Session management secure
- [ ] CSRF protection enabled
- [ ] XSS protection verified

### Infrastructure Security

- [ ] Server OS updated
- [ ] SSH key authentication only
- [ ] Fail2ban or similar installed
- [ ] Regular security updates scheduled
- [ ] Monitoring and alerting setup
- [ ] Backup system tested
- [ ] Disaster recovery plan documented

## Security Tools

### Recommended Tools

**Static Analysis:**
- ESLint with security plugins
- SonarQube
- Semgrep

**Dependency Scanning:**
- npm audit
- Snyk
- Dependabot

**Runtime Protection:**
- OWASP ModSecurity
- CloudFlare WAF
- Fail2ban

**Monitoring:**
- Sentry (error tracking)
- Prometheus (metrics)
- Grafana (visualization)

### Security Testing

**Automated testing:**

```bash
# Security audit
npm audit

# Dependency check
npm outdated

# License compliance
npx license-checker
```

**Manual testing:**

```bash
# Test with OWASP ZAP
zap-cli quick-scan http://localhost:3000

# Test SSL configuration
nmap --script ssl-enum-ciphers -p 443 your-domain.com

# Test headers
curl -I https://your-domain.com
```

## Security Resources

### Learning Resources

**OWASP Resources:**
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP Cheat Sheets](https://cheatsheetseries.owasp.org/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)

**Security Blogs:**
- [Krebs on Security](https://krebsonsecurity.com/)
- [Schneier on Security](https://www.schneier.com/)
- [Troy Hunt's Blog](https://www.troyhunt.com/)

**Vulnerability Databases:**
- [CVE](https://cve.mitre.org/)
- [NVD](https://nvd.nist.gov/)
- [Snyk Vulnerability DB](https://snyk.io/vuln/)

### Security Communities

**Forums and Groups:**
- OWASP Community
- Reddit r/netsec
- HackerOne Community

**Conferences:**
- DEF CON
- Black Hat
- OWASP AppSec

## Contact

### Security Team

**Primary Contact:**
- GitHub: @Luka12-dev
- Email: (Configure if needed)

**Response Times:**
- Critical: < 24 hours
- High: < 48 hours
- Medium: < 1 week
- Low: < 2 weeks

### Getting Help

For non-security issues:
- GitHub Issues: [Report Bug](https://github.com/Luka12-dev/AI-ChatBot-Web/issues)
- GitHub Discussions: [Ask Question](https://github.com/Luka12-dev/AI-ChatBot-Web/discussions)

For security issues:
- Use private channels only
- Do not disclose publicly until fixed

## Acknowledgments

We thank:
- Security researchers who report vulnerabilities
- Open source security community
- Users who follow security best practices

---

**Last Updated**: January 28, 2025
**Version**: 1.0.0
**Next Review**: April 28, 2025

Stay secure! 🔒
