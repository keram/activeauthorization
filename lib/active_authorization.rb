# frozen_string_literal: true

require 'active_authorization/version'
require 'active_authorization/errors'
require 'active_authorization/authorization'
require 'active_authorization/finder'
require 'active_authorization/factory'
require 'active_authorization/policy'
require 'active_authorization/authorizable'

# Main namespace of the gem
module ActiveAuthorization
  # Add authorization class to list of all auth classes.
  # It is automatically called when class inherits
  # from ActiveAuthorization::Authorization
  #
  # == Parameters:
  # authorization::
  #   Class which inherits from ActiveAuthorization::Authorization
  #
  # == Returns:
  # Array of all authorizations in same scope as the authorization in args.
  #
  def self.register(authorization)
    @tree[authorization.name.split('::').slice(1...-1)].push(authorization)
  end

  # Return scoped authorizations
  #
  # == Parameters:
  #
  # == Returns:
  # Hash
  #
  def self.tree
    @tree
  end

  @tree = Hash.new { |hash, key| hash[key] = [] }
end
