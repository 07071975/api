module Transscan
    module Cors
      def self.set(config)
        config.allow do |allow|
          allow.origins '*'
	        allow.resource '*', headers: :any, methods: [:get, :post, :patch, :put]
        end
        config.allow do |allow|
          allow.origins '*'
	        allow.resource '/disposition-process/*', methods: %i[post options], headers: :any, max_age: 0
        end
      end
    end
  end
  