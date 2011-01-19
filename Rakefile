# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

PcaApp::Application.load_tasks

# If we are using jruby enable Warbler
if RUBY_PLATFORM =~ /java/ then
    require 'warbler'
    Warbler::Task.new
end


YARD::Rake::YardocTask.new do |t|
  t.files   = ['app/**/*.rb', 'lib/**/*.rb' ,'spec/**/*.rb']   # optional
  t.options = [] # optional
end