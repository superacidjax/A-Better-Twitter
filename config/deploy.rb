# Capistrano Multistage Support
# Uncomment the following lines if you'd like Multistage Capistrano support.
# set :default_stage, "staging"
# set :stages, %w(production staging)
# require 'capistrano/ext/multistage'

# Include Bundler Extensions
# Comment out the following line if you're not using Bundler.
require "bundler/capistrano"

# Precompile Assets when deploying.
load 'deploy/assets'

# RVM Settings
# Use either the latest RVM settings, or the legacy settings depending on your local RVM version.
# Must have latest version of RVM as of 12/8/2010 to make this work properly.
require "rvm/capistrano"
set :rvm_ruby_string, "ruby-1.9.3-p194"
set :rvm_type, :system

# Server Settings
# Comment this out if you're using Multistage support.
set :user, "deploy"
set :server_name, "vs608676.blueboxgrid.com"
role :app, server_name
role :web, server_name
role :db,  server_name, :primary => true

# Application Settings
set :application, "A-Better-Twitter"
set :deploy_to, "/home/deploy/rails_apps/#{application}"

# Repo Settings
set :repository,  "git@github.com:superacidjax/A-Better-Twitter.git"
set :scm, "git"
set :checkout, 'export'
set :copy_exclude, ".git/*"
set :deploy_via, :remote_cache

# General Settings
default_run_options[:pty] = true
set :keep_releases, 5
set :use_sudo, false
ssh_options[:forward_agent] = true

# Hooks
after "deploy", "deploy:cleanup"
after "deploy:update_code", "deploy:web:update_maintenance_page"
after "deploy:update_code", "deploy:secondary_symlink"

namespace :deploy do
  task :secondary_symlink, :except => { :no_release => true } do
    run "rm -f #{release_path}/config/database.yml"
    run "ln -s #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end

  task :restart, :except => { :no_release => true } do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end

  task :start, :except => { :no_release => true } do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end
end

# Disable the built in disable command and setup some intelligence so we can have images.
disable_path = "#{shared_path}/system/maintenance/"
namespace :deploy do
  namespace :web do
    desc "Disables the website by putting the maintenance files live."
    task :disable, :except => { :no_release => true } do
      on_rollback { run "mv #{disable_path}index.html #{disable_path}index.disabled.html" }
      run "mv #{disable_path}index.disabled.html #{disable_path}index.html"
    end

    desc "Enables the website by disabling the maintenance files."
    task :enable, :except => { :no_release => true } do
        run "mv #{disable_path}index.html #{disable_path}index.disabled.html"
    end

    desc "Copies your maintenance from public/maintenance to shared/system/maintenance."
    task :update_maintenance_page, :except => { :no_release => true } do
      run "rm -rf #{shared_path}/system/maintenance/; true"
      run "mkdir -p #{release_path}/public/maintenance"
      run "touch #{release_path}/public/maintenance/index.html.disabled"
      run "cp -r #{release_path}/public/maintenance #{shared_path}/system/"
    end
  end
end
