# AI ChatBot User Guide

Complete guide to using the AI ChatBot Web application.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Interface Overview](#interface-overview)
3. [Starting a Conversation](#starting-a-conversation)
4. [Working with Models](#working-with-models)
5. [Conversation Management](#conversation-management)
6. [Customization](#customization)
7. [Advanced Features](#advanced-features)
8. [Keyboard Shortcuts](#keyboard-shortcuts)
9. [Tips and Tricks](#tips-and-tricks)
10. [FAQ](#faq)

## Getting Started

### First Launch

When you first launch the application, you'll see the Start Screen with:

- **Application title and description**
- **Start Conversation button** - Click to begin
- **Feature cards** - Highlighting key capabilities
- **Available models counter** - Shows how many models are ready
- **Social links** - GitHub and YouTube

### Initial Setup

Before your first conversation:

1. **Download Models**: Run the model download script to get AI models
2. **Check Connection**: Verify the backend status indicator shows "Connected"
3. **Select Theme**: Choose between Liquid Blue or Liquid Dark
4. **Configure Settings**: Optional - adjust language, font size, etc.

## Interface Overview

### Main Components

#### Header Bar
Located at the top of the screen:

- **Menu Button** (☰) - Opens the sidebar
- **Conversation Title** - Shows current conversation name
- **Current Model** - Displays selected AI model
- **Status Indicator** - Shows connection status
- **New Conversation** (+) - Starts a fresh chat
- **Theme Toggle** (☀/☽) - Switches between themes
- **Settings** (⚙) - Opens settings panel

#### Sidebar (Swipeable)
Access by clicking menu or swiping right:

##### Models Tab
- **Local Models** - Ollama models installed on your system
- **OpenAI** - Cloud models (requires API key)
- **Anthropic** - Claude models (requires API key)
- **Model Information** - Description, context window, capabilities
- **Download Button** - For unavailable models

##### Settings Tab
- **Language** - Select interface language (15 languages supported)
- **Advanced Settings** - Configure behavior preferences
- **API Keys** - Enter OpenAI/Anthropic keys
- **Font Size** - Small, Medium, or Large

##### History Tab
- **All Conversations** - Chronological list
- **Search** - Find specific conversations
- **Quick Actions** - Delete, export conversations

#### Chat Area
The main conversation interface:

- **Message Bubbles** - Your messages (right), AI responses (left)
- **Timestamps** - When each message was sent
- **Copy Button** - Copy message content
- **Markdown Rendering** - Rich text formatting

#### Input Box
At the bottom of the screen:

- **Text Area** - Type your message (auto-expands)
- **Send Button** - Submit your message (or press Enter)
- **Cancel Button** - Stop AI response (appears during streaming)
- **Hint Text** - "Press Enter to send, Shift+Enter for new line"

### Theme Options

#### Liquid Blue Theme
- Light, modern interface
- Blue and purple gradients
- Perfect for daytime use
- High contrast for readability

#### Liquid Dark Theme
- Pure black background
- Minimalist design
- Easy on the eyes
- OLED-friendly (saves battery)

## Starting a Conversation

### Quick Start

1. Click **"Start Conversation"** on the home screen
2. The sidebar opens automatically
3. Select an AI model from the Models tab
4. Type your message in the input box
5. Press **Enter** or click **Send**

### Best Practices

**Effective Prompts:**
- Be specific and clear
- Provide context when needed
- Break complex tasks into steps
- Ask follow-up questions

**Example Good Prompts:**
```
"Explain quantum computing in simple terms for a high school student"
"Write a Python function to calculate fibonacci numbers with memoization"
"What are the pros and cons of remote work?"
```

**Example Poor Prompts:**
```
"Tell me about computers" (too vague)
"Fix my code" (no code provided)
"What should I do?" (no context)
```

### Multi-turn Conversations

The AI remembers previous messages in the conversation:

```
You: What is React?
AI: React is a JavaScript library...

You: Can you show me an example?
AI: Here's a simple React component...

You: How do I add state to that?
AI: You can use the useState hook...
```

## Working with Models

### Understanding Model Types

#### Local Models (Ollama)
**Advantages:**
- Free to use
- Complete privacy
- No internet required
- Unlimited usage

**Disadvantages:**
- Requires local installation
- Uses computer resources
- Limited by hardware

**Best For:**
- Privacy-sensitive conversations
- Learning and experimentation
- Offline usage
- Cost-free operation

#### Cloud Models (OpenAI/Anthropic)
**Advantages:**
- Most advanced capabilities
- Fast response times
- No local resources needed
- Always latest versions

**Disadvantages:**
- Requires API key
- Costs money per token
- Requires internet
- Data sent to provider

**Best For:**
- Production applications
- Complex reasoning tasks
- Latest AI capabilities
- When local hardware is limited

### Model Capabilities

#### General Purpose Models
- **Llama 2 7B/13B** - Good all-around chat
- **Mistral 7B** - Balanced performance
- **GPT-3.5 Turbo** - Fast cloud option
- **GPT-4 Turbo** - Most advanced

#### Code-Specialized Models
- **Code Llama 7B** - Code generation and review
- **Mixtral 8x7B** - Complex coding tasks

#### Lightweight Models
- **Orca Mini 3B** - Fast responses, lower quality
- **Phi-2** - Microsoft's compact model

### Switching Models

**Mid-Conversation:**
1. Open sidebar (☰)
2. Go to Models tab
3. Select different model
4. Continue conversation

**Note**: Previous conversation context is maintained when switching models.

### Downloading Models

**Using the Script:**
1. Run `.\models\download-model.ps1` (Windows) or `./models/download-model.sh` (Linux/Mac)
2. Enter model number (1-10) or "all"
3. Wait for download to complete
4. Model appears in the Models tab

**Model Sizes:**
- Orca Mini 3B: 1.9 GB (fastest download)
- Phi-2: 1.6 GB
- Llama 2 7B: 3.8 GB
- Mistral 7B: 4.1 GB
- Mixtral 8x7B: 26 GB (largest, best quality)

## Conversation Management

### Creating Conversations

**New Conversation:**
- Click the **+** button in the header
- Or press **Ctrl+N**
- Or select "New Conversation" in sidebar

**Conversation Naming:**
- Auto-named from first message
- Edit by clicking the title
- Keep names descriptive for easy finding

### Searching Conversations

**Using Search:**
1. Press **Ctrl+K** or click search in sidebar
2. Enter search terms
3. Results show matching conversations
4. Click to open

**Search Tips:**
- Searches both titles and content
- Use specific keywords
- Filter by date range
- Sort by relevance or date

### Exporting Conversations

**Export Options:**
1. Click on conversation in sidebar
2. Select "Export"
3. Choose format:
   - **JSON** - Full data with metadata
   - **Markdown** - Readable format
   - **Plain Text** - Simple text file

**Export Settings:**
- Include/exclude timestamps
- Include/exclude settings
- Select specific conversations
- Export all at once

**Use Cases:**
- Backup important conversations
- Share with others
- Import into other tools
- Create documentation

### Importing Conversations

**Steps:**
1. Open Settings
2. Select "Import Data"
3. Choose exported JSON file
4. Conversations are restored

**Note**: Importing merges with existing conversations (doesn't delete).

### Deleting Conversations

**Single Conversation:**
1. Find in History tab
2. Click delete icon (🗑)
3. Confirm deletion

**Clear All:**
1. Open Settings
2. Click "Clear All Data"
3. Confirm (irreversible!)

**Caution**: Deleted conversations cannot be recovered unless previously exported.

## Customization

### Theme Customization

**Changing Themes:**
- Click sun/moon icon in header
- Or press **Ctrl+T**
- Theme persists across sessions

**Liquid Blue:**
- Light backgrounds
- Blue and purple accents
- High contrast text
- Professional appearance

**Liquid Dark:**
- True black backgrounds
- Subtle white accents
- Reduced eye strain
- Modern aesthetic

### Language Settings

**Supported Languages:**
1. English
2. Spanish (Español)
3. French (Français)
4. German (Deutsch)
5. Italian (Italiano)
6. Portuguese (Português)
7. Russian (Русский)
8. Japanese (日本語)
9. Korean (한국어)
10. Chinese (中文)
11. Arabic (العربية)
12. Hindi (हिन्दी)
13. Turkish (Türkçe)
14. Polish (Polski)
15. Dutch (Nederlands)

**Changing Language:**
1. Open sidebar → Settings tab
2. Select "Language" dropdown
3. Choose your language
4. Interface updates immediately

### Advanced Settings

**Send on Enter:**
- Enabled: Enter sends message
- Disabled: Enter adds new line (use Ctrl+Enter to send)

**Show Timestamps:**
- Enabled: Shows message times
- Disabled: Cleaner interface

**Sound Effects:**
- Enabled: Notification sounds
- Disabled: Silent operation

**Auto Save:**
- Enabled: Saves after each message
- Disabled: Manual save only

**Default Model:**
- Select preferred starting model
- Used for new conversations

### Font Size

**Options:**
- **Small** - Compact, more content visible
- **Medium** - Balanced (default)
- **Large** - Better readability

**Accessibility:**
Larger fonts help users with vision impairments.

## Advanced Features

### Conversation Analytics

**Accessing:**
- Open conversation
- Click analytics icon
- View detailed statistics

**Metrics:**
- Total messages
- Token count
- Response times
- Model usage
- Activity timeline

**Use Cases:**
- Track usage patterns
- Optimize model selection
- Monitor token consumption

### Model Settings

**Temperature (0.0 - 2.0):**
- Lower: More focused, deterministic
- Higher: More creative, random
- Default: 0.7

**Max Tokens:**
- Maximum response length
- Higher: Longer responses
- Lower: Shorter, faster

**Top P (0.0 - 1.0):**
- Controls diversity
- 0.9: Balanced (default)
- Lower: More focused

**Frequency Penalty (0.0 - 2.0):**
- Reduces repetition
- Higher: More varied vocabulary

**Presence Penalty (0.0 - 2.0):**
- Encourages new topics
- Higher: More topic diversity

**System Prompt:**
- Custom instructions for AI
- Define personality/role
- Set behavioral guidelines

### Streaming vs Non-Streaming

**Streaming Mode:**
- Responses appear word-by-word
- Can cancel mid-response
- Better user experience
- Default mode

**Non-Streaming Mode:**
- Wait for complete response
- All-or-nothing delivery
- Useful for API rate limits

### API Integration

**OpenAI Setup:**
1. Get API key from https://platform.openai.com
2. Open Settings → API Keys
3. Enter "OpenAI API Key"
4. Save
5. Select GPT model

**Anthropic Setup:**
1. Get API key from https://console.anthropic.com
2. Open Settings → API Keys
3. Enter "Anthropic API Key"
4. Save
5. Select Claude model

**Security:**
- Keys stored locally only
- Never sent to our servers
- Clear browser data to remove

## Keyboard Shortcuts

### Global Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl + N` | New conversation |
| `Ctrl + K` | Search conversations |
| `Ctrl + S` | Open settings |
| `Ctrl + B` | Toggle sidebar |
| `Ctrl + T` | Toggle theme |
| `Ctrl + /` | Show shortcuts |
| `Escape` | Close modal/dialog |

### Message Input

| Shortcut | Action |
|----------|--------|
| `Enter` | Send message (if enabled) |
| `Shift + Enter` | New line |
| `Ctrl + Enter` | Send message (always) |
| `Ctrl + Z` | Undo typing |
| `Ctrl + Y` | Redo typing |

### Navigation

| Shortcut | Action |
|----------|--------|
| `↑` / `↓` | Navigate history |
| `Tab` | Next field |
| `Shift + Tab` | Previous field |

**Customization:**
Keyboard shortcuts cannot currently be customized but may be in future updates.

## Tips and Tricks

### Getting Better Responses

**1. Be Specific:**
```
Instead of: "Tell me about Python"
Try: "Explain Python list comprehensions with 3 examples"
```

**2. Provide Context:**
```
"I'm building a React app. How do I handle form validation?"
```

**3. Ask for Format:**
```
"List 5 pros and cons of electric vehicles in a table"
```

**4. Iterate:**
```
"Make that explanation simpler"
"Add code examples"
"Explain like I'm 10"
```

### Model Selection Strategy

**For Coding:**
- Use Code Llama or Mixtral
- Lower temperature (0.3-0.5)
- Specific language in prompt

**For Writing:**
- Use GPT-4 or Llama 2 13B
- Higher temperature (0.7-0.9)
- Creative prompts

**For Analysis:**
- Use Mistral or GPT-4
- Medium temperature (0.5-0.7)
- Structured questions

**For Speed:**
- Use Orca Mini or GPT-3.5
- Lower max tokens
- Concise prompts

### Performance Optimization

**Faster Responses:**
1. Use smaller models (3B-7B)
2. Reduce max tokens
3. Close other applications
4. Use SSD for model storage

**Better Quality:**
1. Use larger models (13B+)
2. Increase max tokens
3. Refine prompts
4. Use cloud models

**Privacy Focus:**
1. Use only local models
2. Disable API keys
3. Export conversations regularly
4. Clear data when done

### Organization Tips

**Naming Conversations:**
- Use descriptive titles
- Include project names
- Add dates if relevant
- Keep consistent format

**Regular Maintenance:**
- Export important conversations
- Delete old/test conversations
- Update models periodically
- Clear unused models

## FAQ

### General Questions

**Q: Is my data private?**
A: Yes, when using local models. All data stays on your machine. Cloud models send data to providers.

**Q: Does it work offline?**
A: Yes, with local Ollama models. Cloud models require internet.

**Q: How much does it cost?**
A: Local models are free. Cloud models charge per token (typically $0.002-0.06 per 1K tokens).

**Q: Can I use it commercially?**
A: Yes, but check individual model licenses. Most open models allow commercial use.

### Technical Questions

**Q: Why is the response slow?**
A: Large models require significant processing. Try smaller models or cloud APIs.

**Q: Can I use my own models?**
A: Yes, if compatible with Ollama. Add to Ollama and they'll appear in the app.

**Q: Does it support multiple languages?**
A: Yes, AI models understand many languages. Interface supports 15 languages.

**Q: How do I backup my data?**
A: Use the Export feature or manually backup browser localStorage.

### Troubleshooting

**Q: Models not showing up?**
A: Ensure Ollama is running and models are downloaded. Check status indicator.

**Q: API key not working?**
A: Verify key is correct, has credits, and proper permissions.

**Q: App is laggy?**
A: Close other apps, use smaller models, or try cloud models.

**Q: Lost my conversations?**
A: Check if browser data was cleared. If backed up, use Import feature.

### Feature Requests

**Q: Will you add feature X?**
A: Check GitHub issues or create a feature request.

**Q: Can I contribute?**
A: Yes! Check CONTRIBUTING.md for guidelines.

**Q: Is there a mobile app?**
A: Not yet, but the web interface works on mobile browsers.

## Getting Help

### Resources

1. **README.md** - Quick start guide
2. **INSTALLATION.md** - Detailed setup instructions
3. **GitHub Issues** - Known problems and solutions
4. **YouTube Channel** - Video tutorials and demos
5. **Discord/Forum** - Community support (if available)

### Reporting Issues

When reporting problems, include:
1. Operating system and version
2. Browser and version
3. Steps to reproduce
4. Error messages (if any)
5. Screenshots (if relevant)

### Community

- **GitHub**: https://github.com/Luka12-dev/AI-ChatBot-Web
- **YouTube**: https://www.youtube.com/@LukaCyber-s4b7o

---

**Happy chatting!** 🚀

For updates and new features, watch the GitHub repository and YouTube channel.
