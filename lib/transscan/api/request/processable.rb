module Transscan::API::Request
  module Processable
    attr_reader :validation_errors

    def processable?
      clear_validation_errors
      validate_request
      validation_errors.empty?
    end

    private

    def clear_validation_errors
      @validation_errors = Hash.new { |hash, key| hash[key] = {} }
    end
  end
end
