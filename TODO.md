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
 

[/] create ECS cluster with terraform
  [x] create ec2 instance based on aws-container-ami optimized for my region
    -ff15039b
  [x] create ecs cluster - to define what ec2 instances are available
  [ ] crete ecs task - to define what to run on the cluster
  [ ] schedule the task - to always be runnin 

[ ] get my containers running in ECS
    // specifically get MY containers running in that ecs cluster

[ ] setup cloudflare dns,cdn

[ ] create efs with terraform script
    // somewhere to put the website files so the container can be more generic
[ ] deploy wordpress wp-content to efs
    // that scriptable wordpress site just needs to be transferred to the efs we created
[ ] configure container to mount efs and serve wordpress
    // just hook up the generic container with efs as /var/www or whatever.
