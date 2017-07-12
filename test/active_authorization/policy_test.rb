# frozen_string_literal: true

require 'test_helper'

module ActiveAuthorization
  class AuthorizationRolesMissingPolicy < Policy
  end

  class AuthorizableedObjectPolicy < Policy
    # :reek:UtilityFunction:
    def authorization_roles(seeker:)
      seeker.roles
    end
  end

  module Some
    module Nested
      class ExtendedObjectPolicy < Policy
        def authorization_roles(seeker:)
          seeker.roles
        end
      end
    end
  end

  module Some
    module Nested
      class IncludedObjectPolicy < Policy
        def authorization_roles(seeker:)
          seeker.roles
        end
      end
    end
  end

  class PolicyTest < Minitest::Test
    def test_that_seeker_can_not_have_a_cake
      receiver = ::AuthorizableedObject.new
      policy = AuthorizableedObjectPolicy.new(
        seeker: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert !policy.authorized?(receiver: receiver,
                                 message_name: prohibited_action)
    end

    def test_that_seeker_can_make_a_tea
      receiver = ::AuthorizableedObject.new
      policy = AuthorizableedObjectPolicy.new(
        seeker: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert policy.authorized?(receiver: receiver,
                                message_name: authorized_action)
    end

    def test_nested
      receiver = ::Some::Nested::IncludedObject.new
      policy = Some::Nested::IncludedObjectPolicy.new(
        seeker: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert policy.authorized?(receiver: receiver,
                                message_name: authorized_action)
    end

    def test_multiple_roles
      receiver = ::Some::Nested::IncludedObject.new
      policy = Some::Nested::IncludedObjectPolicy.new(
        seeker: User.new(%w[Visitor Customer Moderator]),
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert policy.authorized?(receiver: receiver,
                                message_name: authorized_action)
    end

    def test_without_role_implementation_raises_exception
      receiver = ::Some::Nested::IncludedObject.new
      policy = Policy.new(
        seeker: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )
      assert_raises(NotImplemented) do
        policy.authorized?(receiver: receiver,
                           message_name: authorized_action)
      end
    end

    def test_authorize_bang_prohibited_action
      receiver = ::AuthorizableedObject.new
      policy = AuthorizableedObjectPolicy.new(
        seeker: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert_raises(AccessDenied) do
        policy.authorize!(receiver: receiver,
                          message_name: prohibited_action)
      end
    end

    def test_authorize_bang_authorized_action
      receiver = ::AuthorizableedObject.new
      policy = AuthorizableedObjectPolicy.new(
        seeker: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert policy.authorize!(receiver: receiver,
                               message_name: authorized_action)
    end

    def test_authorize_prohibited_action
      receiver = ::AuthorizableedObject.new
      policy = AuthorizableedObjectPolicy.new(
        seeker: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert_nil policy.authorize(
        receiver: receiver,
        message_name: prohibited_action
      ) { 'aaaa' }
    end

    def test_authorize_authorized_action
      receiver = ::AuthorizableedObject.new
      policy = AuthorizableedObjectPolicy.new(
        seeker: current_user,
        factory: Factory.new(Finder.new(receiver.class))
      )

      assert_equal 'aaaa',
                   policy.authorize(
                     receiver: receiver,
                     message_name: authorized_action
                   ) { 'aaaa' }
    end

    def authorized_action
      'make_a_tea'
    end

    def prohibited_action
      'have_a_cake'
    end
  end
end
