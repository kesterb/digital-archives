namespace :service do
  task :restart_unicorn do
    on "#{fetch(:deploy_user)}@#{fetch(:server_name)}" do
      execute :sudo, "/usr/bin/systemctl restart unicorn"
    end
  end
end
