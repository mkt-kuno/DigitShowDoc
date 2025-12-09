#!/bin/bash
# Bash script to convert Markdown to HTML
# This script replicates the GitHub Actions workflow for local development

set -e

echo "=== Markdown to HTML Converter ==="

# Install marked if not present
if [ ! -d "node_modules/marked" ]; then
    echo "Installing marked..."
    npm install marked
fi

# Create docs directory
echo "Creating docs directory..."
mkdir -p docs

# Copy images
echo "Copying images..."
cp -r img docs/ 2>/dev/null || true

# HTML template function
create_html() {
  local title="$1"
  local content="$2"
  local filename="$3"
  
  cat > "docs/$filename" << EOF
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title - DigitShow Modbus Documentation</title>
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
$content
    </article>
</body>
</html>
EOF
}

# Convert each markdown file
echo ""
echo "Converting Markdown files to HTML..."
for md_file in *.md; do
  if [ -f "$md_file" ]; then
    base_name="${md_file%.md}"
    html_file="${base_name}.html"
    
    echo "  Processing $md_file..."
    
    # Get title from first heading or use filename
    title=$(grep -m 1 "^# " "$md_file" | sed 's/^# //' || echo "$base_name")
    
    # Convert markdown to HTML and replace .md links with .html
    content=$(npx marked "$md_file" | sed 's/href="\([^"]*\)\.md"/href="\1.html"/g')
    
    # Create HTML file
    create_html "$title" "$content" "$html_file"
    
    echo "  ✓ Created docs/$html_file"
  fi
done

echo ""
echo "=== Conversion Complete ==="
echo ""
echo "Generated HTML files:"
ls -lh docs/*.html | awk '{print "  " $9 " (" $5 ")"}'

echo ""
echo "You can open docs/index.html in your browser to view the documentation."
