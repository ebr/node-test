#  INSTRUCTIONS 
#  Copy this file to deploy.rb and replace the following variables with your own
#  Do not commit deploy.rb!!!

#set the git repository
set :repository, "git@github.com:ebr/sails.test.git"

#set ssh user ( usually ubuntu)
set :user, "ubuntu"

#bypass password as we use keys
set :ssh_options, {:forward_agent => true}

#SSH Key Local File Path
ssh_options[:keys] = "~/.ssh/id_rsa"

#aws keys - each user should have these in their EC2 IAM settings
#set :aws_access_key_id, AWS_ACCESS_KEY
#set :aws_secret_access_key, AWS_SECRET_KEY



######################################################
# DO NOT MODIFY BELOW THIS LINE 
######################################################

# Is sudo required to manipulate files on the remote server?
set :use_sudo, false

# Ignore any local files?
set :copy_exclude, %w(.git deployments README.md .gitignore)

######################################################
# Git
######################################################

# What version control solution does the project use?
set :scm, :git

# How are the project files being transferred to the remote server?
set :deploy_via, :remote_cache

# Maintain a local repository cache. Speeds up the copy process.
set :copy_cache, true


#############################################################
# Tasks
#############################################################

namespace :custom do  
  desc "Run a task to install tmp directories for caching"  
  task :grunt do
    run("cd /var/www/#{application}/current/ && grunt")  
  end

  task :perms do
 	desc "Adjust permissions on the wordpress uploads folder"
 	run("sudo chown -R www-data /var/www/#{application}/current/wordpress/wp-content/uploads")
  	run("sudo chmod -R g+w /var/www/#{application}/current/wordpress/wp-content/uploads")
  end
end

namespace :post do
  task :kick
    desc "restart the application daemon"
    run("sudo restart sails.test")
  end
end


#############################################################
# Stages
#############################################################
set :stages, %w(development)
set :stage_dir, "environments"
set :default_stage, "development" #if we only do “cap deploy” this will be the stage used.
require 'capistrano/ext/multistage' #yes. First we set and then we require.


# Remove older realeases. By default, it will remove all older then the 5th.
after :deploy, 'deploy:cleanup'
after :deploy:cleanup, :post:kick

#############################################################
# Get instances from ec2 loadbalancer
#############################################################

def fetch_from_ec2_loadbalancer
    instances_for_deploy = []
    loadbalancer lb_webserver, :web
    instances_for_deploy
end