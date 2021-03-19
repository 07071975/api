class VmCargoes < ActiveRecord::Base
  self.table_name = 'vm_cargoes'
  self.primary_key = :id

  belongs_to :order, class_name: "Order", foreign_key: :order_id

  def readonly?
    true
  end

  def self.refresh
    ActiveRecord::Base.connection.execute('REFRESH MATERIALIZED VIEW vm_cargoes')
  end

  def serialize_id
    "#{SecureRandom.uuid}-#{self.id}"
  end
end