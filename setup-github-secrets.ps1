# GitHub Secrets Setup Script (PowerShell)
# This script helps you set up the required GitHub secrets for the CI/CD pipeline

Write-Host "🚀 Setting up GitHub Secrets for CI/CD Pipeline" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""

# Check if GitHub CLI is installed
try {
    $ghVersion = gh --version
    Write-Host "✅ GitHub CLI is installed: $($ghVersion[0])" -ForegroundColor Green
} catch {
    Write-Host "❌ GitHub CLI (gh) is not installed." -ForegroundColor Red
    Write-Host "Please install it from: https://cli.github.com/" -ForegroundColor Yellow
    exit 1
}

# Check if user is authenticated
try {
    gh auth status | Out-Null
    Write-Host "✅ GitHub CLI is authenticated" -ForegroundColor Green
} catch {
    Write-Host "❌ Not authenticated with GitHub CLI." -ForegroundColor Red
    Write-Host "Please run: gh auth login" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Get repository information
$repo = gh repo view --json nameWithOwner -q .nameWithOwner
Write-Host "📂 Repository: $repo" -ForegroundColor Cyan
Write-Host ""

# Function to set a secret
function Set-GitHubSecret {
    param(
        [string]$SecretName,
        [string]$Description,
        [bool]$IsSensitive = $false
    )
    
    Write-Host "Setting up: $SecretName" -ForegroundColor Yellow
    Write-Host "Description: $Description" -ForegroundColor Gray
    
    if ($IsSensitive) {
        $SecureValue = Read-Host "Enter value (input will be hidden)" -AsSecureString
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureValue)
        $SecretValue = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
    } else {
        $SecretValue = Read-Host "Enter value"
    }
    
    if ($SecretValue) {
        $SecretValue | gh secret set $SecretName
        Write-Host "✅ $SecretName set successfully" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Skipping $SecretName (empty value)" -ForegroundColor Yellow
    }
    Write-Host ""
}

Write-Host "🔐 Setting up required secrets..." -ForegroundColor Magenta
Write-Host ""

# Set up Slack Webhook URL
Write-Host "1. SLACK WEBHOOK SETUP" -ForegroundColor Cyan
Write-Host "----------------------" -ForegroundColor Cyan
Write-Host "To get your Slack webhook URL:"
Write-Host "1. Go to https://api.slack.com/apps"
Write-Host "2. Create a new app or select existing"
Write-Host "3. Go to 'Incoming Webhooks' and activate"
Write-Host "4. Create a new webhook for your channel"
Write-Host "5. Copy the webhook URL"
Write-Host ""
Set-GitHubSecret -SecretName "SLACK_WEBHOOK_URL" -Description "Slack webhook URL for notifications" -IsSensitive $true

# Set up test user credentials
Write-Host "2. TEST USER CREDENTIALS" -ForegroundColor Cyan
Write-Host "------------------------" -ForegroundColor Cyan
Write-Host "These credentials are used for E2E testing"
Write-Host ""
Set-GitHubSecret -SecretName "TEST_USER_EMAIL" -Description "Email for test user account" -IsSensitive $false
Set-GitHubSecret -SecretName "TEST_USER_PASSWORD" -Description "Password for test user account" -IsSensitive $true

# Optional: OpenAI key for PR agent
Write-Host "3. OPTIONAL: OPENAI API KEY" -ForegroundColor Cyan
Write-Host "---------------------------" -ForegroundColor Cyan
Write-Host "Required only if you want to use the PR Agent workflow"
Write-Host ""
$setupOpenAI = Read-Host "Do you want to set up OpenAI API key for PR Agent? (y/n)"

if ($setupOpenAI -eq "y" -or $setupOpenAI -eq "Y") {
    Set-GitHubSecret -SecretName "OPENAI_KEY" -Description "OpenAI API key for PR Agent" -IsSensitive $true
}

Write-Host "✨ Setup completed!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Summary of secrets set:" -ForegroundColor Cyan
gh secret list

Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor Magenta
Write-Host "1. Commit and push your workflow files to trigger CI/CD"
Write-Host "2. Check the Actions tab in your GitHub repository"
Write-Host "3. Monitor Slack for notifications"
Write-Host "4. Review the CI_CD_DOCUMENTATION.md for detailed information"
Write-Host ""
Write-Host "🔧 Testing the setup:" -ForegroundColor Yellow
Write-Host "- Create a pull request to test the CI workflow"
Write-Host "- Manually trigger the E2E tests from Actions tab"
Write-Host "- Check if Slack notifications are working"

Read-Host "Press Enter to continue..."
