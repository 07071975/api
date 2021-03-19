module Transscan::API
  module Builder
    class MapContainer
      attr_reader :container_type
      attr_accessor :request
      attr_reader :base_url

      def initialize(options)
        @container_type = options[:request].entry_name
      end

      def build
        map_container
      end

      def map_container
        @map_container ||= "Transscan::API::MapContainer::#{@container_type.classify}"
                               .constantize
                               .create!(
                                  uuid: '9887789-98987-9899-8967687',
                                  odoo_type: @container_type,
                                  status: 'active',
                                  user_id: '2',
                                  odoo_id: 37,
                                  odoo_query: '[37]',
                                  md5sum: '81cf2f9f23fd597f2e278e56718c3831',
                                  description: '{}',
                                  return_url: 'http://test.com'
                               )
      end
    end
  end
end
