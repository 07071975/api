require 'settingslogic'
require 'uri'

module Transscan
  class Settings < Settingslogic
    source "#{Transscan.root}/config/settings.yml"
    namespace Transscan.env

    suppress_errors true

    def proxy_uri
      if Transscan::Settings.proxy
        proxy = Transscan::Settings.proxy.to_hash
        URI(proxy[:uri])
      end
    end
  end
end
