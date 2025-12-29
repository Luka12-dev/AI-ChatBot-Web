# Quick Debug Guide - What to Look For

## How to Test

1. Open browser (http://localhost:3000)
2. Open Developer Console (F12)
3. Make sure backend is running in a separate terminal
4. Send a test message: "Hello"
5. Copy ALL console logs from both browser and backend

## What You Should See

### ✅ In Backend Terminal:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📨 CHAT REQUEST RECEIVED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Model: mistral
Messages count: 2
Last message: Hello
🟢 Using Ollama provider
→ Normalized model name: mistral:latest
→ Sending request to Ollama...
→ Ollama response status: 200
→ Ollama response data: {full JSON here}
✅ Ollama content received, length: XXX
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SENDING RESPONSE TO CLIENT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Content preview: [AI response preview]
Content length: XXX
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### ✅ In Browser Console:

```javascript
// 1. Hook starts
🚀 SENDING NON-STREAMING MESSAGE
Model: mistral
Conversation ID: xxx
Assistant Message ID: xxx

// 2. API request sent
📤 API POST REQUEST
URL: /api/chat
Data: {messages: Array(2), model: "mistral", settings: {…}}

// 3. API response received
📥 API POST RESPONSE
URL: /api/chat
Status: 200
Data: {success: true, data: {message: {role: "assistant", content: "..."}}}

// 4. Full response details
📨 RECEIVED NON-STREAMING RESPONSE
Success: true
Response: {success: true, data: {…}}
Response JSON: {
  "success": true,
  "data": {
    "message": {
      "role": "assistant",
      "content": "Hello! How can I help you today?",
      "model": "mistral"
    }
  }
}
Has data? true
Data keys: ["message", "usage"]
Has message? {role: "assistant", content: "...", model: "mistral"}
Message content? "Hello! How can I help you today?"

// 5. Updating message in hook
✅ Updating message with content, length: XXX
✅ Content preview: Hello! How can I help...

// 6. Store updates
🔄 STORE: updateMessage called
  - conversationId: xxx
  - messageId: xxx
  - content length: XXX
  - content preview: Hello! How can I help...
✅ STORE: Message updated in store

// 7. Component re-renders
🎨 MessageItem rendering: {
  id: "xxx",
  role: "assistant",
  contentLength: XXX,
  contentPreview: "Hello! How can I help...",
  streaming: false
}
```

## Troubleshooting Based on Logs

### ❌ If you DON'T see backend logs:
**Problem:** Frontend not reaching backend
**Check:** 
- Backend is running on port 5000
- No firewall blocking
- API_BASE_URL in constants.ts is correct

### ❌ If backend logs stop after "Sending request to Ollama":
**Problem:** Ollama not responding
**Check:**
- Ollama is running: `ollama serve`
- Model is downloaded: `ollama list`

### ❌ If you see "Response: {success: true, data: {}}" (empty data):
**Problem:** Response structure mismatch
**Check:** The "Response JSON" log - it should show the full object

### ❌ If you see response but NOT "🔄 STORE: updateMessage called":
**Problem:** Hook not calling store update
**Check:** The validation conditions in useChat.ts line 185

### ❌ If store updates but NOT "🎨 MessageItem rendering":
**Problem:** Component not re-rendering
**Check:** 
- React DevTools to see if conversation is updating
- MessageList component is subscribing to store changes

### ❌ If MessageItem renders but shows contentLength: 0:
**Problem:** Message in store has empty content
**Check:** Store state in React DevTools

## Expected Flow Diagram

```
User Types Message
       ↓
🚀 useChat.sendMessage()
       ↓
📤 API POST /api/chat
       ↓
📨 Backend receives request
       ↓
🟢 Backend calls Ollama
       ↓
✅ Backend gets Ollama response
       ↓
📥 Frontend receives response
       ↓
✅ useChat validates response
       ↓
🔄 chatStore.updateMessage()
       ↓
✅ Store updates message content
       ↓
🎨 MessageItem re-renders
       ↓
✅ USER SEES MESSAGE IN UI
```

## Quick Fix Commands

If tests fail, try these in order:

```powershell
# 1. Restart Ollama
ollama serve

# 2. Restart backend
cd src/backend
node server.js

# 3. Restart frontend
cd src
npm run dev

# 4. Clear browser cache and localStorage
# In browser console:
localStorage.clear()
# Then refresh page (Ctrl+Shift+R)
```

## Copy/Paste This When Asking for Help

When reporting the issue, copy and paste:

1. **Backend logs** (everything from "📨 CHAT REQUEST RECEIVED" to the end)
2. **Browser console logs** (everything with emojis: 🚀 📤 📥 🔄 🎨)
3. **What you see in UI** (empty? error message? loading forever?)
4. **Screenshot of the UI**

This will help identify the EXACT point where the flow breaks!
