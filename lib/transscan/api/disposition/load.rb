module Transscan::API::Disposition
    class Load #< Base
        include Processable
        def initialize()
            $stdout.puts "load initialize!"
            # VmCargoes.reflect_on_all_associations(:belongs_to)
            @cargoes = VmCargoes.joins(:order).all #.joins(:order)

            $stdout.puts @cargoes.inspect
        end
        def process(params = nil)
            $stdout.puts "Load processable"
            VmCargoesSerializer.new(@cargoes, include: [:order]).serializable_hash
        end
    end
end