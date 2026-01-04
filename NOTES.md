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

Two common forms:

* **Push model**: the service calls Lambda directly (e.g., S3 events, API Gateway, EventBridge)
* **Poll model**: Lambda polls a queue/stream via an event source mapping (e.g., SQS, Kinesis, DynamoDB Streams)

In short: **a trigger is the connection that makes events run your Lambda.**

---

## Bucket Policy vs IAM Policy

Both are policies, but they attach in different places and answer different questions.

### IAM Policy (identity-based policy)

* **Attached to**: IAM user / group / role
* Controls: what that identity can do in AWS
* Usually used for: granting a role access to many services/resources

**Definition:** an identity-based policy grants/denies permissions to the identity it is attached to.

### Bucket Policy (resource-based policy for S3)

* **Attached to**: an S3 bucket
* Controls: who can access that bucket and how
* Often used for: cross-account access, public access control, enforcing conditions (TLS-only, specific VPC endpoint, etc.)

**Definition:** a bucket policy is a resource-based policy that grants/denies permissions on the bucket (and optionally objects) to specified principals.

### Precise difference

* IAM policy: **attached to an identity** → “what can *this role/user* do?”
* Bucket policy: **attached to a resource** → “who can access *this bucket*?”
* Bucket policy can name **external principals** (other accounts, anonymous `*`), making it a common tool for **cross-account S3 access**.

---

If you want, I can add a **one-screen example** showing:
“Role A can read `my-bucket/photos/*`” using (1) IAM policy only vs (2) bucket policy + role.
