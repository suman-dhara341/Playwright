# CI/CD Pipeline Setup Guide

## 🚀 Overview

This repository now includes a comprehensive CI/CD pipeline with Slack notifications for automated testing and deployment. The pipeline supports multiple environments, cross-browser testing, and detailed reporting.

## 📋 Quick Setup

### 1. Prerequisites

- GitHub repository with Actions enabled
- Slack workspace with webhook permissions
- Test user credentials for your application

### 2. Set Up GitHub Secrets

Run the setup script to configure required secrets:

**Windows (PowerShell):**

```powershell
npm run setup:secrets
```

**Linux/Mac (Bash):**

```bash
chmod +x setup-github-secrets.sh
./setup-github-secrets.sh
```

**Manual Setup:**
Go to your GitHub repository → Settings → Secrets and variables → Actions, and add:

| Secret Name          | Description                     | Example                                |
| -------------------- | ------------------------------- | -------------------------------------- |
| `SLACK_WEBHOOK_URL`  | Slack webhook for notifications | `https://hooks.slack.com/services/...` |
| `TEST_USER_EMAIL`    | Test user email                 | `test@example.com`                     |
| `TEST_USER_PASSWORD` | Test user password              | `SecurePassword123`                    |
| `OPENAI_KEY`         | (Optional) For PR Agent         | `sk-...`                               |

### 3. Configure Slack Webhook

1. Go to [Slack API Apps](https://api.slack.com/apps)
2. Create a new app or select existing
3. Enable "Incoming Webhooks"
4. Create webhook for your desired channel
5. Copy the webhook URL to GitHub secrets

## 🔄 Available Workflows

### 1. Continuous Integration (`ci.yml`)

- **Triggers**: Push/PR to main/develop
- **Features**: Linting, type checking, building, security scans
- **Notifications**: Build status to Slack

### 2. E2E Tests (`e2e.yml`)

- **Triggers**: Push/PR, daily schedule, manual
- **Features**: Comprehensive testing with detailed reporting
- **Environments**: alpha, prod, local
- **Notifications**: Rich test results with failure details

### 3. Deployment (`deploy.yml`)

- **Triggers**: Push to develop, manual
- **Features**: Environment deployment with smoke tests
- **Notifications**: Deployment status and links

### 4. Nightly Tests (`nightly.yml`)

- **Triggers**: Daily at 2:00 AM UTC, manual
- **Features**: Cross-browser testing (Chrome, Firefox, Safari)
- **Notifications**: Comprehensive test summary

## 🧪 Running Tests

### Local Development

```bash
# Run all tests
npm run test:e2e

# Run with UI mode
npm run test:e2e:ui

# Run specific test suites
npm run test:auth
npm run test:awards
npm run test:badges
npm run test:feed

# Debug mode
npm run test:e2e:debug

# Generate CI-style reports
npm run test:ci
```

### CI Environment

Tests automatically run on:

- Every push to main/develop
- Every pull request
- Daily schedule (nightly tests)
- Manual triggers from GitHub Actions

## 📊 Slack Notifications

### Notification Types

#### 1. E2E Test Results

```
✅ Playwright E2E Test Results
Repository: your-org/your-repo
Branch: main
Environment: alpha

Total Tests: 15
Passed: 14 ✅
Failed: 1 ❌
Skipped: 0 ⏭️

Failed Tests:
• Badge Page
  File: badge.spec.ts
  Error: Element not found

[View Workflow Run] [View Test Report]
```

#### 2. Deployment Status

```
🚀 Deployment to alpha
Status: ✅ Success
Environment: alpha
Branch: develop
Commit: abc123

[View Deployment]
```

#### 3. Nightly Summary

```
🌙✅ Nightly E2E Test Results
Test Suite: all
Environment: alpha
Browsers: chromium firefox webkit

Passed: 45 ✅
Failed: 2 ❌
Skipped: 1 ⏭️
Overall: PASSED

[View Full Report]
```

## 🎯 Manual Triggers

### Trigger E2E Tests

1. Go to GitHub Actions
2. Select "Playwright E2E Tests"
3. Click "Run workflow"
4. Choose environment (alpha/prod/local)

### Trigger Deployment

1. Go to GitHub Actions
2. Select "Deploy to Staging"
3. Click "Run workflow"
4. Choose target environment

### Trigger Nightly Tests

1. Go to GitHub Actions
2. Select "Nightly E2E Tests"
3. Click "Run workflow"
4. Choose environment and test suite

## 🔧 Configuration

### Environment Variables

| Variable          | Description         | Default      |
| ----------------- | ------------------- | ------------ |
| `VITE_STAGE_NAME` | Target environment  | `alpha`      |
| `CI`              | CI environment flag | `true` in CI |

### Supported Environments

- **local**: Development (localhost:5173)
- **alpha**: Staging environment
- **prod**: Production environment

### Browser Support

- **Chromium**: Primary browser for all tests
- **Firefox**: Nightly tests only
- **WebKit**: Nightly tests only
- **Mobile**: Chrome/Safari simulation available

## 📈 Monitoring

### Test Artifacts

- HTML reports with screenshots/videos
- JSON results for programmatic analysis
- Trace files for debugging
- Performance metrics

### Retention Policy

- Regular tests: 7 days
- Nightly tests: 14 days

## 🛠 Troubleshooting

### Common Issues

1. **Tests fail in CI but pass locally**

   - Check environment variables
   - Verify network conditions in CI
   - Review CI-specific timeouts

2. **Slack notifications not working**

   - Verify webhook URL in secrets
   - Check webhook permissions in Slack
   - Review notification payload in logs

3. **Authentication failures**
   - Verify test credentials are valid
   - Check if 2FA is enabled on test account
   - Ensure credentials haven't expired

### Debug Steps

1. **Check Actions logs**: GitHub → Actions → Select workflow run
2. **Download artifacts**: Test reports, screenshots, videos
3. **Local reproduction**: Use same environment variables
4. **Slack webhook test**: Use curl to test webhook directly

## 📚 Documentation

- [CI/CD Documentation](./CI_CD_DOCUMENTATION.md) - Comprehensive pipeline details
- [Playwright Reliability Guide](./PLAYWRIGHT_RELIABILITY_GUIDE.md) - Test best practices

## 🔄 Maintenance

### Regular Tasks

- [ ] Monthly dependency updates
- [ ] Quarterly credential rotation
- [ ] Weekly failure pattern analysis
- [ ] Performance monitoring review

### Scaling Options

- Increase parallel workers
- Add regional testing
- Implement test sharding
- Add performance benchmarks

## 🆘 Support

For issues with the CI/CD pipeline:

1. Check this documentation
2. Review GitHub Actions logs
3. Download test artifacts for analysis
4. Create an issue with logs and screenshots

---

## 🎉 You're All Set!

Your CI/CD pipeline is now configured with:

- ✅ Automated testing on every change
- ✅ Rich Slack notifications
- ✅ Cross-browser compatibility testing
- ✅ Environment-specific deployments
- ✅ Comprehensive reporting and artifacts

Happy testing! 🚀
