class Region < ActiveRecord::Base
  self.table_name = 'regions'
  has_many :states
  belongs_to :country
end