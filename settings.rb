configure do
  set :method_override, true # For HTTP verbs
  set :logging, false # stops annoying double log messages.
  set :static, false # see config.ru for dev mode static file serving
  set :asset_timestamps, false # true for ?9879879 asset stamps
end

configure :development do
  set :asset_timestamps, true
  set :raise_errors, true
  set :show_exceptions, true
  set :haml, {:format => :html5, :ugly => false, :escape_html => true}
end

configure :production do
  set :raise_errors, false
  set :show_exceptions, false
  set :haml, {:format => :html5, :ugly => true, :escape_html => true}
end


# Rack configuration
# Serve static files in dev
if settings.development?
  use Rack::Static, :urls => ['/css', '/img', '/js', '/less', '/robots.txt', '/favicons.ico'], :root => "public"
end

# Authentication middleware
# https://github.com/hassox/warden/wiki/overview
use Warden::Manager do |mgmt|
  mgmt.default_strategies :password
  mgmt.failure_app = Sinatra::Application
end

use Rack::Session::Cookie, :key => 'rabble.session',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'change_me_in_production'

