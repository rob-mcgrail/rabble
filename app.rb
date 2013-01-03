require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)
Bundler.require(:dev) if settings.development?
Bundler.require(:production) if settings.production?

require './settings'

Dir['./modules/*.rb'].each {|file| require file }

require './app/redis.rb'
require './app/death_clock.rb'
require './app/session.rb'
require './app/rabble.rb'


Dir['./app/_*.rb'].each {|file| require file }
