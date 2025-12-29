# NOTE: this is only for debug.

# AI ChatBot - Comprehensive Debug Test Script
# ===================================================================
# This script tests the entire chat flow from frontend to backend to Ollama
# with detailed debugging at each step

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                                ║" -ForegroundColor Cyan
Write-Host "║       AI ChatBot - Comprehensive Debug Test Suite              ║" -ForegroundColor Cyan
Write-Host "║                                                                ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

# Configuration
$BACKEND_URL = "http://localhost:5000"
$OLLAMA_URL = "http://localhost:11434"
$TEST_MODEL = "llama2:latest"
$TEST_MESSAGE = "Hello! Please respond with 'Test successful' if you can read this."

# Color functions
function Write-Success { param($msg) Write-Host "✓ $msg" -ForegroundColor Green }
function Write-Error { param($msg) Write-Host "✗ $msg" -ForegroundColor Red }
function Write-Info { param($msg) Write-Host "ℹ $msg" -ForegroundColor Cyan }
function Write-Debug { param($msg) Write-Host "  → $msg" -ForegroundColor Gray }
function Write-Section { param($msg) Write-Host "`n═══ $msg ═══" -ForegroundColor Yellow }

# Test results tracking
$testResults = @{
    Total = 0
    Passed = 0
    Failed = 0
    Tests = @()
}

function Add-TestResult {
    param($name, $passed, $details)
    $testResults.Total++
    if ($passed) { $testResults.Passed++ } else { $testResults.Failed++ }
    $testResults.Tests += @{
        Name = $name
        Passed = $passed
        Details = $details
    }
}

# ===================================================================
# TEST 1: Ollama Connection and Status
# ===================================================================
Write-Section "TEST 1: Ollama Connection and Status"

try {
    Write-Info "Testing Ollama connection at $OLLAMA_URL..."
    $response = Invoke-RestMethod -Uri "$OLLAMA_URL/api/tags" -Method Get -TimeoutSec 5
    Write-Success "Ollama is running and accessible"
    Write-Debug "Response: $($response | ConvertTo-Json -Depth 2 -Compress)"
    
    if ($response.models -and $response.models.Count -gt 0) {
        Write-Success "Found $($response.models.Count) models"
        foreach ($model in $response.models) {
            Write-Debug "  - $($model.name) (size: $([math]::Round($model.size / 1GB, 2)) GB)"
        }
    } else {
        Write-Error "No models found in Ollama"
    }
    Add-TestResult "Ollama Connection" $true "Found $($response.models.Count) models"
} catch {
    Write-Error "Failed to connect to Ollama: $($_.Exception.Message)"
    Write-Debug "Error details: $($_.Exception)"
    Add-TestResult "Ollama Connection" $false $_.Exception.Message
    Write-Host "`nℹ️  Please ensure Ollama is running. Start it with: ollama serve" -ForegroundColor Yellow
    Write-Host "   Then run: ollama pull llama2" -ForegroundColor Yellow
}

# ===================================================================
# TEST 2: Backend Server Connection
# ===================================================================
Write-Section "TEST 2: Backend Server Connection"

try {
    Write-Info "Testing backend server at $BACKEND_URL..."
    $response = Invoke-RestMethod -Uri "$BACKEND_URL/api/ping" -Method Get -TimeoutSec 5
    Write-Success "Backend server is running"
    Write-Debug "Response: $($response | ConvertTo-Json -Compress)"
    Add-TestResult "Backend Server Ping" $true "Server responded with: $($response.message)"
} catch {
    Write-Error "Failed to connect to backend server: $($_.Exception.Message)"
    Write-Debug "Error details: $($_.Exception)"
    Add-TestResult "Backend Server Ping" $false $_.Exception.Message
    Write-Host "`nℹ️  Please ensure backend is running. Start it with:" -ForegroundColor Yellow
    Write-Host "   cd src/backend" -ForegroundColor Yellow
    Write-Host "   node server.js" -ForegroundColor Yellow
}

# ===================================================================
# TEST 3: Backend Status Check
# ===================================================================
Write-Section "TEST 3: Backend Status Check"

