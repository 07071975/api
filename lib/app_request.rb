class AppRequest
    def self.call(params)
      new(params).call
    end
  
    attr_reader :params
  
    def initialize(params)
      @params = params
    end
  
    def call
      if request_timeout_expired?
        timeout_response
      else
        transscan_response
      end
    rescue => e
      exception_handling(e)
      error_response
    end
  
    def request_timeout_expired?
      if params['created_at']
        (Time.now.utc - Time.parse(params['created_at'])) > Transscan::Settings.processing_timeout
      end
    end
  
    def timeout_response
      body = {
        message: 'Timeout',
        errors: { base: ['Timeout to process your request'] }
      }.to_json
  
      build_response(504, { 'Content-Type' => 'application/json' }, body)
    end
  
    private
  
    def transscan_response
      status, headers, body = Transscan::App.call(env)
  
      build_response(status, headers, body)
    end
  
    def env
      params['env'].merge('RequestID'     => params['request_id'],
                          'rack.input'    => StringIO.new(Base64.decode64(params['input'])),
                          'RequestParams' => params)
    end
  
    def build_response(status, headers, body)
      {
        status: status,
        headers: headers,
        body: Base64.encode64(body_as_string(body))
      }
    end
  
    def body_as_string(body)
      body.respond_to?(:join) ? body.join : body.to_s
    end
  
    def error_response
      body = { 'error' => "We're sorry, but something went wrong" }.to_json
  
      build_response(500, { 'Content-Type' => 'application/json' }, body)
    end
  
    def exception_handling(exception)
      message = "Error"
      Transscan.logger.error message
    end
  end
  