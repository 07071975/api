class OrderSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :order_number, :order_type, :order_state, :customer_id
end