# Deployment Guide

Comprehensive guide for deploying AI ChatBot Web to production environments.

## Table of Contents

1. [Pre-Deployment Checklist](#pre-deployment-checklist)
2. [Environment Setup](#environment-setup)
3. [Build Process](#build-process)
4. [Deployment Options](#deployment-options)
5. [Server Configuration](#server-configuration)
6. [Database Setup](#database-setup)
7. [Monitoring and Logging](#monitoring-and-logging)
8. [Backup and Recovery](#backup-and-recovery)
9. [Scaling](#scaling)
10. [Security](#security)
11. [Troubleshooting](#troubleshooting)

## Pre-Deployment Checklist

### Before You Deploy

- [ ] All tests passing
- [ ] Production build succeeds
- [ ] Environment variables configured
- [ ] Database migrations completed
- [ ] SSL certificates obtained
- [ ] Domain name configured
- [ ] Backup system in place
- [ ] Monitoring tools setup
- [ ] Security audit completed
- [ ] Documentation updated

### Performance Checklist

- [ ] Images optimized
- [ ] Code minified
- [ ] Lazy loading implemented
- [ ] Caching configured
- [ ] CDN setup (if applicable)
- [ ] Database indexed
- [ ] API rate limiting enabled

### Security Checklist

- [ ] HTTPS enabled
- [ ] Environment secrets secured
- [ ] CORS configured properly
- [ ] Input validation in place
- [ ] XSS protection enabled
- [ ] CSRF protection enabled
- [ ] Security headers configured
- [ ] Dependencies updated

## Environment Setup

### Production Environment Variables

Create `.env.production` in `src/backend/`:

```env
# Server Configuration
NODE_ENV=production
PORT=5000
HOST=0.0.0.0

# Ollama Configuration
OLLAMA_HOST=http://localhost:11434

# Security
SESSION_SECRET=your-secure-random-string
JWT_SECRET=your-jwt-secret

# CORS
CORS_ORIGIN=https://your-domain.com

# Logging
LOG_LEVEL=info
LOG_FILE=/var/log/ai-chatbot/app.log

# Rate Limiting
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX_REQUESTS=100

# Database (if using)
DATABASE_URL=postgresql://user:password@localhost:5432/aichatbot

# Monitoring
SENTRY_DSN=your-sentry-dsn
ANALYTICS_ID=your-analytics-id
```

### Frontend Environment

Create `.env.production` in `src/`:

```env
NEXT_PUBLIC_API_URL=https://api.your-domain.com
NEXT_PUBLIC_WS_URL=wss://api.your-domain.com
NEXT_PUBLIC_ENV=production
```

## Build Process

### Build for Production

```bash
cd src

# Install dependencies
npm ci

# Run tests
npm test

# Build frontend
npm run build

# Verify build
ls -la .next/

# Build backend (if needed)
npm run build:backend
```

### Optimize Build

**Next.js Configuration** (`next.config.js`):

```javascript
module.exports = {
  // Production optimizations
  swcMinify: true,
  compress: true,
  productionBrowserSourceMaps: false,
  
  // Image optimization
  images: {
    domains: ['your-cdn-domain.com'],
    formats: ['image/avif', 'image/webp'],
  },
  
  // Headers for security
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
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
          }
        ]
      }
    ];
  }
};
```

### Build Verification

```bash
# Check bundle size
npm run analyze

# Test production build locally
npm run start

# Load test
ab -n 1000 -c 10 http://localhost:3000/
```

## Deployment Options

### Option 1: VPS (Ubuntu/Debian)

#### Server Requirements

- **CPU**: 4+ cores
- **RAM**: 8+ GB
- **Storage**: 50+ GB SSD
- **OS**: Ubuntu 20.04+ or Debian 11+

#### Installation Steps

**1. Update System:**
```bash
sudo apt update && sudo apt upgrade -y
```

**2. Install Node.js:**
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
node --version  # Verify installation
```

**3. Install PM2:**
```bash
sudo npm install -g pm2
```

**4. Install Nginx:**
```bash
sudo apt install -y nginx
```

**5. Install Ollama:**
```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

**6. Clone Repository:**
```bash
cd /var/www
sudo git clone https://github.com/Luka12-dev/AI-ChatBot-Web.git
cd AI-ChatBot-Web
```

**7. Install Dependencies:**
```bash
cd src
npm ci --production
npm run build
```

**8. Setup PM2:**
```bash
# Start backend
pm2 start backend/server.js --name ai-chatbot-backend

# Start frontend
pm2 start npm --name ai-chatbot-frontend -- start

# Save PM2 configuration
pm2 save

# Setup startup script
pm2 startup
```

**9. Configure Nginx:**

Create `/etc/nginx/sites-available/ai-chatbot`:

```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com;
    
    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    
    # Frontend
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
    
    # Backend API
    location /api {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # Increase timeout for AI responses
        proxy_read_timeout 300s;
        proxy_connect_timeout 75s;
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json;
    
    # Access logs
    access_log /var/log/nginx/ai-chatbot-access.log;
    error_log /var/log/nginx/ai-chatbot-error.log;
}
```

Enable site:
```bash
sudo ln -s /etc/nginx/sites-available/ai-chatbot /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

**10. Setup SSL with Let's Encrypt:**
```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

**11. Configure Firewall:**
```bash
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

### Option 2: Docker Deployment

#### Dockerfile

Create `Dockerfile` in project root:

```dockerfile
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY src/package*.json ./

# Install dependencies
RUN npm ci --production

# Copy source code
COPY src/ ./

# Build application
RUN npm run build

# Production image
FROM node:18-alpine

WORKDIR /app

# Copy built files
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/backend ./backend

# Expose ports
EXPOSE 3000 5000

# Start application
CMD ["npm", "start"]
```

#### Docker Compose

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  frontend:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - NEXT_PUBLIC_API_URL=http://backend:5000
    depends_on:
      - backend
    restart: unless-stopped

  backend:
    build: .
    command: node backend/server.js
    ports:
      - "5000:5000"
    environment:
      - NODE_ENV=production
      - PORT=5000
      - OLLAMA_HOST=http://ollama:11434
    depends_on:
      - ollama
    restart: unless-stopped

  ollama:
    image: ollama/ollama:latest
    ports:
      - "11434:11434"
    volumes:
      - ollama-data:/root/.ollama
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - frontend
      - backend
    restart: unless-stopped

volumes:
  ollama-data:
```

#### Deploy with Docker

```bash
# Build images
docker-compose build

# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Option 3: Cloud Platforms

#### Vercel (Frontend Only)

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
cd src
vercel --prod
```

#### Heroku

```bash
# Install Heroku CLI
# ...then:

heroku create ai-chatbot-app
heroku addons:create heroku-postgresql:hobby-dev

git push heroku main

heroku ps:scale web=1
heroku open
```

#### AWS (EC2 + S3 + CloudFront)

1. **Launch EC2 Instance**
   - AMI: Ubuntu 20.04
   - Instance Type: t3.medium or larger
   - Security Group: Allow ports 22, 80, 443

2. **Setup Application** (same as VPS)

3. **Configure S3 for Static Assets**
```bash
aws s3 mb s3://your-bucket-name
aws s3 sync .next/static s3://your-bucket-name/static
```

4. **Setup CloudFront CDN**
   - Create distribution
   - Origin: S3 bucket
   - Configure caching
   - Add custom domain

#### DigitalOcean App Platform

Create `app.yaml`:

```yaml
name: ai-chatbot
services:
  - name: web
    github:
      repo: Luka12-dev/AI-ChatBot-Web
      branch: main
      deploy_on_push: true
    build_command: cd src && npm ci && npm run build
    run_command: cd src && npm start
    envs:
      - key: NODE_ENV
        value: production
    http_port: 3000
    instance_count: 1
    instance_size_slug: professional-xs
```

## Server Configuration

### PM2 Ecosystem File

Create `ecosystem.config.js`:

```javascript
module.exports = {
  apps: [
    {
      name: 'ai-chatbot-frontend',
      script: 'npm',
      args: 'start',
      cwd: '/var/www/AI-ChatBot-Web/src',
      instances: 2,
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      error_file: '/var/log/ai-chatbot/frontend-error.log',
      out_file: '/var/log/ai-chatbot/frontend-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
      merge_logs: true
    },
    {
      name: 'ai-chatbot-backend',
      script: './backend/server.js',
      cwd: '/var/www/AI-ChatBot-Web/src',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production',
        PORT: 5000
      },
      error_file: '/var/log/ai-chatbot/backend-error.log',
      out_file: '/var/log/ai-chatbot/backend-out.log',
      log_date_format: 'YYYY-MM-DD HH:mm:ss Z'
    }
  ]
};
```

Start with ecosystem:
```bash
pm2 start ecosystem.config.js
pm2 save
```

### Systemd Service

Create `/etc/systemd/system/ai-chatbot.service`:

```ini
[Unit]
Description=AI ChatBot Application
After=network.target

[Service]
Type=forking
User=www-data
WorkingDirectory=/var/www/AI-ChatBot-Web
Environment="NODE_ENV=production"
ExecStart=/usr/bin/pm2 start ecosystem.config.js
ExecReload=/usr/bin/pm2 reload ecosystem.config.js
ExecStop=/usr/bin/pm2 stop ecosystem.config.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Enable service:
```bash
sudo systemctl enable ai-chatbot
sudo systemctl start ai-chatbot
sudo systemctl status ai-chatbot
```

## Database Setup

### PostgreSQL (Optional)

If storing conversations in database:

**Install PostgreSQL:**
```bash
sudo apt install -y postgresql postgresql-contrib
```

**Create Database:**
```sql
CREATE DATABASE aichatbot;
CREATE USER aichatbot_user WITH ENCRYPTED PASSWORD 'your-password';
GRANT ALL PRIVILEGES ON DATABASE aichatbot TO aichatbot_user;
```

**Schema:**
```sql
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    user_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    model VARCHAR(100),
    settings JSONB
);

CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID REFERENCES conversations(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL,
    content TEXT NOT NULL,
    timestamp BIGINT NOT NULL,
    model VARCHAR(100),
    tokens INTEGER
);

CREATE INDEX idx_conversations_user ON conversations(user_id);
CREATE INDEX idx_conversations_updated ON conversations(updated_at DESC);
CREATE INDEX idx_messages_conversation ON messages(conversation_id);
CREATE INDEX idx_messages_timestamp ON messages(timestamp DESC);
```

### Redis (Caching)

**Install Redis:**
```bash
sudo apt install -y redis-server
```

**Configure Redis:**
Edit `/etc/redis/redis.conf`:
```
maxmemory 256mb
maxmemory-policy allkeys-lru
```

**Use in Application:**
```javascript
const redis = require('redis');
const client = redis.createClient();

// Cache model responses
async function getCachedResponse(key) {
  return await client.get(key);
}

async function setCachedResponse(key, value, ttl = 3600) {
  await client.setEx(key, ttl, value);
}
```

## Monitoring and Logging

### PM2 Monitoring

```bash
# View status
pm2 status

# View logs
pm2 logs

# Monitor resources
pm2 monit

# Web dashboard
pm2 web
```

### Log Rotation

Create `/etc/logrotate.d/ai-chatbot`:

```
/var/log/ai-chatbot/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data www-data
    sharedscripts
    postrotate
        pm2 reloadLogs
    endscript
}
```

### Error Tracking (Sentry)

**Install:**
```bash
npm install @sentry/node @sentry/nextjs
```

**Configure:**
```javascript
// sentry.client.config.js
import * as Sentry from '@sentry/nextjs';

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0,
});
```

### Uptime Monitoring

**Using Uptime Robot:**
1. Sign up at https://uptimerobot.com
2. Add HTTP(S) monitor
3. Set URL: https://your-domain.com
4. Configure alerts

**Using Pingdom:**
1. Create account
2. Add uptime check
3. Configure alerts
4. View reports

## Backup and Recovery

### Automated Backups

**Backup Script** (`backup.sh`):

```bash
#!/bin/bash

# Configuration
BACKUP_DIR="/backups/ai-chatbot"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backup_$DATE.tar.gz"

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup application files
tar -czf $BACKUP_DIR/$BACKUP_FILE \
    /var/www/AI-ChatBot-Web/src \
    /etc/nginx/sites-available/ai-chatbot

# Backup database (if using PostgreSQL)
pg_dump aichatbot > $BACKUP_DIR/db_$DATE.sql

# Backup PM2 configuration
pm2 save

# Keep only last 7 days of backups
find $BACKUP_DIR -name "backup_*.tar.gz" -mtime +7 -delete
find $BACKUP_DIR -name "db_*.sql" -mtime +7 -delete

echo "Backup completed: $BACKUP_FILE"
```

**Schedule with Cron:**
```bash
crontab -e

# Add daily backup at 2 AM
0 2 * * * /path/to/backup.sh >> /var/log/backup.log 2>&1
```

### Restoration

```bash
# Restore files
tar -xzf backup_YYYYMMDD_HHMMSS.tar.gz -C /

# Restore database
psql aichatbot < db_YYYYMMDD_HHMMSS.sql

# Restart services
pm2 restart all
```

## Scaling

### Horizontal Scaling

**Load Balancer (Nginx):**

```nginx
upstream frontend {
    least_conn;
    server 192.168.1.10:3000;
    server 192.168.1.11:3000;
    server 192.168.1.12:3000;
}

upstream backend {
    least_conn;
    server 192.168.1.10:5000;
    server 192.168.1.11:5000;
}

server {
    listen 80;
    
    location / {
        proxy_pass http://frontend;
    }
    
    location /api {
        proxy_pass http://backend;
    }
}
```

### Vertical Scaling

**Increase Resources:**
- Upgrade to larger instance
- Add more RAM
- Use faster CPUs
- Switch to SSD storage

**Optimize Node.js:**
```bash
# Increase memory limit
node --max-old-space-size=4096 server.js

# Use clustering
pm2 start server.js -i max
```

### Caching Strategies

**Frontend Caching:**
```javascript
// next.config.js
module.exports = {
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

**API Caching:**
```javascript
const cache = new Map();

app.get('/api/models', async (req, res) => {
  const cacheKey = 'models';
  
  if (cache.has(cacheKey)) {
    return res.json(cache.get(cacheKey));
  }
  
  const data = await fetchModels();
  cache.set(cacheKey, data);
  
  setTimeout(() => cache.delete(cacheKey), 300000); // 5 min TTL
  
  res.json(data);
});
```

## Security

### SSL/TLS Configuration

**Strong SSL Configuration:**
```nginx
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';
ssl_prefer_server_ciphers on;
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;
ssl_stapling on;
ssl_stapling_verify on;
```

### Rate Limiting

**Express Rate Limit:**
```javascript
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests, please try again later.'
});

app.use('/api/', limiter);
```

### Input Validation

```javascript
const { body, validationResult } = require('express-validator');

app.post('/api/chat',
  body('messages').isArray(),
  body('model').isString().trim(),
  (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    // Process request
  }
);
```

### Security Headers

```javascript
const helmet = require('helmet');

app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"],
    },
  },
}));
```

## Troubleshooting

### Common Issues

**Port Already in Use:**
```bash
# Find process
lsof -i :3000

# Kill process
kill -9 <PID>
```

**PM2 Not Starting:**
```bash
# Check logs
pm2 logs --lines 100

# Reset PM2
pm2 kill
pm2 resurrect
```

**Nginx Configuration Error:**
```bash
# Test configuration
sudo nginx -t

# Check error logs
sudo tail -f /var/log/nginx/error.log
```

**SSL Certificate Issues:**
```bash
# Renew certificate
sudo certbot renew

# Force renewal
sudo certbot renew --force-renewal
```

### Performance Issues

**High Memory Usage:**
```bash
# Monitor memory
pm2 monit

# Increase Node memory
node --max-old-space-size=4096 server.js
```

**Slow Response Times:**
- Check Ollama is running
- Verify network latency
- Review database queries
- Check CPU usage
- Optimize model size

### Debugging

**Enable Debug Logs:**
```bash
# Backend
DEBUG=* node server.js

# PM2
pm2 logs --lines 1000
```

**Check System Resources:**
```bash
# CPU and memory
htop

# Disk usage
df -h

# Network connections
netstat -tuln
```

## Maintenance

### Regular Updates

```bash
# Update application
cd /var/www/AI-ChatBot-Web
git pull origin main
cd src
npm ci
npm run build
pm2 restart all
```

### Security Updates

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Update Node packages
npm audit fix

# Update PM2
npm install -g pm2@latest
pm2 update
```

### Health Checks

Create `healthcheck.sh`:

```bash
#!/bin/bash

# Check if services are running
if ! pm2 status | grep -q "online"; then
    echo "Services not running!"
    pm2 restart all
fi

# Check disk space
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo "Disk usage high: $DISK_USAGE%"
fi

# Check memory
FREE_MEM=$(free -m | awk 'NR==2{print $4}')
if [ $FREE_MEM -lt 1000 ]; then
    echo "Low memory: ${FREE_MEM}MB"
fi
```

Schedule health checks:
```bash
*/5 * * * * /path/to/healthcheck.sh
```

---

**Deployment Complete!** 🚀

For support, visit:
- GitHub: https://github.com/Luka12-dev/AI-ChatBot-Web
- YouTube: https://www.youtube.com/@LukaCyber-s4b7o
