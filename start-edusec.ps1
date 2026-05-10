# Quick Start Script for EduSec Docker Setup

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "EduSec Docker Setup - Quick Start" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is installed
Write-Host "Checking Docker installation..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "??? Docker is installed: $dockerVersion" -ForegroundColor Green
    } else {
        throw "Docker not found"
    }
} catch {
    Write-Host "??? Docker is not installed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Docker Desktop first:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://www.docker.com/products/docker-desktop" -ForegroundColor White
    Write-Host "2. Or see INSTALL_DOCKER.md for detailed instructions" -ForegroundColor White
    Write-Host ""
    Write-Host "After installing Docker, run this script again." -ForegroundColor Yellow
    exit 1
}

# Check if Docker is running
Write-Host "Checking if Docker is running..." -ForegroundColor Yellow
try {
    docker ps 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "??? Docker is running" -ForegroundColor Green
    } else {
        throw "Docker not running"
    }
} catch {
    Write-Host "??? Docker is not running!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please start Docker Desktop and wait for it to be ready." -ForegroundColor Yellow
    Write-Host "Look for the Docker whale icon in your system tray." -ForegroundColor White
    Write-Host ""
    Write-Host "After Docker is running, run this script again." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Building and Starting Containers" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This may take 5-10 minutes on first run..." -ForegroundColor Yellow
Write-Host ""

# Build and start containers
docker compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "??? Containers Started Successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    
    # Wait for MySQL to be ready
    Write-Host "Waiting for MySQL to initialize (this may take 30 seconds)..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    
    $maxAttempts = 30
    $attempt = 0
    $mysqlReady = $false
    
    while ($attempt -lt $maxAttempts -and -not $mysqlReady) {
        $attempt++
        $logs = docker compose logs db 2>$null | Select-String "ready for connections"
        if ($logs) {
            $mysqlReady = $true
            Write-Host "??? MySQL is ready!" -ForegroundColor Green
        } else {
            Write-Host "." -NoNewline -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
    }
    
    Write-Host ""
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Container Status" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    docker compose ps
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "??? EduSec is Ready!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Access the application at:" -ForegroundColor Yellow
    Write-Host "  http://localhost:8080" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host ""
    Write-Host "Database credentials for installation:" -ForegroundColor Yellow
    Write-Host "  Host: db" -ForegroundColor White
    Write-Host "  Database: edusec" -ForegroundColor White
    Write-Host "  Username: edusec_user" -ForegroundColor White
    Write-Host "  Password: edusec_pass" -ForegroundColor White
    Write-Host ""
    Write-Host "Opening browser..." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    Start-Process "http://localhost:8080"
    
} else {
    Write-Host ""
    Write-Host "??? Failed to start containers!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Check the logs with:" -ForegroundColor Yellow
    Write-Host "  docker compose logs" -ForegroundColor White
    Write-Host ""
    Write-Host "See DOCKER_README.md for troubleshooting." -ForegroundColor Yellow
    exit 1
}

