# AI ChatBot Web

A modern, feature-rich AI ChatBot application with a beautiful liquid UI design. Built with React, Next.js, TypeScript, and Node.js.

![Start Screen](assets/startup.png)
![Chat](assets/Chat.png)

## Features

- **Modern Liquid UI Design**: Beautiful animations inspired by Apple's design language
- **Dual Themes**: Liquid Blue and Liquid Dark themes
- **Local AI Models**: Run AI models locally using Ollama
- **API Integration**: Connect to OpenAI GPT-4, Claude, and other cloud models
- **Real-time Streaming**: Stream responses in real-time for faster interaction
- **Conversation Management**: Save, export, and manage multiple conversations
- **Swipeable Sidebar**: Touch-friendly sidebar with model selection and settings
- **Keyboard Shortcuts**: Efficient navigation with keyboard shortcuts
- **Responsive Design**: Works seamlessly on desktop and mobile devices
- **Privacy First**: All data stored locally in your browser

## Prerequisites

- **Node.js** (v18 or higher): [Download](https://nodejs.org/)
- **Ollama** (for local models): [Download](https://ollama.ai/download)

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/Luka12-dev/AI-ChatBot-Web.git
cd AI-ChatBot-Web
```

### 2. Install Dependencies

**Windows:**
```powershell
.\run.ps1 -Setup
```

**Linux/Mac:**
```bash
chmod +x run.sh
./run.sh --setup
```

Or manually:

```bash
cd src
npm install
```

### 3. Download AI Models

Choose and download AI models using the model downloader:

```powershell
# Windows PowerShell
.\models\download-model.ps1

# Windows Command Prompt
.\models\download-model.bat

# Linux/Mac
chmod +x ./models/download-model.sh
./models/download-model.sh
```

Available models:
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

### 4. Start the Application

**Windows:**
```powershell
# Start both frontend and backend
.\run.ps1

# Or start separately
.\run.ps1 -Backend  # Backend only
.\run.ps1 -Frontend # Frontend only
```

**Linux/Mac:**
```bash
# Start both frontend and backend
./run.sh

# Or start separately
./run.sh --backend  # Backend only
./run.sh --frontend # Frontend only
```

The application will be available at:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000

## Project Structure

```
AI-ChatBot-Web/
├── src/
│   ├── components/          # React components
│   │   ├── StartScreen.tsx
│   │   ├── MainScreen.tsx
│   │   ├── Header.tsx
│   │   ├── Sidebar.tsx
│   │   ├── MessageList.tsx
│   │   ├── MessageItem.tsx
│   │   ├── ChatInput.tsx
│   │   ├── SettingsModal.tsx
│   │   └── sidebar/
│   │       ├── ModelSelector.tsx
│   │       ├── LanguageSelector.tsx
│   │       └── AdvancedSettings.tsx
│   ├── pages/              # Next.js pages
│   │   ├── _app.tsx
│   │   ├── _document.tsx
│   │   └── index.tsx
│   ├── hooks/              # Custom React hooks
│   │   ├── useChat.ts
│   │   ├── useKeyboard.ts
│   │   ├── useTheme.ts
│   │   └── useLocalStorage.ts
│   ├── store/              # Zustand state management
│   │   ├── chatStore.ts
│   │   └── modelStore.ts
│   ├── lib/                # Utilities and configurations
│   │   ├── api.ts
│   │   └── constants.ts
│   ├── utils/              # Helper functions
│   │   └── helpers.ts
│   ├── types/              # TypeScript type definitions
│   │   └── index.ts
│   ├── styles/             # Global styles
│   │   └── globals.css
│   ├── backend/            # Backend server
│   │   ├── server.js
│   │   └── .env.example
│   ├── public/             # Static assets
│   └── package.json
├── models/                 # Model download scripts
│   ├── download-model.ps1
│   ├── download-model.sh
│   └── download-model.bat
├── run.ps1                 # Main launcher script (Windows)
├── run.sh                  # Main launcher script (Linux/Mac)
└── README.md
```

## Configuration

### Environment Variables

Create a `.env` file in `src/backend/`:

```env
PORT=5000
OLLAMA_HOST=http://localhost:11434
NODE_ENV=development
```

### API Keys

To use OpenAI or Anthropic models:

1. Open the application
2. Click the menu icon (☰)
3. Navigate to Settings tab
4. Enter your API keys in the "API Keys" section

## Usage

### Starting a Conversation

1. Launch the application
2. Click "Start Conversation" on the start screen
3. Select a model from the sidebar (swipe or click menu icon)
4. Type your message and press Enter

### Keyboard Shortcuts

- `Ctrl + N`: New conversation
- `Ctrl + K`: Search conversations
- `Ctrl + S`: Open settings
- `Ctrl + B`: Toggle sidebar
- `Ctrl + T`: Toggle theme
- `Ctrl + Enter`: Send message
- `Escape`: Close modal

### Theme Switching

Click the sun/moon icon in the header to switch between Liquid Blue and Liquid Dark themes.

### Model Selection

1. Open the sidebar (click menu icon or swipe right)
2. Go to the "Models" tab
3. Select from available local models or configure API models
4. Download new models using the download button

## Features in Detail

### Liquid UI Design

The application features a modern, fluid interface with:
- Smooth animations and transitions
- Glass morphism effects
- Liquid gradient backgrounds
- Responsive touch interactions

### Conversation Management

- Auto-save conversations
- Export conversations (JSON, Markdown, Text)
- Import previous conversations
- Search through message history
- Delete individual conversations

### Advanced Settings

- Temperature control
- Token limits
- Custom system prompts
- Multiple language support
- Font size adjustment

## API Integration

### Ollama (Local Models)

The application automatically connects to Ollama running on your machine. Make sure Ollama is installed and running.

### OpenAI

1. Get an API key from [OpenAI](https://platform.openai.com/api-keys)
2. Add it in Settings → API Keys
3. Select a GPT model from the model selector

### Anthropic (Claude)

1. Get an API key from [Anthropic](https://console.anthropic.com/)
2. Add it in Settings → API Keys
3. Select a Claude model from the model selector

## Development

### Running in Development Mode

```bash
cd src
npm run dev
```

### Building for Production

```bash
cd src
npm run build
npm start
```

### Backend Development

```bash
cd src
npm run server:dev
```

## Troubleshooting

### Ollama Not Connecting

- Ensure Ollama is installed and running
- Check if Ollama is accessible at http://localhost:11434
- Try restarting the Ollama service

### Models Not Showing

- Download models using the model downloader script
- Verify models are installed: `ollama list`
- Restart the backend server

### Port Already in Use

Change the port in `src/backend/.env`:
```env
PORT=5001
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Links

- **GitHub Repository**: https://github.com/Luka12-dev/AI-ChatBot-Web
- **GitHub Profile**: https://github.com/Luka12-dev/
- **YouTube Channel**: https://www.youtube.com/@LukaCyber-s4b7o

## License

This project is licensed under the MIT License.

## Credits

Created by Luka12-dev

## Support

For support, please:
- Open an issue on GitHub
- Subscribe to the YouTube channel for tutorials
- Check the documentation

---

Made with ❤️ using React, Next.js, TypeScript, and Node.js
