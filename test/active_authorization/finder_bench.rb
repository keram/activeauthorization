# frozen_string_literal: true

require 'test_helper'

module ActiveAuthorization
  class FinderBenchmark < Minitest::Benchmark
    TRESHOLD = 0.999
    module DummyReceivers; end
    module DummyAuthorizations; end

    @original_tree = ActiveAuthorization.tree

    def self.generate_dummy_receiver(name, depth)
      depth.times do |level|
        cls_path = Array.new(level, name).push(name).join('::')
        DummyReceivers.module_eval("class #{cls_path}; end;")
      end

      DummyReceivers.module_eval(Array.new(depth, name).join('::'))
    end

    @dummy_receivers = {
      1 => generate_dummy_receiver('Lorem', 1),
      10 => generate_dummy_receiver('Ipsum', 2),
      100 => generate_dummy_receiver('Dolor', 10),
      1000 => generate_dummy_receiver('Sit', 100),
      10_000 => generate_dummy_receiver('Amet', 1_000)
    }

    class << self
      attr_reader :dummy_trees
      attr_reader :dummy_receivers
      attr_reader :original_tree
    end

    def teardown
      ActiveAuthorization.instance_variable_set('@tree',
                                                self.class.original_tree)
    end

    def bench_initialize
      assert_performance_constant 0.9999 do |range_size|
        Finder.new(self.class.dummy_receivers[range_size])
      end
    end

    # def bench_find_top_level_authorization
    # end

    # def bench_find_non_exist_authorization
    # end

    # def bench_find_namespaced_authorization
    # end
  end
end
