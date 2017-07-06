[ ] create rds db with terraform script
    // somewhere to put the database
[ ] create vfs with terraform script
    // somewhere to put the website files so the container can be more generic
[ ] create wordpress site with wordpress cli
    // make the creation of a wordpress site something scriptable
[ ] deploy wordpress site to vfs
    // that scriptable wordpress site just needs to be transferred to the vfs we created
[ ] configure container to mount vfs and serve wordpress
    // just hook up the generic container with vfs as /var/www or whatever.
[ ] create ECS cluster with terraform
    // setup aws to host my containers and autoscale as needed
[ ] get my containers running in ECS
    // specifically get MY containers running in that ecs cluster
[ ] create route53 configuration to make container a public site
    // with everything working, just get it hooked up to DNS entries.