try {
    Write-Info "Checking backend system status..."
    $response = Invoke-RestMethod -Uri "$BACKEND_URL/api/status" -Method Get -TimeoutSec 5
    Write-Success "Backend status retrieved successfully"
    Write-Debug "Backend: $($response.data.backend)"
    Write-Debug "Ollama: $($response.data.ollama)"
    Write-Debug "Models: $($response.data.models.Count)"
    Write-Debug "Version: $($response.data.version)"
    Write-Debug "Uptime: $([math]::Round($response.data.uptime, 2)) seconds"
    
    if ($response.data.ollama -eq "offline") {
        Write-Error "Backend reports Ollama as offline"
        Add-TestResult "Backend Status" $false "Ollama is offline"
    } else {
        Write-Success "Backend can communicate with Ollama"
        Add-TestResult "Backend Status" $true "Ollama online with $($response.data.models.Count) models"
    }
} catch {
    Write-Error "Failed to get backend status: $($_.Exception.Message)"
    Add-TestResult "Backend Status" $false $_.Exception.Message
}

# ===================================================================
# TEST 4: Model Availability Check
# ===================================================================
Write-Section "TEST 4: Model Availability Check"

try {
    Write-Info "Checking available models through backend..."
    $response = Invoke-RestMethod -Uri "$BACKEND_URL/api/models" -Method Get -TimeoutSec 5
    
    if ($response.success -and $response.data -and $response.data.Count -gt 0) {
        Write-Success "Backend can fetch models from Ollama"
        Write-Debug "Available models:"
        foreach ($model in $response.data) {
            Write-Debug "  - $($model.name)"
            if ($model.name -like "*llama2*") {
                $TEST_MODEL = $model.name
                Write-Info "Will use model: $TEST_MODEL"
            }
        }
        Add-TestResult "Model Availability" $true "Found $($response.data.Count) models"
    } else {
        Write-Error "No models available"
        Add-TestResult "Model Availability" $false "No models found"
    }
} catch {
    Write-Error "Failed to get models: $($_.Exception.Message)"
    Add-TestResult "Model Availability" $false $_.Exception.Message
}

# ===================================================================
# TEST 5: Direct Ollama Chat Test (Non-Streaming)
# ===================================================================
Write-Section "TEST 5: Direct Ollama Chat Test (Non-Streaming)"

try {
    Write-Info "Testing direct Ollama chat (non-streaming)..."
    
    $body = @{
        model = $TEST_MODEL
        messages = @(
            @{
                role = "user"
                content = $TEST_MESSAGE
            }
        )
        stream = $false
    } | ConvertTo-Json -Depth 10
    
    Write-Debug "Request body: $body"
    
    $response = Invoke-RestMethod -Uri "$OLLAMA_URL/api/chat" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 60
    
    if ($response.message -and $response.message.content) {
        Write-Success "✓ OLLAMA RESPONDED SUCCESSFULLY!"
        Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "  ║           OLLAMA RESPONSE (Direct Test)                   ║" -ForegroundColor Green
        Write-Host "  ╠═══════════════════════════════════════════════════════════╣" -ForegroundColor Green
        Write-Host "  ║$($response.message.content)                               ║" -ForegroundColor White
        Write-Host "  ╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
        Write-Host ""
        Add-TestResult "Direct Ollama Chat" $true "Received response: $($response.message.content.Substring(0, [Math]::Min(50, $response.message.content.Length)))..."
    } else {
        Write-Error "Ollama responded but no content in message"
        Write-Debug "Full response: $($response | ConvertTo-Json -Depth 5)"
        Add-TestResult "Direct Ollama Chat" $false "No content in response"
    }
} catch {
    Write-Error "Direct Ollama chat failed: $($_.Exception.Message)"
    Write-Debug "Error details: $($_.Exception)"
    Add-TestResult "Direct Ollama Chat" $false $_.Exception.Message
}

# TEST 6: Backend Chat API Test (Non-Streaming)

Write-Section "TEST 6: Backend Chat API Test (Non-Streaming)"

