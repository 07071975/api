require 'sidekiq'

class ItemWorker
  include Sidekiq::Worker

  def perform(url)
    logger.info "Things are happening"

    case url
    when /joe_blow.com/
      sleep 15
      logger.info "joe_blow.com took a really long time"
    when /twitter_clone.com/
      sleep 13
      logger.info "twitter_clone.com was pretty slow"
    else /google.com/
    sleep 11
    logger.info "google.com response was the quickest"
    end

  end

end