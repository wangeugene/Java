#Object storage

## S3 Storage

Distributed across at least three Availability Zones; Except 1A(1 zone, least expensive)
Supports encryption & automatic data classification
Can do big data analytics

### Getting Data into S3

API;Amazon Direct Connect; Storage Gateway; Kinesis Firehouse; Transfer Acceleration;
Think of S3 buckets like drives on your local computer
Files are objects in S3 buckets
An S3 API is based on REST (Representational State Transfer), which uses HTTP methods
S3 Object has key, no folder, its replicas will eventually be consistent
Can access using URL
Can create 100 buckets by default
FQDN = fully qualified domain name to be used by bucket.
Bucket name is universally unique.
Bucket supports Tags (up to 10 tags) & Versioning & Logging & MFA deletion & Range Get
Encrypted on the server side by default (AES-256).
Ideal to serve static web content.
Use AWS web console to create S3 bucket.
After creating a bucket, you can upload files like any other cloud-based storage solution.
Objects can be configured with security parameters to control access.
Metadata is used to define the purpose of the object.
Tags are used to search, organize, and manage access.
Storage class defines the performance
A manifest is a list of S3 objects, may be .csv file format.
S3 object lock supports write-once-read-many (WORM) as a file storage method.
Batch operations create jobs to enable automatic actions.
Use lifecycle rules to implement intelligent tier

### Glacier

Archival purpose
Expedited access 3–5 minutes
Standard access 3–5 hours
Bulk access 5–12 hours

A single AWS account can create up to 1000 vaults per-region
Only empty vaults can be deleted
Glacier supports multipart uploads of archives so a large archive is not required to be uploaded in a single region

### EBS

Elastic Block Store(EBS) is used for persistent(durable) storage with EC2 instances.
EBS can also be used for block-level storage from one AWS service to another.
EBS volume types include magnetic and SSD.
SSD volumes can be general purpose or provisioned
EBS volumes can be attached to any EC2 instance in the same Availability Zone (AZ).
EBS volumes can be created and attached during the creation of an EC2 instance.
Use the AWS Console to create EBS volumes directly by selecting ELASTIC BLOCK STORE, Volumes.
EBS is bound to an instance

### EFS

Elastic File System is free to access any instance.
It is shareable (Multiple instances can access this service)
It is like NAS storage within the cloud for the cloud
Can be accessed through the NFSv4 protocol
EFS is not supported on Windows instances.
Create EFS shares using the Amazon Elastic File System console in AWS.
EFS shares can be limited to a Virtual Private Cloud (VPC).
Like other AWS services, EFS shares can be tagged for better management and location.

### PrivateLink

Endpoints are created within your Virtual Private Cloud (VPC).
PrivateLink allows for secure connection between VPCs, Services, and applications in AWS.