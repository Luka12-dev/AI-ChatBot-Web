# Frequently Asked Questions (FAQ)

Common questions and answers about AI ChatBot Web.

## General Questions

### What is AI ChatBot Web?

AI ChatBot Web is a modern, feature-rich chatbot application that allows you to interact with various AI models. It supports both local models (via Ollama) and cloud-based models (OpenAI GPT, Anthropic Claude).

### Is it free to use?

Yes, the application itself is completely free and open source. However:
- **Local models** (Ollama): Free, runs on your machine
- **Cloud models** (OpenAI, Claude): Require paid API keys

### What makes this chatbot special?

- Modern liquid UI design inspired by Apple
- Support for multiple AI providers
- Complete privacy with local models
- Real-time streaming responses
- Extensive customization options
- No data collection or tracking
- Open source and self-hosted

### Who created this?

Created by Luka12-dev. Find me on:
- GitHub: https://github.com/Luka12-dev/
- YouTube: https://www.youtube.com/@LukaCyber-s4b7o

## Installation & Setup

### What are the system requirements?

**Minimum:**
- CPU: 4-core processor
- RAM: 8 GB
- Storage: 20 GB
- OS: Windows 10/11, macOS 10.15+, Linux (Ubuntu 20.04+)
* Note: If you are using an OpenAI or Anthropic API key, you don’t need powerful hardware, because the AI runs on the server, not locally - only the API keys are used.

**Recommended:**
- CPU: 8-core or better
- RAM: 16 GB+
- Storage: 50 GB SSD
- GPU: NVIDIA with 8GB+ VRAM

### How do I install it?

1. Install Node.js 18+
2. Install Ollama (for local models)
3. Clone the repository
4. Run setup script:
   - Windows: `.\run.ps1 -Setup`
   - Linux/Mac: `chmod +x run.sh && ./run.sh --setup`
5. Download models using model download script
6. Run the application:
   - Windows: `.\run.ps1`
   - Linux/Mac: `./run.sh`

See INSTALLATION.md for detailed instructions.

### Do I need Ollama?

Only if you want to use local AI models. You can use the app with just cloud providers (OpenAI/Claude) by entering your API keys in settings.

### How do I download AI models?

Run one of these scripts:
- Windows PowerShell: `.\models\download-model.ps1`
- Windows CMD: `.\models\download-model.bat`
- Linux/Mac: `./models/download-model.sh`

Follow the prompts to select and download models.

### Which model should I download first?

For beginners, we recommend:
- **Orca Mini 3B** (1.9GB) - Fastest, good for testing
- **Llama 2 7B** (3.8GB) - Best balance of quality and speed
- **Mistral 7B** (4.1GB) - High quality responses

## Usage

### How do I start a conversation?

1. Launch the app: `.\run.ps1` (Windows) or `./run.sh` (Linux/Mac)
2. Click "Start Conversation"
3. Select a model from the sidebar
4. Type your message and press Enter

### Can I use multiple models?

Yes! You can switch models at any time:
1. Open sidebar (click menu icon or swipe right)
2. Go to Models tab
3. Select a different model
4. Continue your conversation

The conversation history is maintained when switching models.

### How do I save conversations?

Conversations are automatically saved to your browser's localStorage. You can also:
1. Export to JSON, Markdown, or Text format
2. Import previously exported conversations
3. Backup regularly for safety

### How do I search conversations?

Press `Ctrl+K` or:
1. Open sidebar
2. Go to History tab
3. Use the search box at the top

### What keyboard shortcuts are available?

- `Ctrl+N`: New conversation
- `Ctrl+K`: Search
- `Ctrl+S`: Settings
- `Ctrl+B`: Toggle sidebar
- `Ctrl+T`: Toggle theme
- `Enter`: Send message
- `Shift+Enter`: New line

Press `Ctrl+/` to see all shortcuts.

## Models & AI

### What's the difference between local and cloud models?

**Local Models (Ollama):**
- Pros: Free, private, offline, unlimited use
- Cons: Requires powerful hardware, slower on weak systems

**Cloud Models (OpenAI/Claude):**
- Pros: Best quality, fast, no local resources needed
- Cons: Costs money, requires internet, data sent to provider

### Which model is best?

Depends on your needs:
- **General chat**: Llama 2, Mistral, GPT-3.5
- **Coding**: Code Llama, GPT-4, Mixtral
- **Complex reasoning**: GPT-4, Claude 3 Opus, Mixtral
- **Speed**: Orca Mini, Phi-2, GPT-3.5
- **Quality**: GPT-4, Claude 3 Opus, Mixtral

### How do I use OpenAI or Claude?

1. Get API key from provider
2. Open Settings (gear icon)
3. Go to API Keys section
4. Enter your key
5. Select the model from Models tab

### Why are responses slow?

Common causes:
- Large model on weak hardware
- High token limit
- System resource shortage
- Network issues (cloud models)

Solutions:
- Use smaller model (7B instead of 13B)
- Reduce max tokens in settings
- Close other applications
- Check internet connection

### Can I fine-tune models?

Not in the current version. Future versions may support custom model training.

## Privacy & Security

### Is my data private?

**With local models**: Yes, completely private. All processing happens on your machine.

**With cloud models**: Your messages are sent to the provider (OpenAI/Anthropic). Review their privacy policies.

### Where is my data stored?

- Conversations: Browser localStorage (client-side only)
- API keys: Browser localStorage (never sent to our servers)
- Settings: Browser localStorage

We don't have a server that stores your data.

### Can others see my conversations?

