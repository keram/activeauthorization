# frozen_string_literal: true

require 'active_authorization/version'
require 'active_authorization/errors'
require 'active_authorization/authorization'
require 'active_authorization/finder'
require 'active_authorization/factory'
require 'active_authorization/policy'
require 'active_authorization/authorizable'

module ActiveAuthorization
  def self.register(authorisation)
    @tree[authorisation.name.split('::').slice(1...-1)].push(authorisation)
  end

  def self.tree
    @tree
  end

  @tree = Hash.new { |hash, key| hash[key] = [] }
end
