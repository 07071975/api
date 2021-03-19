class Country < ActiveRecord::Base
  self.table_name = 'countries'
  has_many :states
  has_many :regions
end