set :branch, "master"

set :server_name, "archives.osfashland.org"
server 'archives.osfashland.org', user: 'unicorn', roles: %{web app}, primary: true

set :deploy_to, '/var/www/unicorn'
set :rails_env, :production

server 'archives.osfashland.org',
  user: 'unicorn',
  roles: %w{web app},
  ssh_options: {
    user: 'unicorn',
    keys: %w(~/.ssh/apunico01v.pem),
    auth_methods: %w(publickey)
  }
