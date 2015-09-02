set :stage :production
#set :branch, "master"
set :branch, "chore/continuous_deployment"

set :server_name, "www.sufia-dev.osfashland.org sufia-dev.osfashland.org"

server 'www.sufia-dev.osfashland.org', user: 'deploy', roles: %{app}, primary: true

set :deploy_to, '/var/www/unicorn'

set :rails_env, :production

server 'www.sufia-dev.osfashland.org',
  user: 'deploy',
  roles: %w{app},
  ssh_options: {
    user: 'deploy',
    keys: %w(~/.ssh/deploy_rsa)
    auth_methods: %w(publickey)
