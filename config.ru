require 'bundler'

Bundler.setup(:default)

require './app'


if settings.development?
  use Rack::Static, :urls => ['/css', '/fonts', '/img', '/js', '/robots.txt', '/favicon.ico'], :root => "public"
end


run Sinatra::Application
