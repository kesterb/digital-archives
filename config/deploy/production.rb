set :stage, 'production'
#set :branch, "master"
set :branch, "chore/continuous_deployment"

set :server_name, "sufia-dev.osfashland.org"
server 'sufia-dev.osfashland.org', user: 'deploy', roles: %{app}, primary: true

set :deploy_to, '/var/www/unicorn'
set :rails_env, :production

server 'sufia-dev.osfashland.org',
  user: 'deploy',
  roles: %w{app},
  ssh_options: {
    user: 'deploy',
    keys: %w(~/.ssh/id_sufia-dev.osfashland.org),
    auth_methods: %w(publickey)
  }
