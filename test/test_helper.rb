# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'test'
    command_name 'Minitest'
  end
end

require 'active_authorization'

require 'minitest/autorun'
require 'minitest/benchmark'
require 'minitest/reporters'
require 'irb'
require 'ostruct'

require 'model_fixtures'

module Minitest
  Reporters.use! [Reporters::DefaultReporter.new(color: true)]
end

User = Struct.new(:roles)

def current_user
  User.new(['Customer'])
end

$LOAD_PATH
  .select { |path| Dir.exist? File.join(path, 'authorizations') }
  .map { |path| File.join(path, 'authorizations', '**', '*.rb') }
  .flat_map { |path| Dir.glob(path) }
  .each { |file| require(file) }
