# AWS Cloud Resume Challenge

This is my attempt at cloud resume challenge in AWS.
What is Cloud Resume Challenge? - [The Cloud Resume Challenge](https://cloudresumechallenge.dev/) is a multiple-step resume project which helps build and demonstrate skills fundamental to pursuing a career in Cloud. The project was published by Forrest Brazeal.

## Architecture

![Architecture Diagram](https://res.cloudinary.com/practicaldev/image/fetch/s--UpzQqewd--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/i/nruhanmhgxtxzpi5cbfz.png)

**Services Used**:

- AWS S3 buckets
- AWS CloudFront
- AWS APIGateway
- ACM
- AWS Lambda
- AWS DynamoDB
- AWS route53
- GitHub Actions
- Terraform
- Playwright

**Note**: Backend management in terraform can be commented out when provisioning through terraform locally. but must be enabled when using it in a pipeline. the statefiles are stored in dynamodb and s3 bucket. 