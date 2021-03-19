require 'sidekiq-scheduler'

class SidekiqStatsJob < Sidekiq::Instrument::Worker
  sidekiq_options queue: :sidekiq_stats
end
