- [x] create rds db with terraform script  
  *somewhere to put the database*
- [x] store tfstate in s3  
  *somewhere central to store the tfstate*
- [x] create wordpress site with wordpress cli  
  *make the creation of a wordpress site something scriptable
  wordpress/build.sh creates the basics of the site*
- [x] create wordpress db with a script  
  *create the wordpress db on rds* 
- [x] configure container to serve wordpress  
  *just hook up the generic nginx+php containers with wordpress site mounted at /var/www/
- [ ] create efs with terraform script  
  *somewhere to put the website files so the container can be more generic*
- [ ] deploy wordpress site to efs  
  *that scriptable wordpress site just needs to be transferred to the efs we created*
- [ ] configure container to mount efs and serve wordpress  
  *just hook up the generic container with efs as /var/www or whatever.*
- [ ] create ECS cluster with terraform  
  *setup aws to host my containers and autoscale as needed*
- [ ] get my containers running in ECS  
  *specifically get MY containers running in that ecs cluster*
- [ ] create route53 configuration to make container a public site  
  *with everything working, just get it hooked up to DNS entries.*

