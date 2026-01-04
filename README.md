## Simple app: “Hit Counter”

A webpage shows a single number: **Visits: 123**
When you refresh the page, the number **increments by 1**.

### What each part does (minimal)

* **S3 + CloudFront**: serve one `index.html`
* **API Gateway**: one endpoint: `POST /hit`
* **Lambda**: increments a counter in DynamoDB and returns the new value
* **DynamoDB**: one table, one item

### DynamoDB (one table, one item)

Table: `Counters`
Primary key: `id` (string)

Item:

* `id = "visits"`
* `value = 123`

### Request flow

1. User opens site (CloudFront → S3).
2. Page calls `POST /hit`.
3. API Gateway triggers Lambda.
4. Lambda does atomic update in DynamoDB: `value = value + 1`.
5. Lambda returns `{ "value": 124 }`.
6. Page displays: **Visits: 124**.
