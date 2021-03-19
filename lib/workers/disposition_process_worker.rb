require 'sidekiq'

class DispositionProcessWorker
  include Sidekiq::Worker
  include EventFinalization

  sidekiq_options retry: false

  def perform(params)
    workers_counter_key = get_workers_counter_key(params)
    incr_workers_counter(workers_counter_key)

    begin

      app_request = AppRequest.new(params)

      response = if app_request.request_timeout_expired?
                   app_request.timeout_response
                 elsif !queue_is_full?(params, workers_counter_key)
                   app_request.call
                 end

      if response
        save_event_and_publish(params, response)
      else
        DispositionProcessWorker.perform_in(Transscan::Settings.sidekiq.disposition_process_worker.retry_interval, params)
      end
    ensure
      decr_workers_counter(workers_counter_key)
    end
  end

  private

  def queue_is_full?(params, workers_counter_key)
    current_size = Transscan.redis.get(workers_counter_key).to_i
    max_size = Transscan::Settings.sidekiq.queues[params['queue_name']] || Transscan::Settings.sidekiq.queues.default

    current_size > max_size
  end

  def get_workers_counter_key(params)
    if Transscan::Settings.sidekiq.main_pool
      "main_pool:#{params['queue_name']}:counter"
    else
      "#{Process.pid}:#{params['queue_name']}:counter"
    end
  end

  def incr_workers_counter(workers_counter_key)
    Transscan.redis.incr workers_counter_key

    unless Transscan::Settings.sidekiq.main_pool
        Transscan.redis.expire workers_counter_key, Transscan::Settings.sidekiq.disposition_process_worker.counter_key_lifetime
    end
  end

  def decr_workers_counter(workers_counter_key)
    Transscan.redis.decr workers_counter_key
  end
end
