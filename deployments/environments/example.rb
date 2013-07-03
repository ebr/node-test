#############################################################
# Servers
#############################################################

# set the remote directory name ( assumed in /var/www/ see :deploy_to)
set :application, SITE.DOMAIN.COM

# EXAMPLE LOAD BALANCED What is the url of the server / load balancer?
set :lb_webserver, LOAD_BALANCER_NAME

role :web do
	ENV['TARGET'] || fetch_from_ec2_loadbalancer
end

#EXAMPLE SINGLE SERVER ( STAGING AND DEVELOPMENT ENVIRONMENTS)
#server 'staging.server.com', :app, :web, :primary => true

# What is the directory path used to store your project on the remote server?
set :deploy_to, "/var/www/#{application}"

# What is the branch in your Git repository that will be deployed to the development server?
set :branch, BRANCH_NAME