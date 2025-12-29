# AI ChatBot Debug Test Instructions

This document explains how to use the comprehensive test script to diagnose and fix AI response issues.

## Quick Start

### Run the Test Script

```powershell
.\test.ps1
```

This will run 8 comprehensive tests to verify every component of your AI ChatBot.

## What the Test Script Does

The `test.ps1` script performs the following tests:

1. **Ollama Connection Test** - Verifies Ollama is running and accessible
2. **Backend Server Connection** - Checks if the Node.js backend is running
3. **Backend Status Check** - Confirms backend can communicate with Ollama
4. **Model Availability** - Lists all available models
5. **Direct Ollama Chat** - Tests Ollama directly (non-streaming)
6. **Backend Chat API** - Tests the backend chat endpoint (non-streaming)
7. **Backend Streaming API** - Tests streaming responses
8. **Frontend API Configuration** - Verifies frontend is pointing to correct backend URL

## Enhanced Debug Logging

### Backend Server Logs

The backend server (`src/backend/server.js`) now includes detailed debug logging:

- **Request logging**: See every incoming chat request with model and message details
- **Provider detection**: Shows which AI provider is being used (Ollama/OpenAI/Anthropic)
- **Response logging**: Displays full Ollama responses with status codes
- **Error logging**: Detailed error messages with stack traces
- **Streaming progress**: Track chunk counts in real-time

### Frontend Browser Console Logs

The frontend (`src/lib/api.ts` and `src/hooks/useChat.ts`) now includes:

- **API request logging**: See all requests being sent to backend
- **API response logging**: View complete responses received
- **Streaming progress**: Track chunks as they arrive
- **Error details**: Comprehensive error information
- **Message flow**: Follow the complete lifecycle of each message

## How to Debug

### Step 1: Run the Test Script

```powershell
.\test.ps1
```

### Step 2: Check Which Tests Failed

The script will show a summary with pass/fail status for each test.

### Step 3: Follow the Recommendations

Based on test results, the script provides specific recommendations:

#### If Ollama is not running:
```powershell
ollama serve
ollama pull llama2
```

#### If Backend is not running:
```powershell
cd src/backend
npm install
node server.js
```

#### If Frontend is not running:
```powershell
cd src
npm install
npm run dev
```

### Step 4: Watch the Logs

#### Backend Logs (Terminal 1)
```powershell
cd src/backend
node server.js
```

Look for:
- `📨 CHAT REQUEST RECEIVED` - Incoming requests
- `🟢 Using Ollama provider` - Provider selection
- `✅ SENDING RESPONSE TO CLIENT` - Successful responses
- `❌ CHAT ERROR` - Any errors

#### Frontend Logs (Browser Console - F12)

Open your browser's developer console and look for:
- `📤 API POST REQUEST` - Requests being sent
- `📥 API POST RESPONSE` - Responses received
- `🚀 STARTING STREAMING MESSAGE` - Streaming started
- `✅ STREAMING COMPLETE` - Streaming finished
- `❌` markers for any errors

## Common Issues and Solutions

### Issue 1: No Response from AI

**Symptoms:**
- User sends message
- Loading indicator appears
- No response appears
- No error message

**Debug Steps:**
1. Check browser console for errors
2. Check backend terminal for request logs
3. Verify model is selected in UI
4. Run `.\test.ps1` to check all components

**Solutions:**
- Ensure backend is running: `cd src/backend && node server.js`
- Verify Ollama is running: `ollama serve`
- Check model is downloaded: `ollama list`
- Restart both backend and frontend

### Issue 2: "Model not found" Error

**Symptoms:**
- Error: "Selected model not found"

**Solutions:**
- Download the model: `ollama pull llama2`
- Wait for download to complete (models are large!)
- Refresh the frontend
- Check available models: `ollama list`

### Issue 3: Backend Cannot Connect to Ollama

**Symptoms:**
- Backend logs show "Ollama is offline"
- Test script shows Ollama connection failed

**Solutions:**
- Start Ollama: `ollama serve`
- Check Ollama URL in `.env` file: `OLLAMA_HOST=http://localhost:11434`
- Verify Ollama is listening: `curl http://localhost:11434/api/tags`

### Issue 4: Frontend Cannot Connect to Backend

**Symptoms:**
- Network errors in browser console
- "Network error. Please check your connection." message

**Solutions:**
- Start backend: `cd src/backend && node server.js`
- Verify backend URL in `src/lib/constants.ts`: `API_BASE_URL = 'http://localhost:5000'`
- Check firewall settings
- Try accessing `http://localhost:5000/api/ping` in browser

## Debug Mode

### Enable Verbose Logging

All debug logging is now enabled by default. You'll see:

✅ **Backend Console:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📨 CHAT REQUEST RECEIVED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Model: llama2
Messages count: 2
Last message: Hello, how are you?
🟢 Using Ollama provider
→ Normalized model name: llama2:latest
→ Sending request to Ollama...
→ Ollama response status: 200
✅ Ollama content received, length: 157
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SENDING RESPONSE TO CLIENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Content preview: Hello! I'm doing well, thank you for asking...
Content length: 157
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

✅ **Browser Console:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 SENDING NON-STREAMING MESSAGE
Model: llama2
Conversation ID: conv_abc123
Assistant Message ID: msg_def456
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📤 API POST REQUEST
URL: /api/chat
Data: {messages: Array(2), model: "llama2", settings: {…}}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Testing Checklist

- [ ] Ollama is running (`ollama serve`)
- [ ] At least one model is downloaded (`ollama list`)
- [ ] Backend server is running (`node src/backend/server.js`)
- [ ] Frontend is running (`npm run dev` in src folder)
- [ ] Backend connects to Ollama (check backend logs)
- [ ] Frontend connects to backend (check browser console)
- [ ] Can send a test message and receive response
- [ ] Test script passes all tests (`.\test.ps1`)

## Next Steps

If all tests pass but you still have issues:

1. Clear browser cache and localStorage
2. Restart all services (Ollama, Backend, Frontend)
3. Check for port conflicts (5000, 11434, 3000)
4. Review all console logs for error messages
5. Try a different model: `ollama pull mistral`

## Getting Help

When reporting issues, please include:

1. Output from `.\test.ps1`
2. Backend server logs (last 50 lines)
3. Browser console logs (with errors)
4. Your environment:
   - OS version
   - Node.js version: `node --version`
   - Ollama version: `ollama --version`
   - Installed models: `ollama list`
