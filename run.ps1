#!/usr/bin/env pwsh

param(
    [switch]$Setup,
    [switch]$Backend,
    [switch]$Frontend,
    [switch]$Dev
)

$ErrorActionPreference = "Stop"

function Write-Banner {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "                                            " -ForegroundColor Cyan
    Write-Host "           AI ChatBot Launcher              " -ForegroundColor Cyan
    Write-Host "                                            " -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
}

function Test-NodeInstalled {
    try {
        $null = Get-Command node -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

function Test-NpmInstalled {
    try {
        $null = Get-Command npm -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

function Test-OllamaInstalled {
    try {
        $null = Get-Command ollama -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

function Install-Dependencies {
    Write-Host "Installing project dependencies..." -ForegroundColor Cyan
    
    if (-not (Test-Path "src/node_modules")) {
        Write-Host "Installing frontend dependencies..." -ForegroundColor Yellow
        Push-Location src
        npm install
        Pop-Location
        Write-Host "[OK] Frontend dependencies installed" -ForegroundColor Green
    }
    else {
        Write-Host "[OK] Frontend dependencies already installed" -ForegroundColor Green
    }
    
    if (-not (Test-Path "src/backend/node_modules")) {
        Write-Host "Installing backend dependencies..." -ForegroundColor Yellow
        Push-Location src/backend
        npm install
        Pop-Location
        Write-Host "[OK] Backend dependencies installed" -ForegroundColor Green
    }
    else {
        Write-Host "[OK] Backend dependencies already installed" -ForegroundColor Green
    }
    
    Write-Host ""
}

function Start-Backend {
    Write-Host "Starting backend server..." -ForegroundColor Cyan
    
    if (-not (Test-Path "src/backend/.env")) {
        Copy-Item "src/backend/.env.example" "src/backend/.env"
        Write-Host "Created .env file from template" -ForegroundColor Yellow
    }
    
    $backendProcess = Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$PWD\src\backend'; node server.js" -PassThru -WindowStyle Minimized
    
    Start-Sleep -Seconds 2
    Write-Host "[OK] Backend server started (PID: $($backendProcess.Id))" -ForegroundColor Green
    return $backendProcess
}

function Start-Frontend {
    Write-Host "Starting frontend development server..." -ForegroundColor Cyan
    
    $frontendProcess = Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$PWD\src'; npm run dev" -PassThru -WindowStyle Minimized
    
    Start-Sleep -Seconds 2
    Write-Host "[OK] Frontend server started (PID: $($frontendProcess.Id))" -ForegroundColor Green
    return $frontendProcess
}

function Show-Status {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  AI ChatBot is running!" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Frontend:  http://localhost:3000" -ForegroundColor Cyan
    Write-Host "  Backend:   http://localhost:5000" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Press Ctrl+C to stop all services" -ForegroundColor Yellow
    Write-Host ""
}

function Test-Prerequisites {
    $issues = @()
    
    if (-not (Test-NodeInstalled)) {
        $issues += "Node.js is not installed. Please install from https://nodejs.org/"
    }
    
    if (-not (Test-NpmInstalled)) {
        $issues += "npm is not installed. Please install Node.js from https://nodejs.org/"
    }
    
    if (-not (Test-OllamaInstalled)) {
        Write-Host "[WARNING] Ollama is not installed. Local AI models will not work." -ForegroundColor Yellow
        Write-Host "  Install from: https://ollama.ai/download" -ForegroundColor Yellow
        Write-Host "  Or run: .\models\download-model.ps1" -ForegroundColor Yellow
        Write-Host ""
    }
    
    if ($issues.Count -gt 0) {
        Write-Host "Prerequisites missing:" -ForegroundColor Red
        foreach ($issue in $issues) {
            Write-Host "  - $issue" -ForegroundColor Red
        }
        return $false
    }
    
    return $true
}

Write-Banner

if ($Setup) {
    Write-Host "Running setup..." -ForegroundColor Cyan
    Write-Host ""
    
    if (-not (Test-Prerequisites)) {
        exit 1
    }
    
    Install-Dependencies
    
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  Setup completed successfully!" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Download AI models: .\models\download-model.ps1" -ForegroundColor White
    Write-Host "  2. Start the application: .\run.ps1" -ForegroundColor White
    Write-Host ""
    exit 0
}

if (-not (Test-Prerequisites)) {
    Write-Host ""
    Write-Host "Run '.\run.ps1 -Setup' to install dependencies" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path "src/node_modules")) {
    Write-Host "Dependencies not installed. Running setup..." -ForegroundColor Yellow
    Install-Dependencies
}

$processes = @()

try {
    if ($Backend -or (-not $Frontend -and -not $Dev)) {
        $backendProc = Start-Backend
        $processes += $backendProc
        Start-Sleep -Seconds 2
    }
    
    if ($Frontend -or $Dev -or (-not $Backend)) {
        $frontendProc = Start-Frontend
        $processes += $frontendProc
        Start-Sleep -Seconds 3
    }
    
    Show-Status
    
    while ($true) {
        Start-Sleep -Seconds 1
        
        foreach ($proc in $processes) {
            $processExists = Get-Process -Id $proc.Id -ErrorAction SilentlyContinue
            if (-not $processExists) {
                Write-Host "Service process $($proc.Id) has stopped unexpectedly" -ForegroundColor Red
                throw "Service crashed"
            }
        }
    }
}
catch {
    Write-Host ""
    Write-Host "Shutting down..." -ForegroundColor Yellow
}
finally {
    foreach ($proc in $processes) {
        $processExists = Get-Process -Id $proc.Id -ErrorAction SilentlyContinue
        if ($processExists) {
            Write-Host "Stopping process $($proc.Id)..." -ForegroundColor Yellow
            Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
        }
    }
    
    Write-Host ""
    Write-Host "All services stopped" -ForegroundColor Green
    Write-Host ""
}
