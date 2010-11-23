# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
PcaApp::Application.initialize!

ActiveSupport::XmlMini.backend = 'Nokogiri'


