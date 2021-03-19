module Transscan::API::Disposition
    class Base < ActiveRecord::Base
      self.table_name = 'vw_dispositon'
    end
end