# Questions

- Resume
    - Yes or no apply to places that ask for Azure exp instead of AWS

TODO: Remove all glob - change into s3 client boto3
TODO: Metadata handling

Aside:
Docker hub rate limits anonymous users, so building occasionally
fails because we can't pull the base image, continuumio/miniconda3
If access to the base image continues to be a problem we should
just mirror it on ECS.

Key points:
- end-to-end data analytics pipeline
- ingests data from S3
- does processing
- exports images and PostgresDB to S3
- Utilized AWS ECR
  (Amazon is serious about saying Amazon/AWS depending on what the specific webpage has)
- White text of empty space w/ all the jargon terms
- CodeBuild because budget, on-demand, manual execution
- Could have done a regular container, but that's not the use case
- Amazon solution architecting: what to use when
- Optimize for cost, speed, code availability, etc.
- Write a little narrative to remind yourself how to explain it
- "Last week in AWS" podcast Cory Quinn (sp?)
- Concepts are transferrable, details aren't.
- Emphasize that I took a local analysis and put it into the cloud, which makes it very transferrable.

Good training:
AWS practitioner training
- Focuses on use cases for different services
- Not on how to do it, but what the use case (esp. cost) 
Solutions architect associate course
- Comes with a certificate
- Lasts two years, and is good because it requires you to stay on top of the very-fast-changing information.
- Have to go through a training provider (AWS does not have an in-house training)
- CloudGuru focuses on passing the test
Make own account for free tier etc
- Change password, add MFA, add billing alert

Command for updating the stack.
aws cloudformation update-stack --stack-name nitelite-pipeline --template-body file://aws/nitelite-pipeline-stack.yml --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM