require 'active_support/concern'

module Transscan::API::Request
  module ParentProcessable
    extend ActiveSupport::Concern
    attr_reader :params,
                :user_id,
                :entry_name,
                :model,
                :query

    def initialize(options = {})
      @params = options[:request] || {}
      build_objects_from_params(@params)
    end

    protected

    def validate_request
      validate_parent
    end

    def build_objects_from_params(params)
      @user_id          = params["0"][:user_id]
      @entry_name       = params["0"][:name]
      @model            = params["0"][:model]
      @query            = params["0"][:query]

      # if token = params.dig(:credit_card, :token)&.match(ApplePayService.regexp)
      #   params.deep_merge!(ApplePayService.call(token, shop))
      # end
    end

    def validate_parent
      true
    end
  end
end