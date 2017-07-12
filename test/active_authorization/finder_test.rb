# frozen_string_literal: true

require 'test_helper'

module ActiveAuthorization
  class FinderTest < Minitest::Test
    def test_find_in_namespace_module
      finder = Finder.new(::Some::Nested::AuthorizableObject)

      assert_equal ::Authorizations::Some::Nested::VigilanteAuthorization,
                   finder.find('VigilanteAuthorization')
    end

    def test_find_in_parent_class
      finder = Finder.new(::AuthorizableSubObject)

      assert_equal ::Authorizations::AuthorizableObject::CustomerAuthorization,
                   finder.find('CustomerAuthorization')
    end

    def test_find_fallback
      finder = Finder.new(::AuthorizableSubObject)

      assert_equal Authorization, finder.find('NonExistantAuthorization')
    end
  end
end
