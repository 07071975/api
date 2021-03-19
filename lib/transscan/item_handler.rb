# require_relative 'item_worker'  #look for item_worker.rb in the same directory as this file
require 'transscan/item_worker'

class ItemHandler
  def initialize(url)
    @url = url
  end

  def start_processing
    ItemWorker.new.perform @url
  end
end