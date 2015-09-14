# config valid only for current version of Capistrano
lock '3.4.0'

set :application, "digital-archives"
set :deploy_user, "unicorn"
set :pty, true
set :scm, :git
set :repo_url, "git@github.com:OregonShakespeareFestival/digital-archives.git"

set :deploy_to, "/var/www/unicorn"

set :keep_releases, 5
set :tests, []
set :bundle_flags, " --quiet"

namespace :deploy do
  after :finishing, "deploy:cleanup"

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        run "cat REVISION > public/assets/version.html"
      end
    end
  end

end
