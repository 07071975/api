require 'transscan'
require 'active_record'
require 'sinatra/activerecord'

require 'rgeo'
require 'rgeo/active_record'
RGeo::ActiveRecord::SpatialFactoryStore.instance.tap do |config|
  config.default = RGeo::Geographic.spherical_factory(srid: 4326)
  config.register(RGeo::Geographic.spherical_factory(srid: 4326), geo_type: "point")
end

Transscan.initialize!

