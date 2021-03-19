
module Transscan::API::Disposition::Processable
  class DispositionInProcess < RuntimeError; end
  def process(params = nil)
    $stdout.puts "processable"
  end
end