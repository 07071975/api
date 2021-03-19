Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/seeds/*.rb").each { |f| require f }
