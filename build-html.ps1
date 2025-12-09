# PowerShell script to convert Markdown to HTML with automatic TOC generation
# This script replicates the GitHub Actions workflow for local development

Write-Host "=== Markdown to HTML Converter with TOC ===" -ForegroundColor Cyan

# Simply call the Node.js build script
node build-html.js

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n✗ Build failed!" -ForegroundColor Red
    exit $LASTEXITCODE
} else {
    Write-Host "`n✓ Build completed successfully!" -ForegroundColor Green
}
