#!/usr/bin/env bash

# Parse command line arguments
SETUP=false
BACKEND=false
FRONTEND=false
DEV=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --setup)
            SETUP=true
            shift
            ;;
        --backend)
            BACKEND=true
            shift
            ;;
        --frontend)
            FRONTEND=true
            shift
            ;;
        --dev)
            DEV=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--setup] [--backend] [--frontend] [--dev]"
            exit 1
            ;;
    esac
done

set -e

# Color codes
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

write_banner() {
    echo ""
    echo -e "${CYAN}============================================${NC}"
    echo -e "${CYAN}                                            ${NC}"
    echo -e "${CYAN}           AI ChatBot Launcher              ${NC}"
    echo -e "${CYAN}                                            ${NC}"
    echo -e "${CYAN}============================================${NC}"
    echo ""
}

test_node_installed() {
    command -v node >/dev/null 2>&1
}

test_npm_installed() {
    command -v npm >/dev/null 2>&1
}

test_ollama_installed() {
    command -v ollama >/dev/null 2>&1
}

install_dependencies() {
    echo -e "${CYAN}Installing project dependencies...${NC}"
    
    if [ ! -d "src/node_modules" ]; then
        echo -e "${YELLOW}Installing frontend dependencies...${NC}"
        cd src
        npm install
        cd ..
        echo -e "${GREEN}[OK] Frontend dependencies installed${NC}"
    else
        echo -e "${GREEN}[OK] Frontend dependencies already installed${NC}"
    fi
    
    if [ ! -d "src/backend/node_modules" ]; then
        echo -e "${YELLOW}Installing backend dependencies...${NC}"
        cd src/backend
        npm install
        cd ../..
        echo -e "${GREEN}[OK] Backend dependencies installed${NC}"
    else
        echo -e "${GREEN}[OK] Backend dependencies already installed${NC}"
    fi
    
    echo ""
}

start_backend() {
    echo -e "${CYAN}Starting backend server...${NC}"
    
    if [ ! -f "src/backend/.env" ]; then
        cp "src/backend/.env.example" "src/backend/.env"
        echo -e "${YELLOW}Created .env file from template${NC}"
    fi
    
    # Start backend in background
    cd src/backend
    node server.js > /dev/null 2>&1 &
    BACKEND_PID=$!
    cd ../..
    
    sleep 2
    echo -e "${GREEN}[OK] Backend server started (PID: $BACKEND_PID)${NC}"
    echo $BACKEND_PID
}

start_frontend() {
    echo -e "${CYAN}Starting frontend development server...${NC}"
    
    # Start frontend in background
    cd src
    npm run dev > /dev/null 2>&1 &
    FRONTEND_PID=$!
    cd ..
    
    sleep 2
    echo -e "${GREEN}[OK] Frontend server started (PID: $FRONTEND_PID)${NC}"
    echo $FRONTEND_PID
}

show_status() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${WHITE}  AI ChatBot is running!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${CYAN}  Frontend:  http://localhost:3000${NC}"
    echo -e "${CYAN}  Backend:   http://localhost:5000${NC}"
    echo ""
    echo -e "${YELLOW}  Press Ctrl+C to stop all services${NC}"
    echo ""
}

test_prerequisites() {
    ISSUES=()
    
    if ! test_node_installed; then
        ISSUES+=("Node.js is not installed. Please install from https://nodejs.org/")
    fi
    
    if ! test_npm_installed; then
        ISSUES+=("npm is not installed. Please install Node.js from https://nodejs.org/")
    fi
    
    if ! test_ollama_installed; then
        echo -e "${YELLOW}[WARNING] Ollama is not installed. Local AI models will not work.${NC}"
        echo -e "${YELLOW}  Install from: https://ollama.ai/download${NC}"
        echo -e "${YELLOW}  Or run: ./models/download-model.sh${NC}"
        echo ""
    fi
    
    if [ ${#ISSUES[@]} -gt 0 ]; then
        echo -e "${RED}Prerequisites missing:${NC}"
        for issue in "${ISSUES[@]}"; do
            echo -e "${RED}  - $issue${NC}"
        done
        return 1
    fi
    
    return 0
}

cleanup() {
    echo ""
    echo -e "${YELLOW}Shutting down...${NC}"
    
    for pid in "${PROCESS_PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            echo -e "${YELLOW}Stopping process $pid...${NC}"
            kill -TERM "$pid" 2>/dev/null || true
            # Give it a moment to terminate gracefully
            sleep 1
            # Force kill if still running
            if kill -0 "$pid" 2>/dev/null; then
                kill -KILL "$pid" 2>/dev/null || true
            fi
        fi
    done
    
    echo ""
    echo -e "${GREEN}All services stopped${NC}"
    echo ""
    exit 0
}

# Trap Ctrl+C and other termination signals
trap cleanup SIGINT SIGTERM EXIT

write_banner

if [ "$SETUP" = true ]; then
    echo -e "${CYAN}Running setup...${NC}"
    echo ""
    
    if ! test_prerequisites; then
        exit 1
    fi
    
    install_dependencies
    
    echo -e "${GREEN}========================================${NC}"
    echo -e "${WHITE}  Setup completed successfully!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo -e "${WHITE}  1. Download AI models: ./models/download-model.sh${NC}"
    echo -e "${WHITE}  2. Start the application: ./run.sh${NC}"
    echo ""
    exit 0
fi

if ! test_prerequisites; then
    echo ""
    echo -e "${YELLOW}Run './run.sh --setup' to install dependencies${NC}"
    exit 1
fi

if [ ! -d "src/node_modules" ]; then
    echo -e "${YELLOW}Dependencies not installed. Running setup...${NC}"
    install_dependencies
fi

PROCESS_PIDS=()

# Determine what to start
if [ "$BACKEND" = true ] || ([ "$FRONTEND" = false ] && [ "$DEV" = false ]); then
    BACKEND_PID=$(start_backend)
    PROCESS_PIDS+=("$BACKEND_PID")
    sleep 2
fi

if [ "$FRONTEND" = true ] || [ "$DEV" = true ] || [ "$BACKEND" = false ]; then
    FRONTEND_PID=$(start_frontend)
    PROCESS_PIDS+=("$FRONTEND_PID")
    sleep 3
fi

show_status

# Monitor processes
while true; do
    sleep 1
    
    for pid in "${PROCESS_PIDS[@]}"; do
        if ! kill -0 "$pid" 2>/dev/null; then
            echo -e "${RED}Service process $pid has stopped unexpectedly${NC}"
            cleanup
        fi
    done
done