No, unless:
- You share your device
- You export and share files
- You use a shared computer (use private browsing)

### How do I delete my data?

Settings > Clear All Data

Or clear browser data:
1. Press Ctrl+Shift+Delete
2. Select "Cookies and other site data"
3. Clear

### Are API keys secure?

Keys are stored in browser localStorage. Best practices:
- Don't use public computers
- Rotate keys regularly
- Use separate keys for development
- Monitor usage on provider dashboards

## Customization

### How do I change themes?

Click the sun/moon icon in the header, or press `Ctrl+T`.

Available themes:
- **Liquid Blue**: Light theme with blue gradients
- **Liquid Dark**: Pure black theme

### Can I change the language?

Yes! Open Settings > Language and select from 15 supported languages.

### How do I adjust text size?

Settings > Font Size > Choose Small, Medium, or Large

### Can I customize the AI personality?

Yes! In Advanced Settings:
1. Set custom system prompt
2. Adjust temperature (creativity)
3. Modify other parameters

### Can I change keyboard shortcuts?

Not currently, but planned for future versions.

## Troubleshooting

### App won't start

1. Check Node.js version: `node --version` (should be 18+)
2. Reinstall dependencies: `rm -rf node_modules && npm install`
3. Check for port conflicts (3000, 5000)
4. Review installation logs

### Ollama not detected

1. Verify Ollama is running: `ollama list`
2. Restart Ollama service
3. Check environment variable: `OLLAMA_HOST=http://localhost:11434`
4. Reinstall Ollama if needed

### Models not showing

1. Download models using the script
2. Verify with: `ollama list`
3. Refresh model list in UI
4. Restart backend server

### Streaming doesn't work

1. Check network connection
2. Verify model is loaded
3. Try non-streaming mode in settings
4. Check browser console for errors

### High memory usage

1. Clear old conversations
2. Use smaller models
3. Restart browser
4. Limit conversation length

### Browser compatibility issues

Make sure you're using:
- Chrome/Edge 90+
- Firefox 88+
- Safari 14+

Update your browser if needed.

## Features

### Can I use voice input?

Not in current version. Planned for v1.1.0.

### Can I share conversations?

Yes, export them:
1. Open conversation
2. Settings > Export
3. Choose format (JSON, Markdown, Text)
4. Share the file

### Can I use it offline?

Yes, with local Ollama models. Cloud models require internet.

### Does it support images?

Not currently. Multi-modal support planned for v2.0.0.

### Can I use it on mobile?

Yes, the web interface works on mobile browsers. Native apps planned for v1.2.0.

### Can multiple people use it?

Currently single-user. Multi-user support planned for v2.0.0.

## Performance

### How fast are responses?

Depends on:
- Model size (smaller = faster)
- Hardware (better = faster)
- Token count (fewer = faster)
- Provider (cloud usually faster than local)

Typical times:
- Orca Mini: 20-50 tokens/second
- Llama 2 7B: 10-30 tokens/second
- GPT-3.5: 50-100 tokens/second
- GPT-4: 20-40 tokens/second

### How much disk space do models need?

- Phi-2: 1.6 GB
- Orca Mini: 1.9 GB
- Llama 2 7B: 3.8 GB
- Mistral 7B: 4.1 GB
- Llama 2 13B: 7.3 GB
- Mixtral: 26 GB

### Can I run it on a laptop?

Yes! Recommended setup:
- Use smaller models (3B-7B)
- Reduce token limits
- Close other apps
- Use cloud models if local is too slow

### Does it use GPU?

Yes, if you have a compatible NVIDIA GPU and Ollama is configured to use it.

## Development

### Is it open source?

Yes! MIT License. Free to use, modify.

### Can I contribute?

Absolutely! See CONTRIBUTING.md for guidelines.

### How do I report bugs?

Open an issue on GitHub with:
- System information
- Steps to reproduce
- Expected vs actual behavior
- Error messages/screenshots

### Can I request features?

Yes! Open a GitHub issue or discussion.

### How do I build from source?

```bash
git clone https://github.com/Luka12-dev/AI-ChatBot-Web.git
cd AI-ChatBot-Web
cd src
npm install
npm run build
npm start
```

## Cost

### How much does it cost to run?

**Free:**
- Application itself (open source)
- Local models (Ollama)
- Self-hosting

**Paid:**
- OpenAI API: ~$0.002-0.06 per 1K tokens
- Claude API: ~$0.003-0.015 per 1K tokens
- Cloud hosting (if not self-hosted)

### How do I reduce costs?

1. Use local models primarily
2. Use GPT-3.5 instead of GPT-4
3. Reduce max token limits
4. Cache common queries
5. Monitor usage dashboards

## Support

### Where can I get help?

- Read documentation (README, INSTALLATION, USER_GUIDE)
- Check this FAQ
- Search GitHub Issues
- Open new GitHub Issue
- Watch YouTube tutorials

### How do I stay updated?

- Watch the GitHub repository
- Subscribe to YouTube channel
- Check CHANGELOG.md for updates

### Can I hire you for custom work?

Contact via GitHub profile for inquiries.

### How do I thank you?

- Star the GitHub repository
- Share with others
- Contribute code or documentation
- Report bugs
- Subscribe to YouTube channel

---

**Still have questions?**

- GitHub Discussions: https://github.com/Luka12-dev/AI-ChatBot-Web/discussions
- GitHub Issues: https://github.com/Luka12-dev/AI-ChatBot-Web/issues
- YouTube: https://www.youtube.com/@LukaCyber-s4b7o
