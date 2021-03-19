class DispositionProcessQueueService
    def self.call(env, params)
      new(env, params).call
    end
  
    attr_reader :env, :params
  
    def initialize(env,params)
      @env = env
      @params = params
    end
  
    def call
      if ENV['RACK_ENV'] == 'test'
        DispositionProcessWorker.new.perform(test_params)
  
        test_response
      else
        DispositionProcessWorker.new.perform(test_params)

        test_response
        #DispositionProcessWorker.set(queue: queue_name).perform_async(real_params)

        #response
      end
    end

    private

    def route
      @route ||= "/disposition-process/#{"load"}"
    end

    def queue_name
      @queue_name ||= transscan_name
    end

    def transscan_name

      "TransscanRequests"

      #action = transaction.actions.find_by(type: "Gateway::API::Action::Bank::#{transaction.type.camelize}")
      #gateway = Gateway::Base.find_by(id: action.gateway_id)
      #gateway.type.demodulize

    end

    def test_params
      @test_params ||= {
        'env'   => env.update('PATH_INFO' => route,
                              'REQUEST_METHOD' => 'POST',
                              'sinatra.route' => "POST #{route}"),
        'input' => input,
        'response_key' => SecureRandom.hex
      }
    end

    def input
      env["rack.input"].rewind
      Base64.encode64(env["rack.input"].read)
    end

    def real_params
      env['RequestParams'] = {'env' => env}

      env['RequestParams'].tap do |request_params|
        request_params['env'].update('PATH_INFO' => route,
                                     'REQUEST_METHOD' => 'POST',
                                     'sinatra.route' => "POST #{route}")
        request_params['queue_name'] = queue_name
      end
    end

    def test_response
      response = JSON.parse(Transscan.redis.get(test_params['response_key']))

      [response['status'], response['headers'], Base64.decode64(response['body'])]
    end

    def response
      'Disposition process worker'
    end
end
  