class State < ActiveRecord::Base
  self.table_name = 'states'
  belongs_to :country
  belongs_to :region, optional: true
end