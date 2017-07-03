# frozen_string_literal: true

require 'test_helper'

module ActiveAuthorization
  class ConcernTest < Minitest::Test
    def test_authorize_bang_with_role_implementation_raise_access_denied
      instance = ConcernedObject.new

      assert_raises(AccessDenied) do
        instance.authorize!(seeker: current_user,
                            message_name: prohibited_action)
      end
    end

    def test_authorize_bang_with_role_on_subclass
      instance = ConcernedSubObject.new

      assert_raises(AccessDenied) do
        instance.authorize!(seeker: current_user,
                            message_name: prohibited_action)
      end
    end

    def test_that_it_can_make_tea
      object = ConcernedObject.new

      assert object.authorize!(seeker: current_user,
                               message_name: authorized_action)
    end

    def authorized_action
      'make_a_tea'
    end

    def prohibited_action
      'have_a_cake'
    end
  end
end
