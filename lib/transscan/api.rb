module Transscan::API
  autoload :Builder, 'transscan/api/builder'

  module Request
    autoload :MapContainer, 'transscan/api/request/map_container'
    autoload :Authorization, 'transscan/api/request/authorization'
    autoload :Processable, 'transscan/api/request/processable'
    autoload :ParentProcessable, 'transscan/api/request/parent_processable'
  end
  module Disposition
    autoload :Load, 'transscan/api/disposition/load'
    autoload :Processable, 'transscan/api/disposition/processable'
  end
  module MapContainer
    autoload :Base, 'transscan/api/map_container/base'
    autoload :CmrRouting, 'transscan/api/map_container/cmr_routing'
  end

end