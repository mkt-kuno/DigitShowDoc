# PowerShell script to convert Markdown to HTML
# This script replicates the GitHub Actions workflow for local development

Write-Host "=== Markdown to HTML Converter ===" -ForegroundColor Cyan

# Install marked if not present
if (-not (Test-Path "node_modules/marked")) {
    Write-Host "Installing marked..." -ForegroundColor Yellow
    npm install marked
}

# Create docs directory
Write-Host "Creating docs directory..." -ForegroundColor Green
New-Item -ItemType Directory -Force -Path "docs" | Out-Null

# Copy images
Write-Host "Copying images..." -ForegroundColor Green
if (Test-Path "img") {
    Copy-Item -Recurse -Force "img" "docs/" -ErrorAction SilentlyContinue
}

# HTML template
$htmlTemplate = @'
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{TITLE} - DigitShow Modbus Documentation</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/github-markdown-css@5/github-markdown.min.css">
    <style>
        body {
            background-color: #ffffff;
            margin: 0;
            padding: 0;
        }
        .markdown-body {
            box-sizing: border-box;
            min-width: 200px;
            max-width: 980px;
            margin: 0 auto;
            padding: 45px;
        }
        @media (max-width: 767px) {
            .markdown-body {
                padding: 15px;
            }
        }
        .nav-menu {
            background-color: #f6f8fa;
            border-bottom: 1px solid #d0d7de;
            padding: 10px 0;
            margin-bottom: 20px;
        }
        .nav-menu ul {
            list-style: none;
            padding: 0;
            margin: 0 auto;
            max-width: 980px;
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            padding: 0 45px;
        }
        .nav-menu a {
            text-decoration: none;
            color: #0969da;
            font-weight: 500;
        }
        .nav-menu a:hover {
            text-decoration: underline;
        }
        @media (max-width: 767px) {
            .nav-menu ul {
                padding: 0 15px;
            }
        }
    </style>
</head>
<body>
    <nav class="nav-menu">
        <ul>
            <li><a href="index.html">ホーム</a></li>
            <li><a href="quickstart.html">クイックスタート</a></li>
            <li><a href="user_manual.html">ユーザーマニュアル</a></li>
            <li><a href="developer_manual.html">デベロッパーマニュアル</a></li>
            <li><a href="markdown_guide.html">編集ガイド</a></li>
        </ul>
    </nav>
    <article class="markdown-body">
{CONTENT}
    </article>
</body>
</html>
'@

# Convert each markdown file
Write-Host "`nConverting Markdown files to HTML..." -ForegroundColor Green
$markdownFiles = Get-ChildItem -Filter "*.md"

foreach ($file in $markdownFiles) {
    $mdFile = $file.Name
    $baseName = $file.BaseName
    $htmlFile = "docs/$baseName.html"
    
    Write-Host "  Processing $mdFile..." -ForegroundColor Gray
    
    # Extract title from first heading
    $title = (Select-String -Path $mdFile -Pattern "^# " | Select-Object -First 1 | ForEach-Object { 
        $_.Line -replace "^# ", "" 
    })
    if (-not $title) { 
        $title = $baseName 
    }
    
    # Convert markdown to HTML
    $content = npx marked $mdFile
    
    # Replace .md links with .html
    $content = $content -replace 'href="([^"]*?)\.md"', 'href="$1.html"'
    
    # Create final HTML
    $html = $htmlTemplate -replace "\{TITLE\}", $title -replace "\{CONTENT\}", $content
    
    # Write to file with UTF-8 encoding
    [System.IO.File]::WriteAllText((Join-Path (Get-Location) $htmlFile), $html, [System.Text.UTF8Encoding]::new($false))
    
    Write-Host "  ✓ Created $htmlFile" -ForegroundColor Green
}

Write-Host "`n=== Conversion Complete ===" -ForegroundColor Cyan
Write-Host "`nGenerated HTML files:" -ForegroundColor Yellow
Get-ChildItem "docs/*.html" | ForEach-Object {
    Write-Host "  $($_.Name) ($([math]::Round($_.Length / 1KB, 2)) KB)" -ForegroundColor White
}

Write-Host "`nYou can open docs/index.html in your browser to view the documentation." -ForegroundColor Cyan
