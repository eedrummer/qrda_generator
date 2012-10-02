require "simplecov"

require_relative '../lib/qrda_generator'

require 'pry'

require 'minitest/autorun'

db_host = ENV['TEST_DB_HOST'] || 'localhost'

Mongoid.configure do |config|
  config.sessions = { default: { hosts: [ "#{db_host}:27017" ], database: 'qrda-test' }}
end

class MiniTest::Unit::TestCase
  # Add more helper methods to be used by all tests here...
  
  def collection_fixtures(collection, *id_attributes)
    Mongoid.session(:default)[collection].drop
    Dir.glob(File.join(File.dirname(__FILE__), 'fixtures', collection, '*.json')).each do |json_fixture_file|
      #puts "Loading #{json_fixture_file}"
      fixture_json = JSON.parse(File.read(json_fixture_file))
      id_attributes.each do |attr|
        fixture_json[attr] = Moped::BSON::ObjectId.from_string(fixture_json[attr])
      end

      Mongoid.session(:default)[collection].insert(fixture_json)
    end
  end
end