# frozen_string_literal: true

worker_processes ENV['RAILS_ENV'] == 'development' ? 1 : 4

root = '/var/apps/{{APPNAME}}/current'

listen File.expand_path('tmp/sockets/unicorn.sock')
pid File.expand_path('tmp/pids/unicorn.pid')

stderr_path File.expand_path('log/unicorn.log')
stdout_path File.expand_path('log/unicorn.log')

preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

before_exec do |_|
  ENV["BUNDLE_GEMFILE"] = File.join(root, 'Gemfile')
end
