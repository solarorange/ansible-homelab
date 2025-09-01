#!/bin/bash

# CodeRabbit Review Starter Script
# This script helps you get started with the iterative code review process

set -e

echo "🚀 Starting CodeRabbit Iterative Review Process"
echo "================================================"
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: This script must be run from a git repository"
    exit 1
fi

# Check current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "📍 Current branch: $CURRENT_BRANCH"

# Check if we have uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  Warning: You have uncommitted changes"
    echo "   Consider committing or stashing them before starting the review"
    echo ""
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Review process cancelled"
        exit 0
    fi
fi

echo ""
echo "📋 Review Checklist Status:"
echo "============================"

# Check for CodeRabbit configuration
if [ -f ".coderabbit.yaml" ]; then
    echo "✅ CodeRabbit configuration found"
else
    echo "❌ CodeRabbit configuration missing"
fi

# Check for GitHub workflow
if [ -f ".github/workflows/coderabbit.yml" ]; then
    echo "✅ GitHub workflow configured"
else
    echo "❌ GitHub workflow missing"
fi

# Check for review checklist
if [ -f "CODERABBIT_REVIEW_CHECKLIST.md" ]; then
    echo "✅ Review checklist available"
else
    echo "❌ Review checklist missing"
fi

# Check for quick start guide
if [ -f "CODERABBIT_QUICK_START.md" ]; then
    echo "✅ Quick start guide available"
else
    echo "❌ Quick start guide missing"
fi

echo ""
echo "🔧 Setup Requirements:"
echo "======================"

# Check if we have the required files
MISSING_FILES=0

if [ ! -f ".coderabbit.yaml" ]; then
    echo "❌ Missing: .coderabbit.yaml"
    MISSING_FILES=$((MISSING_FILES + 1))
fi

if [ ! -f ".github/workflows/coderabbit.yml" ]; then
    echo "❌ Missing: .github/workflows/coderabbit.yml"
    MISSING_FILES=$((MISSING_FILES + 1))
fi

if [ $MISSING_FILES -gt 0 ]; then
    echo ""
    echo "❌ Some required files are missing. Please ensure all files are created before proceeding."
    exit 1
fi

echo "✅ All required files are present"
echo ""

echo "🚀 Ready to Start Review Process!"
echo "================================"
echo ""
echo "Next steps:"
echo "1. 🔑 Set up your CodeRabbit API key in GitHub repository secrets"
echo "   - Go to your repository Settings > Secrets and variables > Actions"
echo "   - Add secret: CODERABBIT_AI_API_KEY"
echo "   - Get your key from: https://coderabbit.ai"
echo ""
echo "2. 📝 Create a test pull request to trigger the first review"
echo "   - Make a small change to any file"
echo "   - Commit and push to a new branch"
echo "   - Create a PR against main branch"
echo ""
echo "3. 🔍 Review the CodeRabbit feedback"
echo "   - Check the PR comments for CodeRabbit suggestions"
echo "   - Prioritize issues by severity (Critical > High > Medium > Low)"
echo "   - Start with Phase 1 of the review checklist"
echo ""
echo "4. 🔄 Iterate through fixes"
echo "   - Fix one issue at a time"
echo "   - Test each fix"
echo "   - Commit and push to trigger another review"
echo ""

# Check if we're on main branch
if [ "$CURRENT_BRANCH" = "main" ]; then
    echo "💡 Tip: You're currently on the main branch."
    echo "   Consider creating a feature branch for your review work:"
    echo "   git checkout -b coderabbit-review"
    echo ""
fi

echo "📚 Documentation:"
echo "================"
echo "- Review Checklist: CODERABBIT_REVIEW_CHECKLIST.md"
echo "- Quick Start Guide: CODERABBIT_QUICK_START.md"
echo "- CodeRabbit Docs: https://docs.coderabbit.ai"
echo ""

echo "🎯 Review Focus:"
echo "================"
echo "Remember: We're focusing on FUNCTIONALITY and RELIABILITY, not new features."
echo "The goal is to make your homelab work reliably in production."
echo ""

echo "✅ Setup complete! You're ready to start the iterative review process."
echo ""
echo "Happy reviewing! 🐰✨"
