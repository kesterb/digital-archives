namespace :service do
  task :restart_unicorn do
    on "#{fetch(:deploy_user)}@#{fetch(:server_name)}" do
      as 'unicorn' do
        execute "cat /var/www/unicorn/tmp/pids/unicorn.pid | xargs kill -SIGHUP"
      end
    end
  end
end
