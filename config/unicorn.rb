APP_PATH = "/var/www/unicorn/current"
UNICORN_ROOT = "/var/www/unicorn/"

working_directory APP_PATH

pid APP_PATH + "/tmp/pids/unicorn.pid"

stderr_path APP_PATH + "/log/unicorn.log"
stdout_path APP_PATH + "/log/unicorn.log"

listen APP_PATH + "/tmp/sockets/unicorn.sock"

worker_processes 4

timeout 600

@resque_pid = nil

before_fork do |server, worker|
  @resque_pid ||= spawn("bundle exec /usr/local/bin/rake " + \
  "resque-pool --environment production start")
end

