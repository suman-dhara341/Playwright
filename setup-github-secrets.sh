#!/bin/bash

# GitHub Secrets Setup Script
# This script helps you set up the required GitHub secrets for the CI/CD pipeline

echo "🚀 Setting up GitHub Secrets for CI/CD Pipeline"
echo "================================================"
echo ""

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo "Please install it from: https://cli.github.com/"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub CLI."
    echo "Please run: gh auth login"
    exit 1
fi

echo "✅ GitHub CLI is installed and authenticated"
echo ""

# Get repository information
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
echo "📂 Repository: $REPO"
echo ""

# Function to set a secret
set_secret() {
    local secret_name=$1
    local secret_description=$2
    local is_sensitive=$3
    
    echo "Setting up: $secret_name"
    echo "Description: $secret_description"
    
    if [ "$is_sensitive" = "true" ]; then
        echo -n "Enter value (input will be hidden): "
        read -s secret_value
        echo ""
    else
        echo -n "Enter value: "
        read secret_value
    fi
    
    if [ -n "$secret_value" ]; then
        echo "$secret_value" | gh secret set "$secret_name"
        echo "✅ $secret_name set successfully"
    else
        echo "⚠️  Skipping $secret_name (empty value)"
    fi
    echo ""
}

echo "🔐 Setting up required secrets..."
echo ""

# Set up Slack Webhook URL
echo "1. SLACK WEBHOOK SETUP"
echo "----------------------"
echo "To get your Slack webhook URL:"
echo "1. Go to https://api.slack.com/apps"
echo "2. Create a new app or select existing"
echo "3. Go to 'Incoming Webhooks' and activate"
echo "4. Create a new webhook for your channel"
echo "5. Copy the webhook URL"
echo ""
set_secret "SLACK_WEBHOOK_URL" "Slack webhook URL for notifications" true

# Set up test user credentials
echo "2. TEST USER CREDENTIALS"
echo "------------------------"
echo "These credentials are used for E2E testing"
echo ""
set_secret "TEST_USER_EMAIL" "Email for test user account" false
set_secret "TEST_USER_PASSWORD" "Password for test user account" true

# Optional: OpenAI key for PR agent
echo "3. OPTIONAL: OPENAI API KEY"
echo "---------------------------"
echo "Required only if you want to use the PR Agent workflow"
echo ""
read -p "Do you want to set up OpenAI API key for PR Agent? (y/n): " setup_openai

if [ "$setup_openai" = "y" ] || [ "$setup_openai" = "Y" ]; then
    set_secret "OPENAI_KEY" "OpenAI API key for PR Agent" true
fi

echo "✨ Setup completed!"
echo ""
echo "📋 Summary of secrets set:"
gh secret list

echo ""
echo "🎯 Next Steps:"
echo "1. Commit and push your workflow files to trigger CI/CD"
echo "2. Check the Actions tab in your GitHub repository"
echo "3. Monitor Slack for notifications"
echo "4. Review the CI_CD_DOCUMENTATION.md for detailed information"
echo ""
echo "🔧 Testing the setup:"
echo "- Create a pull request to test the CI workflow"
echo "- Manually trigger the E2E tests from Actions tab"
echo "- Check if Slack notifications are working"
