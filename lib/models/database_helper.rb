class DatabaseHelper
    def self.select name, *args, &blk
      execute "select", name, *args, &blk
    end
  
    def self.call name, *args, &blk
      execute "call", name, *args, &blk
    end
  
    def self.execute via, name, *args, &blk
      ActiveRecord::Base.connection_pool.with_connection do |connection|
        args = args.map{|e| connection.quote e}
  
        answer = connection.execute("#{via} #{name}(#{args.join(',')})").each(:as => :hash, :symbolize_keys => true) do |row|
          results << OpenStruct.new(row)
        end
  
        if blk
          blk.call(answer)
        else
          answer
        end
      end
    end
  end