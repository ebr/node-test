#  INSTRUCTIONS 
#  Copy this file to deploy.rb and replace the following variables with your own
#  Do not commit deploy.rb!!!

#set the git repository
set :repository, GIT_REPOSITORY_SSH_ADDRESS

#set ssh user ( usually ubuntu)
set :user, SSH_USER

#bypass password as we use keys
set :ssh_options, {:forward_agent => true}

#SSH Key Local File Path
ssh_options[:keys] = [PEM_KEY_FILE_PATH]

#aws keys - each user should have these in their EC2 IAM settings
set :aws_access_key_id, AWS_ACCESS_KEY
set :aws_secret_access_key, AWS_SECRET_KEY



######################################################
# DO NOT MODIFY BELOW THIS LINE 
######################################################

# Is sudo required to manipulate files on the remote server?
set :use_sudo, false

# Ignore any local files?
set :copy_exclude, %w(.git)

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

#############################################################
# Stages
#############################################################
set :stages, %w(production development)
set :stage_dir, "deployments/deploy"
set :default_stage, "development" #if we only do “cap deploy” this will be the stage used.
require 'capistrano/ext/multistage' #yes. First we set and then we require.


# Remove older realeases. By default, it will remove all older then the 5th.
after :deploy, 'deploy:cleanup'
# Run the Grunt task
after "deploy:cleanup","custom:grunt"
# set permissions on the wordpress uploads folder
after "custom:grunt","custom:perms"

#############################################################
# Get instances from ec2 loadbalancer
#############################################################

def fetch_from_ec2_loadbalancer
    instances_for_deploy = []
    loadbalancer lb_webserver, :web
    instances_for_deploy
end