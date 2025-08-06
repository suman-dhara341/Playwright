// sendMetric.js
import AWS from "aws-sdk";

// Auto picks up CodeBuild IAM role
AWS.config.update({ region: "us-east-1" });

const cloudwatch = new AWS.CloudWatch();

export const sendMetric = async ({ name, value, unit = "Count" }) => {
  const params = {
    Namespace: "Playwright/CodeBuild",
    MetricData: [
      {
        MetricName: name,
        Value: value,
        Unit: unit,
        Dimensions: [{ Name: "Environment", Value: "CodeBuild" }],
      },
    ],
  };

  await cloudwatch.putMetricData(params).promise();
};
