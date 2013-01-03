configure do
  set :method_override, true # For HTTP verbs
  set :sessions, true
  set :logging, false # stops annoying double log messages.
  set :static, false # see config.ru for dev mode static file serving
  set :asset_timestamps, true
  set :redis, 1 # redis database
end

configure :development do
  set :raise_errors, true
  set :show_exceptions, true
end

configure :production do
  set :raise_errors, false
  set :show_exceptions, false
end


use Rack::Session::Cookie, :key => 'rabble.session',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'change_me_in_production'