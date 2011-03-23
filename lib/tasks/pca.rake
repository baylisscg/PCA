#
#
#

CLASS_FILES = FileList['**/*.class']

#require 'trinidad'
#require 'warbler'

task :clean => :clobber

task :clobber do
  rm CLASS_FILES
end

namespace :pca do

  desc "Create a normal GRAM run."
  task :make_good do
    puts "Not implemented"
  end

  # desc "Start an instance of the service running."
  # task :run do
  #   opts = {:environment => 'development',
  #     :context_path => '/',
  #     :libs_dir => 'lib',
  #     :classes_dir => 'classes',
  #     :default_web_xml => 'config/web.xml',
  #     :port => 3000,
  #     :jruby_min_runtimes => 1,
  #     :jruby_max_runtimes => 5,
  #     :address => 'localhost',
  #     :log => 'INFO',
  #     :ssl=>{
  #       :port =>3001,
  #       :keystore => "ssl/keystore",
  #       :keystorePass => "waduswadus",
  #     }
  #   }

  #   Trinidad::Server.new(opts).start
    
  # end

  # namespace :client do
  #   Warbler::Task.new("collector",
  #                     Warbler::Config.new do |config|
  #                       #config.jar_name = "collector"
  #                       end
  #                    )
  # end

  # namespace :service do
  
  #   Warbler::Task.new("service",
  #                     Warbler::Config.new do |config|
  #                       # config.jar_name = "service"
  #                     end
  #                       )
  # end
 
end
