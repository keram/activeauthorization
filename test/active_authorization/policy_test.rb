# frozen_string_literal: true

require 'test_helper'

module ActiveAuthorization
  class AuthorizationRolesMissingPolicy < Policy
  end

  class AuthorizableObjectPolicy < Policy
    # :reek:UtilityFunction:
    def authorization_roles(user:)
      user.roles
    end
  end

  module Some
    module Nested
      class AuthorizableObjectPolicy < Policy
        def authorization_roles(user:)
          user.roles
        end
      end
    end
  end

  class PolicyTest < Minitest::Test
    def test_that_user_can_not_have_a_cake
      policy = AuthorizableObjectPolicy.new(
        user: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert !policy.authorized?(receiver: receiver,
                                 message_name: prohibited_action)
    end

    def test_that_user_can_make_a_tea
      policy = AuthorizableObjectPolicy.new(
        user: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert policy.authorized?(receiver: receiver,
                                message_name: authorized_action)
    end

    def test_nested
      receiver = ::Some::Nested::AuthorizableObject.new
      policy = Some::Nested::AuthorizableObjectPolicy.new(
        user: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert policy.authorized?(receiver: receiver,
                                message_name: authorized_action)
    end

    def test_multiple_roles
      receiver = ::Some::Nested::AuthorizableObject.new
      policy = Some::Nested::AuthorizableObjectPolicy.new(
        user: User.new(%w[Visitor Customer Moderator]),
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert policy.authorized?(receiver: receiver,
                                message_name: authorized_action)
    end

    def test_without_authorization_roles_implementation
      policy = AuthorizationRolesMissingPolicy.new(
        user: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )
      assert_raises(NotImplemented) do
        policy.authorized?(receiver: receiver,
                           message_name: authorized_action)
      end
    end

    def test_authorize_bang_prohibited_action
      policy = AuthorizableObjectPolicy.new(
        user: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert_raises(AccessDenied) do
        policy.authorize!(receiver: receiver,
                          message_name: prohibited_action)
      end
    end

    def test_authorize_bang_authorized_action
      policy = AuthorizableObjectPolicy.new(
        user: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert policy.authorize!(receiver: receiver,
                               message_name: authorized_action)
    end

    def test_authorize_prohibited_action
      policy = AuthorizableObjectPolicy.new(
        user: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      policy.authorize(
        receiver: receiver,
        message_name: prohibited_action
      ) { raise }
    end

    def test_authorize_authorized_action
      policy = AuthorizableObjectPolicy.new(
        user: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert_equal 'aaaa',
                   policy.authorize(
                     receiver: receiver,
                     message_name: authorized_action
                   ) { 'aaaa' }
    end

    def receiver
      ::AuthorizableObject.new
    end

    def authorized_action
      'make_a_tea'
    end

    def prohibited_action
      'have_a_cake'
    end
  end
end
