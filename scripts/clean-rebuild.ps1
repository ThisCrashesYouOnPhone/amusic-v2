#!/usr/bin/env pwsh
# Quick cache clear for amusic development
# Usage: 
#   ./scripts/clean-rebuild.ps1           # Fast clean (just caches)
#   ./scripts/clean-rebuild.ps1 --full    # Slow clean (includes npm reinstall)

$isFull = $args -contains "--full"

if ($isFull) {
    Write-Host "🧹 Full clean (slower)..." -ForegroundColor Cyan
} else {
    Write-Host "⚡ Quick clean (fast)..." -ForegroundColor Cyan
}

# Remove frontend dist
if (Test-Path "dist") {
    Remove-Item -Recurse -Force dist -ErrorAction SilentlyContinue
    Write-Host "  ✓ Cleared dist/" -ForegroundColor Green
}

# Remove Rust debug build (this is key for catching changes)
if (Test-Path "src-tauri/target/debug") {
    Remove-Item -Recurse -Force src-tauri/target/debug -ErrorAction SilentlyContinue
    Write-Host "  ✓ Cleared Rust cache" -ForegroundColor Green
}

if ($isFull) {
    # Only do npm reinstall if explicitly requested
    Write-Host ""
    Write-Host "📦 Reinstalling node_modules..." -ForegroundColor Cyan
    
    if (Test-Path "node_modules") {
        Remove-Item -Recurse -Force node_modules -ErrorAction SilentlyContinue
    }
    
    npm install --silent
    Write-Host "  ✓ Dependencies installed" -ForegroundColor Green
}

Write-Host ""
Write-Host "✨ Done! Ready to go." -ForegroundColor Green
Write-Host ""

if ($isFull) {
    Write-Host "Next: npm run tauri dev" -ForegroundColor Yellow
} else {
    Write-Host "Next: npm run tauri dev  (or just restart the current dev session)" -ForegroundColor Yellow
}
