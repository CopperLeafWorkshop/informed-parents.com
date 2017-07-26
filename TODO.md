[x] create rds db with terraform script
    // somewhere to put the database
[x] store tfstate in s3
    //somewhere central to store the tfstate
[x] create wordpress site with wordpress cli
    // make the creation of a wordpress site something scriptable
    // wordpress/build.sh creates the basics of the site
[x] create wordpress db with a script
    // create the wordpress db on rds 
[x] configure container to serve wordpress
    // just hook up the generic container with efs as /var/www or whatever.

[x] create pre-req's for ecs cluster
  - Following instructions here: http://docs.aws.amazon.com/AmazonECS/latest/developerguide/
  - create keypair - for ec2 instance 
  - create iam role - for containers to use to connect to ec2 and ecs services
  - create security group - for containers to use 
 

[x] create ECS cluster with terraform
  [x] create ec2 instance based on aws-container-ami optimized for my region
    -ff15039b
  [x] create ecs cluster - to define what ec2 instances are available
  [x] crete ecs task - to define what to run on the cluster
  [x] schedule the task - to always be runnin 

[] package wp into the wp container, and test locally it works
[] package the site.config into the nginx container, and an index.html, and test locally it works
[] publish those containers to ecr
[] test those containers in ecs

[ ] setup cloudflare dns,cdn

