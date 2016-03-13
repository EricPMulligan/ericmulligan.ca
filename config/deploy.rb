# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'ericmulligan'
set :repo_url, 'git@github.com:EricPMulligan/ericmulligan.ca.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/ericmulligan/www'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :error

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

# Number of delayed_job workers
# default value: 1
# set :delayed_job_workers, 2

# String to be prefixed to worker process names
# This feature allows a prefix name to be placed in front of the process.
# For example:  reports/delayed_job.0  instead of just delayed_job.0
set :delayed_job_prefix, :reports

# Delayed_job queue or queues
# Set the --queue or --queues option to work from a particular queue.
# default value: nil
set :delayed_job_queues, ['mailer']

# Specify different pools
# You can use this option multiple times to start different numbers of workers for different queues.
# default value: nil
set :delayed_job_pools, {
  :mailer => 2,
  :* => 2
}

# Set the roles where the delayed_job process should be started
# default value: :app
# set :delayed_job_roles, [:app, :background]

# Set the location of the delayed_job executable
# Can be relative to the release_path or absolute
# default value 'bin'
# set :delayed_job_bin_path, 'script' # for rails 3.x

### Set the location of the delayed_job logfile
# set :delayed_log_dir, 'path_to_logfile'

### Set the location of the delayed_job pid file
set :delayed_job_pid_dir, '/tmp'

set :nginx_sites_available_path, '/etc/nginx/sites-available'
set :nginx_sites_enabled_path, '/etc/nginx/sites-enabled'
set :puma_nginx, :app

set :puma_user, fetch(:user)
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_default_control_app, "unix://#{shared_path}/tmp/sockets/pumactl.sock"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 16]
set :puma_workers, 1
set :puma_worker_timeout, nil
set :puma_init_active_record, false
set :puma_preload_app, true
set :nginx_use_ssl, false

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
