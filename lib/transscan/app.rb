require 'sinatra'
require 'sinatra/base'
require 'sinatra/namespace'
require 'sinatra/multi_route'
require 'transscan/json_serializer'
require 'rack/contrib/post_body_content_type_parser'
require 'rack/cors'
require 'transscan/cors'

require 'transscan/item_handler'

module Transscan
  class App < Sinatra::Base
    register Sinatra::Namespace
    register Sinatra::MultiRoute

    use ::Rack::CommonLogger, Transscan.logger
    use ::Rack::Cors do |config|
      Transscan::Cors.set(config)
    end

    include Transscan::JSONSerializer

    attr_reader :map_container

    set :protection, false # :except => :frame_options
    helpers do
      def render_errors(object)
        halt 400, json(:errors, object, {root: :response})
      end

      def render_json(model)
        status 200
        headers \
          'Content-Type' => 'application/vnd.api+json'
        body model.to_json

      end

      def log_transaction(model)
        Transscan.logger.info "[Disposition model: #{model.type}]"
      end
    end

    before do
      headers 'Access-Control-Allow-Origin' => '*',
              'Access-Control-Allow-Methods' => ['GET', 'PUT', 'POST', 'DELETE', 'HEAD', 'OPTIONS'],
              'Access-Control-Request-Method' => '*',
              'Access-Control-Allow-Headers' => '*'
    end

    namespace '/disposition' do
      get '/loads' do
        DispositionProcessQueueService.call(env, params)
      end
    end

    namespace '/api/v1' do

      %w(authorization map_container).each do |t_type|
        post("/#{t_type}s") do
          req = "::Transscan::API::Request::#{t_type.classify}".constantize.new(
              request: params[:request],
          )
          if req.processable?
            @map_container = API::Builder.build(
                t_type: t_type,
                params: {
                    request: req,
                    base_url: 'http://test.com'
                }
            )
          end
        end
      end
    end
  end


end
