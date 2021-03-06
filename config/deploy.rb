# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'picpic'
set :repo_url, 'git@github.com:mroach/picpic.git'
set :user, :deploy
set :keep_releases, 10

set :use_sudo,    false
set :deploy_to,   "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :deploy_via,  :remote_cache
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }

set :puma_threads,    [4, 16]
set :puma_workers,    0
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

set :rbenv_type,     :user
set :rbenv_ruby,     File.read('.ruby-version').strip
set :rbenv_prefix,   "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles,    :all # default value

secrets = YAML.load(File.read('config/secrets.yml'))[fetch(:rails_env, fetch(:stage)).to_s]
set :rollbar_token, secrets['rollbar']
set :rollbar_env,   Proc.new { fetch :stage }
set :rollbar_role,  Proc.new { :app }

set :foreman_use_sudo, false # Set to :rbenv for rbenv sudo, :rvm for rvmsudo or true for normal sudo
set :foreman_roles, :all
set :foreman_template, 'upstart'
set :foreman_export_path, ->{ File.join(Dir.home, '.init') }
set :foreman_options, ->{ {
  app: fetch(:application),
  log: File.join(shared_path, 'log')
} }

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default value for :format is :airbrussh.
set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'db/production.sqlite3')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads')

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
