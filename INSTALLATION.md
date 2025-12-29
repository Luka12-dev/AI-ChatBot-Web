# Installation Guide

Complete installation guide for AI ChatBot Web application.

## Table of Contents

- [Prerequisites](#prerequisites)
- [System Requirements](#system-requirements)
- [Installation Steps](#installation-steps)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Advanced Setup](#advanced-setup)

## Prerequisites

### Required Software

1. **Node.js** (v18.0.0 or higher)
   - Download from: https://nodejs.org/
   - Verify installation: `node --version`

2. **npm** (comes with Node.js)
   - Verify installation: `npm --version`

3. **Ollama** (for local AI models)
   - Windows: https://ollama.ai/download/OllamaSetup.exe
   - macOS: `brew install ollama`
   - Linux: `curl -fsSL https://ollama.ai/install.sh | sh`
   - Verify installation: `ollama --version`

### Optional Software

- **Git** (for cloning the repository)
- **PowerShell 7+** (Windows users)
- **VS Code** (recommended IDE)

## System Requirements

### Minimum Requirements

- **CPU**: 4-core processor
- **RAM**: 8 GB
- **Storage**: 20 GB free space
- **OS**: Windows 10/11, macOS 10.15+, Linux (Ubuntu 20.04+)

### Recommended Requirements

- **CPU**: 8-core processor or better
- **RAM**: 16 GB or more
- **Storage**: 50 GB SSD
- **GPU**: NVIDIA GPU with 8GB+ VRAM (for faster local model inference)

## Installation Steps

### Step 1: Clone the Repository

```bash
git clone https://github.com/Luka12-dev/AI-ChatBot-Web.git
cd AI-ChatBot-Web
```

### Step 2: Run Setup

#### Windows (PowerShell)

```powershell
.\run.ps1 -Setup  # Windows
./run.sh --setup  # Linux/Mac (run 'chmod +x run.sh' first)
```

#### Linux/macOS

```bash
chmod +x ./models/download-model.sh
cd src
npm install
```

### Step 3: Download AI Models

Choose one of the model download scripts based on your platform:

#### Windows PowerShell

```powershell
.\models\download-model.ps1
```

#### Windows Command Prompt

```cmd
.\models\download-model.bat
```

#### Linux/macOS

```bash
./models/download-model.sh
```

When prompted, enter a model number (1-10) or 'all' to download all models.

**Available Models:**
1. Llama 2 7B (3.8GB)
2. Llama 2 13B (7.3GB)
3. Mistral 7B (4.1GB)
4. Mixtral 8x7B (26GB)
5. Code Llama 7B (3.8GB)
6. Neural Chat 7B (4.1GB)
7. Orca Mini 3B (1.9GB)
8. Phi-2 (1.6GB)
9. Vicuna 7B (3.8GB)
10. Starling LM 7B (4.1GB)

### Step 4: Start the Application

**Windows:**
```powershell
.\run.ps1
```

**Linux/Mac:**
```bash
./run.sh
```

The application will start both frontend and backend servers:
- Frontend: http://localhost:3000
- Backend: http://localhost:5000

## Configuration

### Environment Variables

Create a `.env` file in `src/backend/`:

```env
# Server Configuration
PORT=5000
NODE_ENV=development

# Ollama Configuration
OLLAMA_HOST=http://localhost:11434

# Optional: CORS Configuration
CORS_ORIGIN=http://localhost:3000
```

### API Keys (Optional)

To use OpenAI or Anthropic models:

1. Open the application
2. Click the menu icon (☰)
3. Navigate to Settings tab
4. Enter your API keys

**Getting API Keys:**
- OpenAI: https://platform.openai.com/api-keys
- Anthropic: https://console.anthropic.com/

### Custom Ports

If ports 3000 or 5000 are already in use:

1. Edit `src/backend/.env`:
   ```env
   PORT=5001
   ```

2. Edit `src/next.config.js`:
   ```javascript
   async rewrites() {
     return [
       {
         source: '/api/backend/:path*',
         destination: 'http://localhost:5001/api/:path*',
       },
     ];
   }
   ```

## Troubleshooting

### Ollama Not Connecting

**Problem**: Application shows "Ollama offline" or models don't load.

**Solutions**:

1. Verify Ollama is running:
   ```bash
   ollama list
   ```

2. Restart Ollama service:
   - Windows: Restart from system tray
   - macOS/Linux: `sudo systemctl restart ollama`

3. Check Ollama is accessible:
   ```bash
   curl http://localhost:11434/api/tags
   ```

### Port Already in Use

**Problem**: Error "Port 3000/5000 already in use"

**Solutions**:

1. Find and kill the process:
   ```bash
   # Windows
   netstat -ano | findstr :3000
   taskkill /PID <PID> /F

   # Linux/macOS
   lsof -ti:3000 | xargs kill -9
   ```

2. Use custom ports (see Configuration section)

### Module Not Found Errors

**Problem**: `Cannot find module` errors when starting

**Solutions**:

1. Delete node_modules and reinstall:
   ```bash
   cd src
   rm -rf node_modules
   npm install
   ```

2. Clear npm cache:
   ```bash
   npm cache clean --force
   npm install
   ```

### Models Not Downloading

**Problem**: Model download fails or hangs

**Solutions**:

1. Check internet connection
2. Verify Ollama is installed and running
3. Try downloading manually:
   ```bash
   ollama pull llama2
   ```

4. Check disk space (models can be 1-30GB each)

### Memory Issues

**Problem**: Application crashes or runs out of memory

**Solutions**:

1. Close other applications
2. Use smaller models (Orca Mini 3B, Phi-2)
3. Increase Node.js memory:
   ```bash
   export NODE_OPTIONS="--max-old-space-size=4096"
   ```

4. Restart computer to free up memory

## Advanced Setup

### Running with Docker

```bash
# Build image
docker build -t ai-chatbot .

# Run container
docker run -p 3000:3000 -p 5000:5000 ai-chatbot
```

### Running as System Service

#### Linux (systemd)

Create `/etc/systemd/system/ai-chatbot.service`:

```ini
[Unit]
Description=AI ChatBot Service
After=network.target

[Service]
Type=simple
User=your-username
WorkingDirectory=/path/to/AI-ChatBot-Web
ExecStart=/usr/bin/node src/backend/server.js
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl enable ai-chatbot
sudo systemctl start ai-chatbot
```

#### Windows (NSSM)

1. Download NSSM: https://nssm.cc/download
2. Install service:
   ```cmd
   nssm install AIChat bot "C:\path\to\node.exe" "C:\path\to\src\backend\server.js"
   nssm start AIChatBot
   ```

### Development Mode

For development with hot reload:

```bash
cd src
npm run dev
```

In another terminal:
```bash
cd src
npm run server:dev
```

### Building for Production

```bash
cd src
npm run build
npm start
```

### Performance Optimization

1. **Enable Production Mode**:
   ```bash
   export NODE_ENV=production
   ```

2. **Use PM2 for Process Management**:
   ```bash
   npm install -g pm2
   pm2 start src/backend/server.js --name ai-chatbot
   pm2 startup
   pm2 save
   ```

3. **Configure Nginx Reverse Proxy**:
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }

       location /api {
           proxy_pass http://localhost:5000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

### Database Integration (Optional)

To persist conversations in a database instead of localStorage:

1. Install MongoDB:
   ```bash
   npm install mongodb
   ```

2. Update backend to use MongoDB for storage
3. Configure connection string in `.env`

## Verification

After installation, verify everything works:

1. Open http://localhost:3000
2. You should see the start screen
3. Click "Start Conversation"
4. Select a model from the sidebar
5. Send a test message
6. Verify you receive a response

## Getting Help

If you encounter issues not covered here:

1. Check the [README.md](README.md) for basic usage
2. Review [GitHub Issues](https://github.com/Luka12-dev/AI-ChatBot-Web/issues)
3. Watch setup tutorials on [YouTube](https://www.youtube.com/@LukaCyber-s4b7o)
4. Open a new issue with details about your problem

## Next Steps

After successful installation:

- Read the [User Guide](USER_GUIDE.md) for feature documentation
- Explore keyboard shortcuts (Ctrl+/)
- Customize themes and settings
- Try different AI models
- Export and backup your conversations

---

**Note**: This is a local-first application. All data is stored on your machine unless you configure cloud API keys.
