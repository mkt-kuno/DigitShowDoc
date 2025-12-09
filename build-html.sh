#!/bin/bash
# Bash script to convert Markdown to HTML with automatic TOC generation
# This script replicates the GitHub Actions workflow for local development

set -e

# Simply call the Node.js build script
node build-html.js
