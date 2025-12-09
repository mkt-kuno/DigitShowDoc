#!/usr/bin/env node
/**
 * Generate Table of Contents from Markdown headings
 * This script parses markdown files and creates a TOC HTML structure
 */

const fs = require('fs');
const path = require('path');

/**
 * Extract headings from markdown content
 * @param {string} markdown - Markdown content
 * @returns {Array} Array of heading objects with level, text, and id
 */
function extractHeadings(markdown) {
    const headings = [];
    const lines = markdown.split('\n');
    
    for (const line of lines) {
        const match = line.match(/^(#{2,4})\s+(.+)$/);
        if (match) {
            const level = match[1].length;
            const text = match[2].trim();
            // Create id from text (simple slug generation)
            const id = text
                .toLowerCase()
                .replace(/[^\w\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FFF\s-]/g, '')
                .replace(/\s+/g, '-')
                .replace(/-+/g, '-')
                .replace(/^-|-$/g, '');
            
            headings.push({ level, text, id });
        }
    }
    
    return headings;
}

/**
 * Generate TOC HTML from headings
 * @param {Array} headings - Array of heading objects
 * @returns {string} HTML string for TOC
 */
function generateTocHtml(headings) {
    if (headings.length === 0) {
        return '';
    }
    
    let html = '<nav class="toc">\n';
    html += '<details open>\n';
    html += '<summary><strong>目次 / Table of Contents</strong></summary>\n';
    html += '<ul>\n';
    
    let currentLevel = 2;
    const stack = [];
    
    for (const heading of headings) {
        // Skip h1 headings (they're usually the page title)
        if (heading.level === 1) continue;
        
        // Close nested lists if going back to higher level
        while (currentLevel > heading.level && stack.length > 0) {
            html += '</ul>\n</li>\n';
            stack.pop();
            currentLevel--;
        }
        
        // Open nested list if going deeper
        while (currentLevel < heading.level) {
            if (stack.length > 0) {
                html += '\n<ul>\n';
            }
            stack.push(heading.level);
            currentLevel++;
        }
        
        // Add the heading link
        html += `<li><a href="#${heading.id}">${heading.text}</a>`;
        
        // Close the li tag if next heading is same or higher level
        const nextIndex = headings.indexOf(heading) + 1;
        if (nextIndex < headings.length) {
            const nextHeading = headings[nextIndex];
            if (nextHeading.level <= heading.level) {
                html += '</li>\n';
            }
        } else {
            html += '</li>\n';
        }
    }
    
    // Close any remaining open lists
    while (stack.length > 0) {
        html += '</ul>\n</li>\n';
        stack.pop();
    }
    
    html += '</ul>\n';
    html += '</details>\n';
    html += '</nav>\n';
    
    return html;
}

/**
 * Add IDs to headings in HTML content
 * @param {string} html - HTML content
 * @param {Array} headings - Array of heading objects
 * @returns {string} HTML with IDs added to headings
 */
function addHeadingIds(html, headings) {
    let result = html;
    
    for (const heading of headings) {
        // Match h2-h4 tags and add id if not present
        const pattern = new RegExp(`(<h${heading.level}[^>]*>)(${escapeRegex(heading.text)})(</h${heading.level}>)`, 'i');
        result = result.replace(pattern, (match, openTag, text, closeTag) => {
            if (openTag.includes('id=')) {
                return match; // Already has an id
            }
            return `<h${heading.level} id="${heading.id}">${text}</h${heading.level}>`;
        });
    }
    
    return result;
}

/**
 * Escape special regex characters
 * @param {string} str - String to escape
 * @returns {string} Escaped string
 */
function escapeRegex(str) {
    return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

/**
 * Process a markdown file and return TOC HTML
 * @param {string} markdownPath - Path to markdown file
 * @returns {Object} Object with tocHtml and headings
 */
function processMarkdownFile(markdownPath) {
    const markdown = fs.readFileSync(markdownPath, 'utf-8');
    const headings = extractHeadings(markdown);
    const tocHtml = generateTocHtml(headings);
    
    return { tocHtml, headings };
}

// Export functions for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        extractHeadings,
        generateTocHtml,
        addHeadingIds,
        processMarkdownFile
    };
}

// CLI usage
if (require.main === module) {
    const args = process.argv.slice(2);
    
    if (args.length === 0) {
        console.error('Usage: node generate-toc.js <markdown-file>');
        process.exit(1);
    }
    
    const markdownPath = args[0];
    
    if (!fs.existsSync(markdownPath)) {
        console.error(`File not found: ${markdownPath}`);
        process.exit(1);
    }
    
    const { tocHtml, headings } = processMarkdownFile(markdownPath);
    
    console.log('Generated TOC:');
    console.log(tocHtml);
    console.log(`\nFound ${headings.length} headings`);
}
