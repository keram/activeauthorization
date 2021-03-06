# frozen_string_literal: true

require 'test_helper'

module ActiveAuthorization
  class AuthorizationTest < Minitest::Test
    attr_reader :authorization

    def initialize(*)
      @authorization = Authorization.new(user: current_user, receiver: nil)

      super
    end

    def test_initialization
      assert_instance_of Authorization, @authorization
    end

    def test_authorized_prohibited_action
      refute authorization.authorized?(prohibited_action)
    end

    def test_authorized_authorized_action
      authorization.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{authorized_action}?
          true
        end
      RUBY

      assert authorization.authorized?(authorized_action)
      assert authorization.authorized?(authorized_action.to_sym)
    end

    def test_message_name_clash
      authorization.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        def something_else?
          true
        end
      RUBY

      assert authorization.authorized?('something_else')
      refute authorization.authorized?('something')
    end

    def test_authorize_bang_prohibited_action
      assert_raises(AccessDenied) do
        authorization.authorize!(prohibited_action)
      end
    end

    def test_authorize_bang_authorized_action
      authorization.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{authorized_action}?
          true
        end
      RUBY

      assert authorization.authorize!(authorized_action)
    end

    def test_authorize_prohibited_action
      authorization.authorize(prohibited_action) { raise }
    end

    def test_authorize_authorized_action
      authorization.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{authorized_action}?
          true
        end
      RUBY

      assert_equal 'aaa', authorization.authorize(authorized_action) { 'aaa' }
    end

    def test_undefined_method_raise_exception
      assert_raises(NoMethodError) do
        authorization.undefined_method
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