try {
    Write-Info "Testing backend chat API (non-streaming)..."
    
    $body = @{
        model = $TEST_MODEL
        messages = @(
            @{
                role = "user"
                content = $TEST_MESSAGE
            }
        )
        settings = @{}
    } | ConvertTo-Json -Depth 10
    
    Write-Debug "Request URL: $BACKEND_URL/api/chat"
    Write-Debug "Request body: $body"
    
    $response = Invoke-RestMethod -Uri "$BACKEND_URL/api/chat" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 60
    
    Write-Debug "Full response: $($response | ConvertTo-Json -Depth 5)"
    
    if ($response.success -and $response.data -and $response.data.message -and $response.data.message.content) {
        Write-Success "✓ BACKEND CHAT API WORKS!"
        Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
        Write-Host "  ║         BACKEND CHAT RESPONSE (Non-Streaming)             ║" -ForegroundColor Green
        Write-Host "  ╠═══════════════════════════════════════════════════════════╣" -ForegroundColor Green
        Write-Host "  $($response.data.message.content)" -ForegroundColor White
        Write-Host "  ╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
        Write-Host ""
        Add-TestResult "Backend Chat API" $true "Received response from model: $($response.data.message.model)"
    } else {
        Write-Error "Backend responded but format is incorrect"
        Write-Debug "Response structure: $($response | ConvertTo-Json -Depth 5)"
        Add-TestResult "Backend Chat API" $false "Invalid response format"
    }
} catch {
    Write-Error "Backend chat API failed: $($_.Exception.Message)"
    Write-Debug "Error details: $($_.Exception)"
    
    # Try to get more details from the response
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Debug "Error response body: $responseBody"
    }
    
    Add-TestResult "Backend Chat API" $false $_.Exception.Message
}

# TEST 7: Backend Streaming Chat API Test

Write-Section "TEST 7: Backend Streaming Chat API Test"

try {
    Write-Info "Testing backend streaming chat API..."
    
    $body = @{
        model = $TEST_MODEL
        messages = @(
            @{
                role = "user"
                content = "Count from 1 to 5"
            }
        )
        settings = @{}
    } | ConvertTo-Json -Depth 10
    
    Write-Debug "Request URL: $BACKEND_URL/api/chat/stream"
    Write-Debug "Request body: $body"
    
    # Use WebRequest instead of RestMethod for streaming
    $request = [System.Net.WebRequest]::Create("$BACKEND_URL/api/chat/stream")
    $request.Method = "POST"
    $request.ContentType = "application/json"
    $request.Timeout = 60000
    
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    $request.ContentLength = $bytes.Length
    $requestStream = $request.GetRequestStream()
    $requestStream.Write($bytes, 0, $bytes.Length)
    $requestStream.Close()
    
    Write-Info "Waiting for streaming response..."
    $response = $request.GetResponse()
    $reader = New-Object System.IO.StreamReader($response.GetResponseStream())
    
    $fullResponse = ""
    $chunkCount = 0
    
    Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║         STREAMING RESPONSE (Real-time)                     ║" -ForegroundColor Green
    Write-Host "╠═══════════════════════════════════════════════════════════╣" -ForegroundColor Green
    
    while ($true) {
        $line = $reader.ReadLine()
        if ($null -eq $line) { break }
        
        if ($line.StartsWith("data: ")) {
            $data = $line.Substring(6)
            if ($data -eq "[DONE]") {
                Write-Host "`n" -NoNewline
                Write-Success "Stream completed"
                break
            }
            
            try {
                $chunk = $data | ConvertFrom-Json
                if ($chunk.content) {
                    Write-Host $chunk.content -NoNewline -ForegroundColor White
                    $fullResponse += $chunk.content
                    $chunkCount++
                }
                if ($chunk.done) {
                    break
                }
            } catch {
                Write-Debug "Failed to parse chunk: $data"
            }
        }
    }
    
    Write-Host "`n╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    $reader.Close()
    $response.Close()
    
    if ($chunkCount -gt 0) {
        Write-Success "✓ STREAMING WORKS! Received $chunkCount chunks"
        Add-TestResult "Backend Streaming API" $true "Received $chunkCount chunks"
    } else {
        Write-Error "No streaming chunks received"
        Add-TestResult "Backend Streaming API" $false "No chunks received"
    }
    
} catch {
    Write-Error "Backend streaming API failed: $($_.Exception.Message)"
    Write-Debug "Error details: $($_.Exception)"
    Add-TestResult "Backend Streaming API" $false $_.Exception.Message
}

# ===================================================================
# TEST 8: Frontend API Client Test
# ===================================================================
Write-Section "TEST 8: Frontend API Constants Check"

