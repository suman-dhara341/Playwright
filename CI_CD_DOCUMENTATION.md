# CI/CD Pipeline Documentation

This document describes the CI/CD pipeline setup for the Playwright E2E testing project with Slack notifications.

## Overview

Our CI/CD pipeline consists of multiple workflows that handle different aspects of continuous integration and deployment:

1. **Continuous Integration** (`ci.yml`) - Runs on every push/PR
2. **E2E Tests** (`e2e.yml`) - Comprehensive end-to-end testing
3. **Deployment** (`deploy.yml`) - Handles staging deployments
4. **Nightly Tests** (`nightly.yml`) - Cross-browser testing during off-hours
5. **PR Agent** (`pr_agent.yml`) - AI-powered PR reviews

## Workflows

### 1. Continuous Integration (ci.yml)

**Triggers:**

- Push to `main` or `develop` branches
- Pull requests targeting `main` or `develop`

**Jobs:**

- **lint-and-test**: Runs linting, TypeScript checks, unit tests, and builds
- **security-scan**: Performs security audits and dependency checks
- **performance-test**: Runs Lighthouse CI on PRs

### 2. E2E Tests (e2e.yml)

**Triggers:**

- Push to `main` or `develop` branches
- Pull requests targeting `main` or `develop`
- Daily schedule (5:00 PM IST)
- Manual dispatch with environment selection

**Features:**

- Multi-environment support (local, alpha, prod)
- Detailed test result parsing
- Rich Slack notifications with test summaries
- Artifact uploads for debugging

### 3. Deployment (deploy.yml)

**Triggers:**

- Push to `develop` branch
- Manual dispatch with environment selection

**Features:**

- Environment-specific deployments
- Post-deployment smoke tests
- Deployment status notifications

### 4. Nightly Tests (nightly.yml)

**Triggers:**

- Daily schedule (2:00 AM UTC / 7:30 AM IST)
- Manual dispatch with test suite selection

**Features:**

- Cross-browser testing (Chromium, Firefox, WebKit)
- Selective test suite execution
- Comprehensive result summarization

## Slack Notifications

### Setup Requirements

1. **Slack Webhook URL**: Create a webhook in your Slack workspace
2. **GitHub Secrets**: Add the following secrets to your repository:
   - `SLACK_WEBHOOK_URL`: Your Slack webhook URL
   - `TEST_USER_EMAIL`: Test user email for E2E tests
   - `TEST_USER_PASSWORD`: Test user password for E2E tests

### Notification Types

#### 1. E2E Test Results

```json
{
  "text": "Playwright Test Results",
  "blocks": [
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": "✅ Playwright E2E Test Results"
      }
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*Repository:*\nuser/repo"
        },
        {
          "type": "mrkdwn",
          "text": "*Branch:*\nmain"
        }
      ]
    }
  ]
}
```

#### 2. Deployment Notifications

- Status of deployment (success/failure)
- Target environment
- Links to view deployment details

#### 3. Nightly Test Summary

- Cross-browser test results
- Overall pass/fail status
- Detailed statistics

## Environment Configuration

### Environment Variables

| Variable             | Description                           | Required |
| -------------------- | ------------------------------------- | -------- |
| `VITE_STAGE_NAME`    | Target environment (local/alpha/prod) | Yes      |
| `TEST_USER_EMAIL`    | Test user email                       | Yes      |
| `TEST_USER_PASSWORD` | Test user password                    | Yes      |
| `SLACK_WEBHOOK_URL`  | Slack webhook for notifications       | Yes      |

### Supported Environments

- **local**: Development environment
- **alpha**: Staging environment
- **prod**: Production environment

## Manual Triggers

### E2E Tests

```bash
# Trigger via GitHub UI
# Go to Actions > Playwright E2E Tests > Run workflow
# Select environment: alpha/prod/local
```

### Deployment

```bash
# Trigger via GitHub UI
# Go to Actions > Deploy to Staging > Run workflow
# Select environment: alpha/staging
```

### Nightly Tests

```bash
# Trigger via GitHub UI
# Go to Actions > Nightly E2E Tests > Run workflow
# Select environment and test suite
```

## Test Artifacts

All workflows upload test artifacts including:

- Test results (JSON format)
- HTML reports
- Screenshots and videos for failed tests
- Traces for debugging

Artifacts are retained for:

- Regular tests: 7 days
- Nightly tests: 14 days

## Browser Support

The pipeline supports testing across multiple browsers:

- **Chromium**: Primary browser for all tests
- **Firefox**: Included in nightly tests
- **WebKit**: Included in nightly tests
- **Mobile Chrome**: Available via Pixel 5 simulation
- **Mobile Safari**: Available via iPhone 12 simulation

## Troubleshooting

### Common Issues

1. **Tests failing in CI but passing locally**

   - Check environment variables
   - Verify network conditions
   - Review CI-specific timeouts

2. **Slack notifications not working**

   - Verify webhook URL is correct
   - Check GitHub secrets configuration
   - Ensure webhook has proper permissions

3. **Authentication failures**
   - Verify test credentials are valid
   - Check if 2FA is enabled (may need app passwords)
   - Ensure credentials haven't expired

### Debug Steps

1. **Check workflow logs**: Go to Actions tab in GitHub
2. **Download artifacts**: Download test reports and screenshots
3. **Review Slack payload**: Check notification payload in logs
4. **Validate environment**: Ensure correct environment is being tested

## Security Considerations

- **Secrets Management**: All sensitive data stored in GitHub Secrets
- **Token Rotation**: Regularly rotate test credentials
- **Webhook Security**: Use dedicated webhook URLs for CI
- **Audit Logs**: Monitor GitHub Actions usage

## Monitoring and Metrics

### Key Metrics to Track

1. **Test Success Rate**: Percentage of passing tests over time
2. **Test Duration**: Average execution time per test suite
3. **Failure Patterns**: Common failure points and error types
4. **Browser Compatibility**: Cross-browser test results
5. **Environment Stability**: Success rates per environment

### Alerting

- Failed nightly tests trigger immediate Slack notifications
- Deployment failures send alerts with failure details
- Security audit failures are reported in CI notifications

## Maintenance

### Regular Tasks

1. **Update Dependencies**: Monthly updates for Playwright and other deps
2. **Review Test Results**: Weekly analysis of failure patterns
3. **Credential Rotation**: Quarterly update of test credentials
4. **Performance Review**: Monthly analysis of test execution times

### Scaling Considerations

- **Parallel Execution**: Increase workers for faster execution
- **Test Sharding**: Split large test suites across multiple jobs
- **Regional Testing**: Add tests for different geographical regions
- **Load Testing**: Integrate performance testing into the pipeline

## Support

For issues with the CI/CD pipeline:

1. Check this documentation
2. Review GitHub Actions logs
3. Contact the development team
4. Create an issue in the repository
