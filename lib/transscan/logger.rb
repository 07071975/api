require 'delegate'
require 'lumberjack_syslog_device'

module Transscan
  class Logger < ::SimpleDelegator
    class << self

      def factory(type, transscan)
        logger = send("setup_#{type}", transscan)
        new(logger)
      rescue NoMethodError
        nil
      end

      def setup_syslog(transscan)
        ActiveSupport::LogSubscriber.colorize_logging = false

        device = Lumberjack::SyslogDevice.new(facility: Syslog::LOG_LOCAL0)
        setup_logger(transscan, device, progname: Settings.syslog_name)
      end

      def setup_local(transscan)
        device = "#{transscan.root}/log/#{transscan.env}.log"
        setup_logger(transscan, device)
      end

      def setup_logger(transscan, device, options = {})
        level = transscan.env == 'production' ? :info : :debug
        options = options.merge(flush_seconds: 1, level: level)

        Lumberjack::Logger.new(device, options)
      end
    end

    def write(message = nil, progname = nil, &block)
      info(message, progname, &block)
    end
    alias << write

    [:info, :debug, :warn, :error, :fatal].each do |level|
      define_method(level) do |message = nil, progname = nil, &block|
        message = message&.encode('UTF-8', invalid: :replace, undef: :replace)
                         &.gsub(/\\\"/, '"')
        message = "[#{Thread.current.object_id}] #{message}"
        #message = ApplePayService.filter_data(message)
        #RequestChain.request = { level: level,
        #                         message: message} if RequestChain.enabled?
        super(message, progname, &block)
      end
    end

  end
end
