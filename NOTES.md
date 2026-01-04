# Notes beginner friendly 

## IAM Role

An **IAM Role** is an AWS identity that:

* has a set of permissions (via policies),
* is meant to be **assumed** by a trusted principal (user, service, or another account) to get **temporary credentials**.

Simple mental model

Role = a job title (can exist forever)

Assume role = borrow a badge

A role can have 0 or more policies to grant or denay permissions

---

## Policy (IAM Policy)

A **policy** is a JSON permissions document that defines:

* **Effect**: Allow or Deny
* **Action**: what API operations are allowed/denied (e.g., `s3:GetObject`)
* **Resource**: which AWS resources it applies to (e.g., a bucket or object ARN)
* **Condition** (optional): extra rules (e.g., only from a certain IP, only using TLS)

In short: **a policy is the rules that grant/deny permissions.**

#### Examples

**API Gateway route (e.g., GET /users) → invokes Lambda**

Lambda must allow API Gateway to invoke it (Lambda permission: lambda:InvokeFunction for principal apigateway.amazonaws.com).

* **Lambda reads a file from S3**

  * Lambda role allows `s3:GetObject` on `arn:aws:s3:::bucket-name/*`

* **Lambda writes a processed file back to S3**

  * Lambda role allows `s3:PutObject` on `arn:aws:s3:::bucket-name/*`

* **Lambda moves files in S3**

  * Lambda role allows `s3:GetObject`, `s3:PutObject`, `s3:DeleteObject` on `arn:aws:s3:::bucket-name/*`

  * `s3:DeleteObject` on `arn:aws:s3:::my-bucket/*`

## Serverless

## Serverless (beginner-friendly)

**Serverless** means **you don’t start or stop servers** — **AWS runs and manages them for you**.

* You **don't stop or start the server**
* You **don’t install or upgrade the OS**
* You **don’t patch security updates**
* You **don’t manage scaling** (more traffic → AWS scales automatically)
* You just **deploy your code** (or use a managed service), configure it, and use it

**Pricing:** you usually pay only for what you use:

* per request
* per execution time
* or per memory used
* per data processed
* per data stored

  (not for an always-running server)

**In short:** *AWS handles servers and maintenance; you focus on code and pay for consumption.*

* **Lambda:** charged mainly for **number of invocations** and **execution time** (duration + memory).
* **S3:** charged mainly for **storage (GB-month)** and **requests** (PUT/GET/LIST).
* **API Gateway:** charged mainly per **API call/request** (and data transfer).
* **CloudFront:** charged mainly for **data transferred to users** and **number of requests**.
* **DynamoDB:** charged mainly for **read/write capacity used** (or on-demand reads/writes) and **storage**.

---

## Lambda Trigger

A **Lambda trigger** is an **event source mapping or integration** that causes AWS to invoke a Lambda function when an event occurs.

Two common forms of triggers

* **Push model**: the service calls Lambda directly (e.g., S3 events, API Gateway, EventBridge)
* **Poll model**: Lambda polls a queue/stream via an event source mapping (e.g., SQS, Kinesis, DynamoDB Streams)
