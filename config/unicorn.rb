
# Spec's
#   http://sirupsen.com/setting-up-unicorn-with-nginx/
#   http://sleekd.com/general/configuring-nginx-and-unicorn/
#   https://gist.github.com/206253
#   https://gist.github.com/410309

# nginx example:
#   https://github.com/defunkt/unicorn/blob/master/examples/nginx.conf
#   http://unicorn.bogomips.org/examples/nginx.conf


# Run: cd /project/; bundle exec unicorn_rails -c config/unicorn.rb -E production -D

rails_env = ENV['RAILS_ENV'] || 'production'


# http://unicorn.bogomips.org/examples/unicorn.conf.minimal.rb
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.

if rails_env=='production'
  worker_processes 4

  APP_PATH = '/home/wwwdata/chebytoday.ru/'
  listen APP_PATH + "shared/tmp/unicorn.sock", :backlog => 64
  # listen "/tmp/.sock", :backlog => 64
  # listen '/data/github/current/tmp/sockets/unicorn.sock', :backlog => 2048

  working_directory APP_PATH + "current"
  pid APP_PATH + "shared/pids/unicorn.pid"
  stderr_path APP_PATH + "shared/log/unicorn.stderr.log"
  stdout_path APP_PATH + "shared/log/unicorn.stdout.log"
else
  listen 8080, :tcp_nopush => true
end

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# combine REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  # The following is only recommended for memory/DB-constrained
  # installations.  It is not needed if your system can house
  # twice as many worker_processes as you have configured.
  #
  # # This allows a new master process to incrementally
  # # phase out the old master process with SIGTTOU to avoid a
  # # thundering herd (especially in the "preload_app false" case)
  # # when doing a transparent upgrade.  The last worker spawned
  # # will then kill off the old master process with a SIGQUIT.
  # old_pid = "#{server.config[:pid]}.oldbin"
  # if old_pid != server.pid
  #   begin
  #     sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
  #     Process.kill(sig, File.read(old_pid).to_i)
  #   rescue Errno::ENOENT, Errno::ESRCH
  #   end
  # end
  #
  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  # sleep 1
end

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end
