source "http://rubygems.org"

# the AR library
gem 'activerecord'

# the adapter between Sinatra and AR
gem 'sinatra-activerecord'

# # our db
# gem 'sqlite3'

# a command line task runner (more on this later)
gem 'rake'

# make things flashy
gem 'sinatra-flash'


# Don't forget to `bundle install`

# For Heroku
group :development do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
