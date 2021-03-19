require 'active_model_serializers'
require 'fast_jsonapi'

module Transscan::JSONSerializer
  extend self

  def json(name, object, options = {})
    begin
      serializer = Object.const_get("#{name.to_s.camelize}Serializer")

      attrs = serializer.new(object, options).serializable_hash
      attrs = {options[:root] => attrs} if options[:root]
      attrs.to_json
    rescue  => e
      Transscan.logger.error("Can't run #{name} serializer for #{object.class.name}. Error: #{e}")
      Transscan.logger.error(e.backtrace.join("\n"))
      raise "Can't run #{name} serializer for #{object.class.name}. Error: #{e}"
    end
  end
end

require 'serializers/story_serializer'
require 'serializers/disposition/vm_cargoes_serializer'
require 'serializers/order_serializer'