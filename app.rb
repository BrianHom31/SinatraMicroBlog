# ruby index.rb
# localhost:4567

require 'sinatra'
require 'sinatra/activerecord'
require './models'

# flash stuff
require 'bundler/setup'
require 'sinatra/flash'
enable :sessions

## SET DATABASE---INPUT HERE

set :sessions, true
