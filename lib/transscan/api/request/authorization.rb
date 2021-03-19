module Transscan::API::Request
  class Authorization
    include Processable
    include ParentProcessable

    private

    def build_objects_from_params(params)
      super
    end
  end
end