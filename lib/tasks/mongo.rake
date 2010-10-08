
require "rubygems"  # not necessary for Ruby 1.9
require "mongo"
require "yaml"

namespace :db do
  namespace :test do
    task :prepare do
      
      mongo_config_path = File.join(Rails.root, 'config', 'mongoid.yml')
      if File.exists?(mongo_config_path) then
        File.open( mongo_config_path ) { |mc|
          
          mongo_config = YAML::load(mc)
                   
          connection =  Mongo::Connection.new(mongo_config["test"]["host"]).db(mongo_config["test"]["database"])         
        }
      else
        puts("No config at #{mongo_config_path}")
      end
      
    end
    task :purge do
      
      mongo_config_path = File.join(Rails.root, 'config', 'mongoid.yml')
      if File.exists?(mongo_config_path) then
        File.open( mongo_config_path ) { |mc|
          
          mongo_config = YAML::load(mc)
                   
          conn =  Mongo::Connection.new(mongo_config["test"]["host"])
          conn.drop_database(mongo_config["test"]["database"])
        }
      end
    end
  end
end

namespace :mongo do
  task :db do
    dest = File.join("/tmp","mongo_db")
    if not File.exists?(dest) then
      Dir.mkdir(dest)
    end
    system "mongod", "--dbpath=" << dest
  end
end
