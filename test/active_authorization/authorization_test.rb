# frozen_string_literal: true

require 'test_helper'

module ActiveAuthorization
  class AuthorizationTest < Minitest::Test
    def test_initialization
      assert_instance_of Authorization, authorization
    end

    def test_authorized_prohibited_action
      refute authorization.authorized?(prohibited_action)
    end

    def test_authorized_authorized_action
      auth = authorization

      auth.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{authorized_action}?
          true
        end
      RUBY

      assert auth.authorized?(authorized_action)
    end

    def test_authorize_bang_prohibited_action
      assert_raises(AccessDenied) do
        authorization.authorize!(prohibited_action)
      end
    end

    def test_authorize_bang_authorized_action
      auth = authorization

      auth.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{authorized_action}?
          true
        end
      RUBY

      assert auth.authorize!(authorized_action)
    end

    def test_authorize_prohibited_action
      assert_nil authorization.authorize(prohibited_action) { 'aaa' }
    end

    def test_authorize_authorized_action
      auth = authorization

      auth.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{authorized_action}?
          true
        end
      RUBY

      assert_equal 'aaa', auth.authorize(authorized_action) { 'aaa' }
    end

    def test_undefined_method_raise_exception
      assert_raises(NoMethodError) do
        authorization.undefined_method
      end
    end

    def authorization
      Authorization.new(seeker: current_user, receiver: nil)
    end

    def authorized_action
      'make_a_tea'
    end

    def prohibited_action
      'have_a_cake'
    end
  end
end
