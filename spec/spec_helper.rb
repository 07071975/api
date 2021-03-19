ENV['RACK_ENV'] = 'test'
ENV['ENV'] = 'test'

$:.unshift File.expand_path("../lib", File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
Bundler.setup :default, :test

require 'rspec'
require 'transscan/environment'
require 'transscan/json_serializer'

RSpec.configure do |config|
  config.include Transscan::JSONSerializer
end