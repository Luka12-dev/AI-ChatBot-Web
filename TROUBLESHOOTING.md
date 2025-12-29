# Troubleshooting Guide

Comprehensive troubleshooting guide for AI ChatBot Web.

## Table of Contents

1. [Common Issues](#common-issues)
2. [Installation Problems](#installation-problems)
3. [Runtime Errors](#runtime-errors)
4. [Performance Issues](#performance-issues)
5. [Network Problems](#network-problems)
6. [Model Issues](#model-issues)
7. [Browser Issues](#browser-issues)
8. [Platform-Specific Issues](#platform-specific-issues)

## Common Issues

### Application Won't Start

**Problem**: Application fails to start or shows errors.

**Solutions**:

1. **Check Node.js version**:
   ```bash
   node --version  # Should be 18.0.0 or higher
   ```

2. **Reinstall dependencies**:
   ```bash
   cd src
   rm -rf node_modules package-lock.json
   npm install
   ```

3. **Check for port conflicts**:
   ```bash
   # Windows
   netstat -ano | findstr :3000
   netstat -ano | findstr :5000
   
   # Linux/Mac
   lsof -i :3000
   lsof -i :5000
   ```

4. **Verify environment variables**:
   ```bash
   # Check .env file exists
   ls src/backend/.env
   
   # Verify content
   cat src/backend/.env
   ```

5. **Check logs**:
   ```bash
   # Frontend logs
   npm run dev
   
   # Backend logs
   node src/backend/server.js
   ```

### Cannot Connect to Backend

**Problem**: Frontend cannot communicate with backend API.

**Symptoms**:
- "Network error" messages
- "Backend offline" status
- API requests fail

**Solutions**:

1. **Verify backend is running**:
   ```bash
   curl http://localhost:5000/api/ping
   # Should return: {"success":true,"message":"pong"}
   ```

2. **Check CORS configuration**:
   ```javascript
   // src/backend/server.js
   app.use(cors({
     origin: 'http://localhost:3000',
     credentials: true
   }));
   ```

3. **Verify API URL**:
   ```typescript
   // src/lib/constants.ts
   export const API_BASE_URL = 'http://localhost:5000';
   ```

4. **Check firewall settings**:
   ```bash
   # Windows
   netsh advfirewall firewall add rule name="Node" dir=in action=allow program="C:\Program Files\nodejs\node.exe"
   
   # Linux
   sudo ufw allow 5000
   ```

5. **Test with curl**:
   ```bash
   curl -X POST http://localhost:5000/api/chat \
     -H "Content-Type: application/json" \
     -d '{"messages":[{"role":"user","content":"test"}],"model":"llama2"}'
   ```

### Ollama Not Detected

**Problem**: Application shows "Ollama offline" despite Ollama being installed.

**Solutions**:

1. **Verify Ollama is running**:
   ```bash
   ollama list
   ```

2. **Check Ollama service**:
   ```bash
   # Windows - Check system tray
   # Look for Ollama icon
   
   # Linux
   systemctl status ollama
   
   # Mac
   ps aux | grep ollama
   ```

3. **Restart Ollama**:
   ```bash
   # Windows - Right-click tray icon > Restart
   
   # Linux
   sudo systemctl restart ollama
   
   # Mac
   killall ollama
   ollama serve
   ```

4. **Verify Ollama URL**:
   ```bash
   curl http://localhost:11434/api/tags
   ```

5. **Check environment variable**:
   ```bash
   # src/backend/.env
   OLLAMA_HOST=http://localhost:11434
   ```

6. **Reinstall Ollama**:
   ```bash
   # Windows
   # Download and run installer again
   
   # Linux/Mac
   curl -fsSL https://ollama.ai/install.sh | sh
   ```

## Installation Problems

### npm install Fails

**Problem**: Dependencies fail to install.

**Error Messages**:
- "EACCES: permission denied"
- "Cannot find module"
- "Peer dependency conflict"

**Solutions**:

1. **Clear npm cache**:
   ```bash
   npm cache clean --force
   ```

2. **Delete lock file and node_modules**:
   ```bash
   rm package-lock.json
   rm -rf node_modules
   npm install
   ```

3. **Use correct Node version**:
   ```bash
   nvm install 18
   nvm use 18
   ```

4. **Fix permissions (Linux/Mac)**:
   ```bash
   sudo chown -R $USER ~/.npm
   sudo chown -R $USER /usr/local/lib/node_modules
   ```

5. **Use --legacy-peer-deps**:
   ```bash
   npm install --legacy-peer-deps
   ```

6. **Try yarn instead**:
   ```bash
   npm install -g yarn
   yarn install
   ```

### Build Fails

**Problem**: `npm run build` fails with errors.

**Solutions**:

1. **Check TypeScript errors**:
   ```bash
   npm run type-check
   ```

2. **Fix linting errors**:
   ```bash
   npm run lint
   npm run lint -- --fix
   ```

3. **Clear Next.js cache**:
   ```bash
   rm -rf .next
   npm run build
   ```

4. **Increase Node memory**:
   ```bash
   export NODE_OPTIONS="--max-old-space-size=4096"
   npm run build
   ```

5. **Check for circular dependencies**:
   ```bash
   npm install --save-dev madge
   madge --circular --extensions ts,tsx src/
   ```

### Model Download Fails

**Problem**: Model download script fails or hangs.

**Solutions**:

1. **Check internet connection**:
   ```bash
   ping ollama.ai
   ```

2. **Verify Ollama installation**:
   ```bash
   ollama --version
   ```

3. **Download manually**:
   ```bash
   ollama pull llama2
   ollama pull mistral
   ```

4. **Check disk space**:
   ```bash
   # Windows
   wmic logicaldisk get size,freespace,caption
   
   # Linux/Mac
   df -h
   ```

5. **Use smaller model first**:
   ```bash
   ollama pull phi  # Only 1.6GB
   ```

6. **Check Ollama logs**:
   ```bash
   # Linux
   journalctl -u ollama -f
   
   # Mac
   tail -f ~/.ollama/logs/server.log
   ```

## Runtime Errors

### React Errors

**Problem**: React errors in console or white screen.

**Common Errors**:

**"Hydration failed"**:
```typescript
// Solution: Ensure SSR and client render match
// Avoid using window/document during initial render
const [mounted, setMounted] = useState(false);

useEffect(() => {
  setMounted(true);
}, []);

if (!mounted) return null;
```

**"Maximum update depth exceeded"**:
```typescript
// Problem: setState in render
// Bad
function Component() {
  const [count, setCount] = useState(0);
  setCount(count + 1); // Wrong!
  
  // Good
  useEffect(() => {
    setCount(count + 1);
  }, []);
}
```

**"Cannot read property of undefined"**:
```typescript
// Use optional chaining
const title = conversation?.title ?? 'Untitled';

// Or check before accessing
if (conversation && conversation.title) {
  console.log(conversation.title);
}
```

### State Management Errors

**Problem**: State not updating or unexpected behavior.

**Solutions**:

1. **Clear Zustand storage**:
   ```javascript
   // In browser console
   localStorage.removeItem('ai-chatbot-storage');
   ```

2. **Reset state**:
   ```typescript
   useChatStore.getState().clearAllData();
   ```

3. **Check for state mutations**:
   ```typescript
   // Bad - mutating state
   messages.push(newMessage);
   
   // Good - creating new array
   setMessages([...messages, newMessage]);
   ```

### API Errors

**Problem**: API calls fail or return errors.

**Error Codes**:

**400 Bad Request**:
```typescript
// Check request format
const request = {
  messages: messages, // Must be array
  model: 'llama2',    // Must be string
  settings: {...}     // Must be object
};
```

**401 Unauthorized**:
```typescript
// Check API key is set
localStorage.setItem('openai_api_key', 'sk-...');

// Include in request
headers: {
  'Authorization': `Bearer ${apiKey}`
}
```

**429 Too Many Requests**:
```typescript
// Implement exponential backoff
async function retryRequest(fn, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (error.status === 429 && i < retries - 1) {
        await sleep(Math.pow(2, i) * 1000);
        continue;
      }
      throw error;
    }
  }
}
```

**500 Internal Server Error**:
```bash
# Check backend logs
tail -f logs/error.log

# Restart backend
pm2 restart all
```

## Performance Issues

### Slow Response Time

**Problem**: AI responses are very slow.

**Solutions**:

1. **Use smaller model**:
   ```typescript
   // Change from llama2:13b to llama2:7b
   // Or use orca-mini for faster responses
   ```

2. **Reduce token limit**:
   ```typescript
   settings: {
     maxTokens: 1000 // Reduce from 2048
   }
   ```

3. **Check system resources**:
   ```bash
   # Monitor CPU/Memory
   htop  # Linux
   top   # Mac
   Task Manager  # Windows
   ```

4. **Close other applications**:
   ```bash
   # Free up RAM and CPU
   ```

5. **Use GPU if available**:
   ```bash
   # Verify GPU support
   nvidia-smi
   ```

### High Memory Usage

**Problem**: Application uses too much memory.

**Solutions**:

1. **Limit conversation history**:
   ```typescript
   // Keep only last 10 messages
   const recentMessages = messages.slice(-10);
   ```

2. **Clear old conversations**:
   ```typescript
   // Delete conversations older than 30 days
   const thirtyDaysAgo = Date.now() - 30 * 24 * 60 * 60 * 1000;
   conversations.filter(c => c.updatedAt > thirtyDaysAgo);
   ```

3. **Restart browser**:
   ```bash
   # Close and reopen browser to clear memory
   ```

4. **Increase system memory**:
   ```bash
   # Add more RAM or close other programs
   ```

### UI Lag/Stuttering

**Problem**: Interface is slow or unresponsive.

**Solutions**:

1. **Disable animations**:
   ```css
   /* In globals.css */
   * {
     animation: none !important;
     transition: none !important;
   }
   ```

2. **Reduce message count**:
   ```typescript
   // Paginate messages
   const displayedMessages = messages.slice(0, 50);
   ```

3. **Use production build**:
   ```bash
   npm run build
   npm start
   ```

4. **Clear browser cache**:
   ```bash
   # Ctrl+Shift+Delete in browser
   # Clear cached images and files
   ```

## Network Problems

### Streaming Interrupted

**Problem**: Streaming stops mid-response.

**Solutions**:

1. **Check network stability**:
   ```bash
   ping 8.8.8.8
   ```

2. **Increase timeout**:
   ```typescript
   // lib/api.ts
   timeout: 300000 // 5 minutes
   ```

3. **Retry failed streams**:
   ```typescript
   try {
     await streamMessage(request);
   } catch (error) {
     // Retry once
     await streamMessage(request);
   }
   ```

4. **Use non-streaming**:
   ```typescript
   // Fallback to non-streaming mode
   const response = await chatAPI.sendMessage(request);
   ```

### SSL Certificate Errors

**Problem**: HTTPS errors or certificate warnings.

**Solutions**:

1. **Renew certificate**:
   ```bash
   sudo certbot renew
   ```

2. **Check certificate**:
   ```bash
   openssl s_client -connect yourdomain.com:443
   ```

3. **Fix certificate permissions**:
   ```bash
   sudo chmod 644 /etc/letsencrypt/live/yourdomain.com/fullchain.pem
   sudo chmod 600 /etc/letsencrypt/live/yourdomain.com/privkey.pem
   ```

### CORS Errors

**Problem**: Cross-Origin Resource Sharing errors.

**Solutions**:

1. **Configure backend CORS**:
   ```javascript
   app.use(cors({
     origin: ['http://localhost:3000', 'https://yourdomain.com'],
     credentials: true
   }));
   ```

2. **Add proxy in development**:
   ```javascript
   // next.config.js
   async rewrites() {
     return [
       {
         source: '/api/:path*',
         destination: 'http://localhost:5000/api/:path*'
       }
     ];
   }
   ```

## Model Issues

### Model Not Available

**Problem**: Selected model shows as unavailable.

**Solutions**:

1. **List installed models**:
   ```bash
   ollama list
   ```

2. **Download missing model**:
   ```bash
   ollama pull llama2
   ```

3. **Refresh model list**:
   ```typescript
   // Click refresh button in UI
   // Or call API
   fetch('/api/models').then(r => r.json());
   ```

4. **Check model name**:
   ```bash
   # Exact name required
   ollama pull llama2      # Correct
   ollama pull llama-2     # Wrong
   ```

### Model Gives Poor Responses

**Problem**: AI responses are low quality.

**Solutions**:

1. **Try different model**:
   ```typescript
   // Switch from llama2 to mistral or mixtral
   ```

2. **Adjust temperature**:
   ```typescript
   settings: {
     temperature: 0.7  // Higher = more creative
   }
   ```

3. **Improve prompt**:
   ```typescript
   // Be more specific
   "Explain React hooks with code examples"
   
   // Instead of
   "Tell me about React"
   ```

4. **Set system prompt**:
   ```typescript
   settings: {
     systemPrompt: "You are an expert programmer. Provide detailed, accurate code examples."
   }
   ```

### Model Download Stuck

**Problem**: Model download hangs or is very slow.

**Solutions**:

1. **Cancel and retry**:
   ```bash
   # Ctrl+C to cancel
   ollama pull llama2
   ```

2. **Check network speed**:
   ```bash
   speedtest-cli
   ```

3. **Use different mirror**:
   ```bash
   # Set Ollama mirror (if available)
   export OLLAMA_MIRROR=https://mirror.example.com
   ```

4. **Download during off-peak hours**:
   ```bash
   # Try at night or early morning
   ```

## Browser Issues

### LocalStorage Full

**Problem**: "Quota exceeded" error.

**Solutions**:

1. **Clear old data**:
   ```javascript
   // In browser console
   localStorage.clear();
   ```

2. **Export important conversations**:
   ```typescript
   // Use export feature before clearing
   ```

3. **Use IndexedDB** (for future):
   ```typescript
   // Larger storage capacity
   ```

### Browser Compatibility

**Problem**: Features not working in specific browser.

**Supported Browsers**:
- Chrome/Edge 90+
- Firefox 88+
- Safari 14+

**Solutions**:

1. **Update browser**:
   ```bash
   # Get latest version
   ```

2. **Enable JavaScript**:
   ```
   Browser Settings > Privacy > JavaScript > Allow
   ```

3. **Disable extensions**:
   ```
   # Test in incognito/private mode
   ```

4. **Clear cache**:
   ```
   Ctrl+Shift+Delete > Clear cache
   ```

## Platform-Specific Issues

### Windows Issues

**PowerShell Execution Policy**:
```powershell
# Error: cannot be loaded because running scripts is disabled
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Path Issues**:
```powershell
# Add Node to PATH
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\nodejs\", "User")
```

**Port Already in Use**:
```powershell
# Find process
netstat -ano | findstr :3000

# Kill process
taskkill /PID <PID> /F
```

### Linux Issues

**Permission Denied**:
```bash
# Fix npm permissions
sudo chown -R $USER:$USER ~/.npm
sudo chown -R $USER:$USER /usr/local/lib/node_modules
```

**Ollama Service**:
```bash
# Check status
systemctl status ollama

# Restart
sudo systemctl restart ollama

# Enable on boot
sudo systemctl enable ollama
```

### macOS Issues

**Rosetta on M1/M2**:
```bash
# Install Rosetta for compatibility
softwareupdate --install-rosetta
```

**Gatekeeper Blocking**:
```bash
# Allow unsigned apps
sudo spctl --master-disable
```

## Getting Help

### Collect Debug Information

Before asking for help, collect:

1. **System information**:
   ```bash
   node --version
   npm --version
   ollama --version
   ```

2. **Error logs**:
   ```bash
   # Frontend
   Console > Errors
   
   # Backend
   tail -n 100 logs/error.log
   ```

3. **Browser console**:
   ```
   F12 > Console > Copy all errors
   ```

4. **Network tab**:
   ```
   F12 > Network > Failed requests
   ```

### Report Issues

Include in your report:
- Operating system and version
- Node.js and npm versions
- Browser and version
- Steps to reproduce
- Expected vs actual behavior
- Error messages
- Screenshots if relevant

### Community Support

- GitHub Issues: [Report Bug](https://github.com/Luka12-dev/AI-ChatBot-Web/issues)
- GitHub Discussions: [Ask Question](https://github.com/Luka12-dev/AI-ChatBot-Web/discussions)
- YouTube: [Video Tutorials](https://www.youtube.com/@LukaCyber-s4b7o)

---

**Still stuck?** Check the other documentation files or open a GitHub issue!
