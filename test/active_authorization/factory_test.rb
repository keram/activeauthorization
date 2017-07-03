# frozen_string_literal: true

require 'test_helper'

module ActiveAuthorization
  class FactoryTest < Minitest::Test
    def test_build_auth_in_parent_namespace
      finder = Finder.new(ConcernedSubObject)
      factory = Factory.new(finder)
      assert_instance_of Authorizations::ConcernedObject::CustomerAuthorization,
                         factory.build(seeker: current_user,
                                       receiver: ConcernedSubObject,
                                       role: current_user.roles.first)
    end

    def test_build_auth_in_receiver_module_namespace
      finder = Finder.new(ConcernedSubObject)
      factory = Factory.new(finder)
      assert_instance_of Authorizations::ConcernedSubObject::AdminAuthorization,
                         factory.build(seeker: current_user,
                                       receiver: ConcernedSubObject,
                                       role: 'Admin')
    end

    def test_build_auth_from_ancestor
      finder = Finder.new(::Some::Nested::ExtendedObject)
      factory = Factory.new(finder)

      user = User.new(['Vigilante'])
      assert_instance_of Authorizations::Some::Nested::VigilanteAuthorization,
                         factory.build(seeker: user,
                                       receiver: ::Some::Nested::ExtendedObject,
                                       role: user.roles.first)
    end
  end
end
