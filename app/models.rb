# encoding: utf-8
#
# We need to manually specify the order in which models are loaded to keep dependencies happy.
#
require 'app/models/entity'
require 'app/models/credential'
require 'app/models/timed_credential'
require 'app/models/cert'
require 'app/models/connection'
require 'app/models/event'
require 'app/models/endpoint'
require 'app/models/user'
