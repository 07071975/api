require 'active_record'
require 'erb'
require 'detectify'
require 'sidekiq'
require 'logger'
#require 'sidekiq/instrument'
require 'redis'
require 'redis-namespace'

module Transscan
  autoload :API, 'transscan/api'
  autoload :App, 'transscan/app'
  autoload :Logger, 'transscan/logger'
  autoload :Settings, 'transscan/settings'
  autoload :JsonSerializer, 'transscan/json_serializer'

  class << self
    def root
      File.expand_path File.join(File.dirname(__FILE__), '..')
    end

    def env
      @env ||= ENV['RACK_ENV'] || 'development'
    end

    def redis
      @redis ||= Redis::Namespace.new(
        Transscan::Settings.sidekiq.namespace,
        redis: Redis.new(url: Transscan::Settings.pubsub.url, timeout: 9)
      )
    end

    def metrics_redis
      @metrics_redis ||= Redis::Namespace.new(
        Transscan::Settings.metrics.namespace,
        redis: Redis.new(url: Transscan::Settings.redis.url)
      )
    end

    def logger
      @logger ||= begin
        type = Settings.syslog_name ? :syslog : :local
        Logger.factory type, self
      end
    end

    def logger=(log_object)
      @logger = log_object
    end    

    def initialize!
      establish_db_connection
      configure_sidekiq
    end

    def establish_db_connection(config = nil)
      config ||= db_config
      ActiveRecord::Base.establish_connection(config)
    end

    def db_config
      YAML.load(ERB.new(File.read("#{root}/config/database.yml")).result)[env]
    end

    def configure_sidekiq
      settings = Transscan::Settings.sidekiq
      Sidekiq.configure_server do |config|
        config.redis = { url: settings.url,
                         namespace: settings.namespace,
                         network_timeout: settings.network_timeout }
        config.logger = Transscan.logger
      end
      Sidekiq.configure_client do |config|
        # size - size of connections in our Redis connection pool
        config.redis = { url: settings.url,
                         namespace: settings.namespace,
                         size: settings.size,
                         network_timeout: settings.network_timeout }
      end
    end    
  
    private

    def read_live_transscan
      [].tap do |model|
        Dir.glob("#{Transscan.root}/lib/models/transscan/*.rb").each do |file|
          name = file.split('/').last.sub(/\.rb/, '').camelcase
          next if name == "Demo"
          model << "Transscan::#{name}"
        end
      end
    end

    def filename(path)
      path.split('/').last.split('.').first
    end  


  end
end

Dir.glob("#{Transscan.root}/config/initializers/**/*.rb").each do |file|
  require file
end

require 'app_request'
require 'event_finalization'
require 'models'
require 'workers'
require 'services'