try {
    Write-Info "Checking frontend API configuration..."
    
    $constantsPath = "src/lib/constants.ts"
    if (Test-Path $constantsPath) {
        $constantsContent = Get-Content $constantsPath -Raw
        
        if ($constantsContent -match "API_BASE_URL.*?['\"`"]([^'\"`"]+)['\"`"]") {
            $apiUrl = $matches[1]
            Write-Success "Frontend API_BASE_URL configured: $apiUrl"
            
            if ($apiUrl -eq "http://localhost:5000") {
                Write-Success "API URL matches backend URL"
                Add-TestResult "Frontend API Config" $true "Correctly configured to $apiUrl"
            } else {
                Write-Error "API URL mismatch! Frontend: $apiUrl, Backend: $BACKEND_URL"
                Add-TestResult "Frontend API Config" $false "URL mismatch: $apiUrl vs $BACKEND_URL"
            }
        } else {
            Write-Error "Could not find API_BASE_URL in constants.ts"
            Add-TestResult "Frontend API Config" $false "API_BASE_URL not found"
        }
    } else {
        Write-Error "constants.ts file not found"
        Add-TestResult "Frontend API Config" $false "File not found"
    }
} catch {
    Write-Error "Failed to check frontend config: $($_.Exception.Message)"
    Add-TestResult "Frontend API Config" $false $_.Exception.Message
}

# ===================================================================
# TEST SUMMARY
# ===================================================================
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                     TEST SUMMARY                               ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Host "Total Tests: $($testResults.Total)" -ForegroundColor White
Write-Host "Passed: $($testResults.Passed)" -ForegroundColor Green
Write-Host "Failed: $($testResults.Failed)" -ForegroundColor Red
Write-Host ""

Write-Host "Detailed Results:" -ForegroundColor Yellow
foreach ($test in $testResults.Tests) {
    if ($test.Passed) {
        Write-Host "  ✓ " -NoNewline -ForegroundColor Green
    } else {
        Write-Host "  ✗ " -NoNewline -ForegroundColor Red
    }
    Write-Host "$($test.Name): " -NoNewline
    Write-Host $test.Details -ForegroundColor Gray
}

Write-Host ""

# ===================================================================
# DIAGNOSIS AND RECOMMENDATIONS
# ===================================================================
if ($testResults.Failed -gt 0) {
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "║                  DIAGNOSIS & RECOMMENDATIONS                   ║" -ForegroundColor Yellow
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host ""
    
    # Check which component failed
    $ollamaTest = $testResults.Tests | Where-Object { $_.Name -eq "Ollama Connection" }
    $backendTest = $testResults.Tests | Where-Object { $_.Name -eq "Backend Server Ping" }
    $chatTest = $testResults.Tests | Where-Object { $_.Name -eq "Backend Chat API" }
    
    if (-not $ollamaTest.Passed) {
        Write-Host "⚠️  OLLAMA IS NOT RUNNING" -ForegroundColor Red
        Write-Host "   Solutions:" -ForegroundColor Yellow
        Write-Host "   1. Start Ollama: ollama serve" -ForegroundColor White
        Write-Host "   2. Pull a model: ollama pull llama2" -ForegroundColor White
        Write-Host ""
    }
    
    if (-not $backendTest.Passed) {
        Write-Host "⚠️  BACKEND SERVER IS NOT RUNNING" -ForegroundColor Red
        Write-Host "   Solutions:" -ForegroundColor Yellow
        Write-Host "   1. cd src/backend" -ForegroundColor White
        Write-Host "   2. npm install" -ForegroundColor White
        Write-Host "   3. node server.js" -ForegroundColor White
        Write-Host ""
    }
    
    if ($backendTest.Passed -and $ollamaTest.Passed -and -not $chatTest.Passed) {
        Write-Host "⚠️  CHAT API IS FAILING" -ForegroundColor Red
        Write-Host "   Possible causes:" -ForegroundColor Yellow
        Write-Host "   1. Model name mismatch (backend may be adding :latest tag)" -ForegroundColor White
        Write-Host "   2. Check backend logs for errors" -ForegroundColor White
        Write-Host "   3. Verify model is fully downloaded: ollama list" -ForegroundColor White
        Write-Host ""
    }
} else {
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                   ALL TESTS PASSED! ✓                          ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your AI ChatBot is working correctly!" -ForegroundColor Green
    Write-Host "The frontend should be able to communicate with the backend and get AI responses." -ForegroundColor White
    Write-Host ""
}

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
