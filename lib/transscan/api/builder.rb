module Transscan::API
  module Builder
    T_TYPES = %i(Disposition MapContainer).freeze

    T_TYPES.each do |t_type|
      autoload(t_type, "transscan/api/builder/#{t_type.to_s.underscore}")
    end

    def self.build(options)
      "Transscan::API::Builder::#{options.fetch(:t_type).classify}"
          .constantize
          .new(options.fetch(:params))
          .build
    end
  end
end
