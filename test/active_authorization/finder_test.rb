# frozen_string_literal: true

require 'test_helper'

module ActiveAuthorization
  class FinderTest < Minitest::Test
    def test_find_in_namespace_module
      finder = Finder.new(::Some::Nested::ExtendedObject)

      assert_equal Authorizations::Some::Nested::VigilanteAuthorization,
                   finder.find('VigilanteAuthorization')
    end

    def test_find_in_parent_class
      finder = Finder.new(::AuthorizableedSubObject)

      assert_equal Authorizations::AuthorizableedObject::CustomerAuthorization,
                   finder.find('CustomerAuthorization')
    end

    def test_fallback
      finder = Finder.new(::AuthorizableedSubObject)

      assert_equal Authorization, finder.find('NonExistantAuthorization')
    end
  end
end
