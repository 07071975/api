$:.unshift File.expand_path("lib", File.dirname(__FILE__))

require 'rubygems'
Bundler.setup :default
require 'bundler'

require 'rack/contrib'
require 'transscan/environment'
require 'sidekiq/web'

run Rack::URLMap.new({
                         "/"            => Transscan::App,
                         "/sidekiq"     => Sidekiq::Web
                     })
