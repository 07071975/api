module Transscan::API::MapContainer
  class Base < ActiveRecord::Base
    self.table_name = 'map_container_histories'
  end
end