module EventFinalization
    def save_event_and_publish(params, response)
      Transscan.redis.setex(params['response_key'], Transscan::Settings.response_ttl.to_i, response.to_json)
      publish_event(params)
      Transscan.logger.info "Event #{params['event_name']} is published"
    rescue => e
        Transscan.logger.error "Event #{params['event_name']} publishing error: #{e}\n#{e.backtrace.join("\n")}"
    end
  
    def publish_event(params)
        Transscan.redis.publish(params['event_name'], 'OK')
    end
end
  