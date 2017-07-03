# frozen_string_literal: true

require 'test_helper'
require 'active_authorization/concern/class_methods_test'

module ActiveAuthorization
  module Concern
    class InstanceMethodsTest < ClassMethodsTest
      def subject
        ::IncludedObject.new
      end

      def subject_without_authorization_request_role
        ::IncludedWithoutCustomerRoleObject.new
      end

      def subject_without_authorization_request_role_class_name
        ::IncludedWithoutCustomerRoleObject.name
      end

      def subject_with_namespace
        ::Some::Nested::IncludedObject.new
      end
    end
  end
end
