# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'digital-archives'
set :deploy_user, 'unicorn'

set :scm, :git
set :repo_url, 'git@github.com:OregonShakespeareFestival/digital-archives.git'

set :deploy_to, '/var/www/unicorn'

#TODO: setup git ??

set :keep_releases, 5

set :tests, []


# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }


namespace :deploy do
  before :deploy, "deploy:check_revision"
  after :finishing, "deploy:cleanup"

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
