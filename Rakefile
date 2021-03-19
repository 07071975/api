require 'yaml'
$:.unshift File.expand_path("lib", File.dirname(__FILE__))
# Rakefile
# require './config/environment'

# require 'sinatra/activerecord/rake'
require 'active_record'
require 'sinatra/activerecord/rake'

db_conf = YAML.load_file(File.expand_path("../config/database.yml", __FILE__))
ActiveRecord::Tasks::DatabaseTasks.database_configuration = db_conf

# set :default_env, { _CAPISTRANO: true }

require 'rubygems'
require 'bundler'
# require 'colorize'
Bundler.setup :default

require "./lib/transscan"
# require "./lib/tasks"

Transscan.initialize!

task :environment do
  Transscan.establish_db_connection
end

namespace :db do
  task :migrate => [:migrate_db, "schema:dump"]
  task :rollback => [:rollback_db, "schema:dump"]
#
  namespace :schema do
    desc "schema dump"
    task :dump do
      Transscan.establish_db_connection

      File.open(File.join(Transscan.root, 'db', 'schema.rb'), 'w') do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end

    desc "schema load"
    task :load do
      Transscan.establish_db_connection

      load("db/schema.rb")
    end
  end

  desc "create database"
  task :create do
    begin
      Transscan.establish_db_connection
      if ActiveRecord::Base.connection.exec_query('SELECT 1').rows.first == ["1"]
        puts "Database exists: #{Transscan.db_config['database']}"
      end
    rescue ActiveRecord::NoDatabaseError
      config = Transscan.db_config
      puts "Creating database #{config['database']}"
      Transscan.establish_db_connection(config.merge('database' => nil))
      db_options = config.merge({ charset: 'utf8' })
      ActiveRecord::Base.connection.create_database(config['database'], db_options)
    end
  end

  desc "check database exists"
  task :exists? do
    Transscan.establish_db_connection
    ActiveRecord::Base.connection.exec_query('SELECT 1').rows.first == ["1"]
  end

  desc "migrate the database"
  task :migrate_db do
    Transscan.establish_db_connection
    # ActiveRecord::Migration
    # ActiveRecord::Migrator
    ActiveRecord::Migration.migrate(ActiveRecord::Migration.migrations_paths.first)
  end

  desc "seed data into database"
  task :seed => :environment do
    seed_file = File.join('db/seeds.rb')
    load(seed_file) if File.exist?(seed_file)
  end

  desc "roll back the migration (use steps with STEP=n)"
  task :rollback_db do
    step = ENV["STEP"] ? ENV["STEP"].to_i : 1
    Transscan.establish_db_connection
    ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths.first, step)
  end

  desc "drop database"
  task :drop do
    config = Transscan.db_config
    Transscan.establish_db_connection(config.merge('database' => nil))

    db_options = { charset: 'utf8' }
    ActiveRecord::Base.connection.drop_database(config['database'])
  end

  desc "drop, create and migrate db"
  task :redo => [:drop, :create, :migrate]
end

namespace :gis_test_task do
  desc "creates json for India"
  task create_json: :environment do
    require 'rgeo'
    require 'rgeo/geo_json'

    puts 'Getting data for India'
    india = Country.first
    puts 'Creating RGeo factory'
    factory = RGeo::GeoJSON::EntityFactory.instance
    puts 'Creating feature'
    feature = factory.feature india.geom
    puts 'Generating hash'
    hash = RGeo::GeoJSON.encode feature
    puts 'Writing JSON file'
    File.open('public/india.json', 'w') {|file| file.write hash.to_json}
  end
end