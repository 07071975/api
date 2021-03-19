class Order < ActiveRecord::Base
  self.table_name = 'orders'
  # has_one :vm_cargoes
end