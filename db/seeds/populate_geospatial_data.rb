puts 'Deleting all previous geographical data...'

connection = ActiveRecord::Base.connection()

State.delete_all
Region.delete_all
Country.delete_all

connection.execute "ALTER SEQUENCE states_id_seq RESTART WITH 1"
connection.execute "ALTER SEQUENCE regions_id_seq RESTART WITH 1"
connection.execute "ALTER SEQUENCE countries_id_seq RESTART WITH 1"

puts

if Country.all.count == 0
  puts 'Importing data'
  app_root = File.expand_path File.join(File.dirname(__FILE__), '..')
  shp_file = Dir.glob("#{app_root}/shapefiles/*.shp")
  from_country_shp_sql = `shp2pgsql -c -g geom -W LATIN1 -s 4326 #{shp_file[0]} countries_ref`
  connection.execute "drop table if exists countries_ref"
  connection.execute from_country_shp_sql
  connection.execute <<-SQL
      insert into countries(name, iso_code, geom)
        select name, iso, geom  from countries_ref
  SQL
  connection.execute "drop table countries_ref"
end

india_id = Country.all.first.id
puts "Сountry ID = #{india_id}"

puts
