# frozen_string_literal: true

require 'test_helper'

class ActiveAuthorizationTest < Minitest::Test
  class SomeAuthorisation
  end

  def test_that_it_has_a_version_number
    refute_nil ::ActiveAuthorization::VERSION
  end

  def test_tree
    assert ActiveAuthorization.tree.is_a? Hash
  end

  # :reek:DuplicateMethodCall
  def test_register
    original_branch = ActiveAuthorization.tree[[]].dup
    ActiveAuthorization.register(SomeAuthorisation)

    assert ActiveAuthorization.tree.values.flatten.include? SomeAuthorisation
    ActiveAuthorization.tree[[]] = original_branch
  end
end
