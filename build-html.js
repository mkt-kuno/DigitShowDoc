#!/usr/bin/env node
/**
 * Build HTML from Markdown with TOC generation
 * This script converts all markdown files to HTML with automatic table of contents
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Import TOC generator
const { processMarkdownFile, addHeadingIds } = require('./generate-toc.js');

// Ensure marked is installed
try {
    require.resolve('marked');
} catch (e) {
    console.log('Installing marked...');
    execSync('npm install marked', { stdio: 'inherit' });
}

const { marked } = require('marked');

// HTML template with TOC placeholder
function createHtmlTemplate(title, tocHtml, contentHtml) {
    return `<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${escapeHtml(title)} - DigitShow Modbus Documentation</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/github-markdown-css@5/github-markdown.min.css">
    <style>
        /* Let the browser handle colors - no forced background colors */
        body {
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
        /* Simple navigation menu */
        .nav-menu {
            padding: 16px 0;
            margin-bottom: 24px;
            border-bottom: 1px solid;
            border-color: inherit;
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
        }
        .nav-menu a:hover {
            text-decoration: underline;
        }
        @media (max-width: 767px) {
            .nav-menu ul {
                padding: 0 15px;
            }
        }
        /* Simple TOC styles - let inherited colors apply */
        .toc {
            padding: 16px;
            margin-bottom: 24px;
            border: 1px solid;
            border-radius: 6px;
            border-color: inherit;
        }
        .toc summary {
            cursor: pointer;
            user-select: none;
            margin-bottom: 8px;
            font-weight: bold;
        }
        .toc summary:hover {
            opacity: 0.8;
        }
        .toc ul {
            list-style: none;
            padding-left: 0;
            margin: 8px 0;
        }
        .toc ul ul {
            padding-left: 20px;
            margin-top: 4px;
        }
        .toc li {
            margin: 4px 0;
        }
        .toc a {
            text-decoration: none;
        }
        .toc a:hover {
            text-decoration: underline;
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
${tocHtml}
${contentHtml}
    </article>
</body>
</html>`;
}

// Escape HTML special characters
function escapeHtml(text) {
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, m => map[m]);
}

// Main function
function main() {
    console.log('=== Markdown to HTML Converter with TOC ===\n');
    
    // Create docs directory
    console.log('Creating docs directory...');
    if (!fs.existsSync('docs')) {
        fs.mkdirSync('docs');
    }
    
    // Copy images
    console.log('Copying images...');
    if (fs.existsSync('img')) {
        execSync('cp -r img docs/', { stdio: 'pipe' });
    }
    
    // Process each markdown file
    console.log('\nConverting Markdown files to HTML with TOC...');
    const markdownFiles = fs.readdirSync('.').filter(f => f.endsWith('.md'));
    
    for (const mdFile of markdownFiles) {
        const baseName = path.basename(mdFile, '.md');
        const htmlFile = `${baseName}.html`;
        
        console.log(`  Processing ${mdFile}...`);
        
        try {
            // Read markdown
            const markdown = fs.readFileSync(mdFile, 'utf-8');
            
            // Extract title from first heading
            const titleMatch = markdown.match(/^# (.+)$/m);
            const title = titleMatch ? titleMatch[1] : baseName;
            
            // Generate TOC
            const { tocHtml, headings } = processMarkdownFile(mdFile);
            
            // Convert markdown to HTML
            let contentHtml = marked(markdown);
            
            // Replace .md links with .html
            contentHtml = contentHtml.replace(/href="([^"]*?)\.md"/g, 'href="$1.html"');
            
            // Add IDs to headings
            contentHtml = addHeadingIds(contentHtml, headings);
            
            // Generate final HTML
            const html = createHtmlTemplate(title, tocHtml, contentHtml);
            
            // Write to file
            fs.writeFileSync(path.join('docs', htmlFile), html, 'utf-8');
            
            console.log(`  ✓ Created docs/${htmlFile} (with TOC)`);
        } catch (error) {
            console.error(`  ✗ Error processing ${mdFile}:`, error.message);
        }
    }
    
    console.log('\n=== Conversion Complete ===\n');
    console.log('Generated HTML files:');
    const htmlFiles = fs.readdirSync('docs').filter(f => f.endsWith('.html'));
    for (const file of htmlFiles) {
        const stats = fs.statSync(path.join('docs', file));
        const sizeKB = (stats.size / 1024).toFixed(1);
        console.log(`  ${file} (${sizeKB} KB)`);
    }
    
    console.log('\nYou can open docs/index.html in your browser to view the documentation.');
}

// Run if called directly
if (require.main === module) {
    main();
}

module.exports = { main };
