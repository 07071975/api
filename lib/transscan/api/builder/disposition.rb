module Transscan::API
  module Builder
    class Disposition

      def initialize(param)
        @param = param
      end

      def build
        case @param['REQUEST_PATH']
        when /disposition\/load/
          @model = ::Transscan::API::Disposition::Load.new()
        else
          sleep 11
        end

      end
    end
  end
end
