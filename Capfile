# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

require 'capistrano/secrets_yml'
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/foreman'
require 'capistrano/rbenv'
require 'capistrano/puma'
require 'capistrano/puma/nginx'
require 'rollbar/capistrano3'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
