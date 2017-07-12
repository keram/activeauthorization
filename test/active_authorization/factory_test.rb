# frozen_string_literal: true

require 'test_helper'

module ActiveAuthorization
  class FactoryTest < Minitest::Test
    def test_build_auth_in_parent_namespace
      finder = Finder.new(AuthorizableedSubObject)
      factory = Factory.new(finder)
      expected = Authorizations::AuthorizableedObject::CustomerAuthorization
      assert_instance_of expected,
                         factory.build(seeker: current_user,
                                       receiver: AuthorizableedSubObject,
                                       role: current_user.roles.first)
    end

    def test_build_auth_in_receiver_module_namespace
      finder = Finder.new(AuthorizableedSubObject)
      factory = Factory.new(finder)
      expected = Authorizations::AuthorizableedSubObject::AdminAuthorization
      assert_instance_of expected,
                         factory.build(seeker: current_user,
                                       receiver: AuthorizableedSubObject,
                                       role: 'Admin')
    end

    def test_build_auth_from_ancestor
      finder = Finder.new(::Some::Nested::ExtendedObject)
      factory = Factory.new(finder)

      user = User.new(['Vigilante'])
      expected = Authorizations::Some::Nested::VigilanteAuthorization
      assert_instance_of expected,
                         factory.build(seeker: user,
                                       receiver: ::Some::Nested::ExtendedObject,
                                       role: user.roles.first)
    end
  end
end
