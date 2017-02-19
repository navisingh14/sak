set :stage, :local

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :boiler_plate, %w{navyug@localhost}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server 'localhost', user: 'navyug', password: 'new life', roles: :all

set :user_home, '/home/navyug'
set :source_profile, "source #{fetch(:user_home)}/.bash_profile"
set :app_name, "boiler_plate"
set :deploy_to, "#{fetch(:user_home)}/#{fetch(:app_name)}"
set :backend_dir, "#{fetch(:deploy_to)}/current/backend"
set :backend_port, '3000'
set :branch, 'develop'
set :repo_url, 'git@192.168.3.10:root/rails-ember-boilerplate.git'

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

# fetch(:default_env).merge!(rails_env: :staging)