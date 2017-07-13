# frozen_string_literal: true

require 'active_authorization/version'
require 'active_authorization/errors'
require 'active_authorization/authorization'
require 'active_authorization/finder'
require 'active_authorization/factory'
require 'active_authorization/policy'
require 'active_authorization/authorizable'

module ActiveAuthorization
  def self.list=(arry)
    @list = arry
  end

  def self.list
    @list
  end

  self.list = []
end
