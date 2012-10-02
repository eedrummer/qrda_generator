require "simplecov"

require_relative '../lib/qrda_generator'

require 'pry'

require 'minitest/autorun'

db_host = ENV['TEST_DB_HOST'] || 'localhost'

Mongoid.configure do |config|
  config.sessions = { default: { hosts: [ "#{db_host}:27017" ], database: 'qrda-test' }}
end