require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)
Bundler.require(:dev) if settings.development?
Bundler.require(:production) if settings.production?

require './settings'

Dir['./modules/*.rb'].each {|file| require file }

require './app/redis'
require './app/death_clock'
require './app/harvester'
require './app/rabble'

Dir['./app/_*.rb'].each {|file| require file }
