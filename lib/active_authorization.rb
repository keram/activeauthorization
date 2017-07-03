# frozen_string_literal: true

require 'active_authorization/version'
require 'active_authorization/errors'
require 'active_authorization/authorizations'
require 'active_authorization/authorization'
require 'active_authorization/finder'
require 'active_authorization/factory'
require 'active_authorization/policy'
require 'active_authorization/concern'

module ActiveAuthorization
  def self.class_ancestors(cls)
    cls
      .ancestors
      .select { |ancestor| ancestor.is_a? Class }
      .reject { |ancestor| [Object, BasicObject].include? ancestor }
  end

  def self.preload_authorizations
    $LOAD_PATH
      .select { |path| Dir.exist? File.join(path, 'authorizations') }
      .map { |path| File.join(path, 'authorizations', '**', '*.rb') }
      .flat_map { |path| Dir.glob(path) }
      .each { |file| require(file) }
  end
end
