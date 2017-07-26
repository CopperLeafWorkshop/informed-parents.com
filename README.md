The Docker setup for PHP applications using PHP7-FPM and Nginx described in http://geekyplatypus.com/dockerise-your-php-application-with-nginx-and-php7-fpm

## Instructions
1. Checkout the repository
* Run `docker-compose up`
* Navigate to localhost:8080

That's it! You have your local PHP setup using Docker

*Example of activated PHP logging* - https://github.com/mikechernev/dockerised-php/tree/feature/log-to-stdout

--------------------------------
## Project Setup Instructions
1. Start up linux machine (ubuntu vm works.)
Install:
 - git (to get this repo.) (requires github credentials)
 - docker (for nginx,php containers)
 - terraform (for aws infrastructure creation) (requires aws credentials)
 - graphviz (for generating graphs of terraform infrastructure)
 - aws cli (for aws infrastructure testing)
 - dropbox (for project documentation) (requires dropbox credentials)
 - php : apt install php (for the wordpress-cli)
 - wordpress-cli (for wordpress automation)
 - python v3 : apt install python3-pip
 - container-transform : pip3 install container-transform  
n. follow the todo list. 
