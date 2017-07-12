# frozen_string_literal: true

require 'test_helper'

module ActiveAuthorization
  class AuthorizableTest < Minitest::Test
    def test_authorize_bang
      [AuthorizableObject, AuthorizableObject.new].each do |subject|
        assert_raises(AccessDenied) do
          subject.authorize!(seeker: current_user,
                             message_name: prohibited_action)
        end

        assert subject.authorize!(seeker: current_user,
                                  message_name: authorized_action)
      end
    end

    def test_authorize_bang_on_subclass
      [AuthorizableSubObject, AuthorizableSubObject.new].each do |subject|
        assert_raises(AccessDenied) do
          subject.authorize!(seeker: current_user,
                             message_name: prohibited_action)
        end

        assert subject.authorize!(seeker: current_user,
                                  message_name: authorized_action)
      end
    end

    def test_authorize_bang_without_authorization_roles_implementation
      [NoAuthorizationRolesObject, NoAuthorizationRolesObject.new]
        .each do |subject|
        assert_raises(NotImplemented) do
          subject.authorize!(seeker: current_user,
                             message_name: authorized_action)
        end
      end
    end

    def authorized_action
      'make_a_tea'
    end

    def prohibited_action
      'have_a_cake'
    end
  end
end
