#############################################################
# Servers
#############################################################

# set the remote directory name ( assumed in /var/www/ see :deploy_to)
set :application, "sails.test"

# What is the url of the server / load balancer?
set :lb_webserver, "107.21.180.217"

role :web do
	ENV['TARGET'] || "107.21.180.217"
end

# What is the directory path used to store your project on the remote server?
set :deploy_to, "/var/www/#{application}"

# What is the branch in your Git repository that will be deployed to the development server?
set :branch, 'master'
