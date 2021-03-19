class VmCargoesSerializer #< ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer
  set_type :cargoes
  set_id :serialize_id

  attributes :id, :order_id, :order_number, :cargo_name,
             :customer_name, :customer_id, :node_fullalias,
             :current_resources, :unload_resources

  link(:self) { |object|  "/api/v1/x/#{object.id}" }

  belongs_to :order, links: {
      self: -> (object) {
        "http://v1/order/#{object.id}"
      },
      related: -> (object) {
        "v1/order/#{object.id}"
      }
  }

end
