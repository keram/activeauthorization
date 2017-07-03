# frozen_string_literal: true

require 'active_authorization/concern/class_methods'
require 'active_authorization/concern/instance_methods'

module ActiveAuthorization
  module Concern
    def self.included(klass)
      klass.extend ClassMethods
      klass.include InstanceMethods
      ActiveAuthorization.preload_authorizations
    end
  end
end
