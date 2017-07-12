# frozen_string_literal: true

require 'test_helper'

module Dummy
  module Other
    module Nested
      class TestReceiver < Some::Nested::AuthorizableObject
      end
    end
  end
end

module ActiveAuthorization
  class FakeAuthorization
    def self.new(cls_name)
      @name = Finder::AUTH_MOD_PREFIX
              .dup.concat(cls_name)

      super()
    end

    class << self
      attr_reader :name
    end

    def name
      self.class.name
    end
  end

  class FinderBenchmark < Minitest::Benchmark
    TRESHOLD = 0.9999

    def self.create_authorization_class(auth_cls_name)
      Authorizations.module_eval("class #{auth_cls_name}; end")
      Authorizations.module_eval(auth_cls_name.to_s)
    end

    Authorizations.module_eval('module Dummy; module Other; end; end')
    Authorizations.module_eval('module Another; module Thor; end; end')

    @auths_original = Authorizations.list
    @auths = bench_range.each_with_object({}) do |range_size, acc|
      acc[range_size.to_s] = []
      range_size.times do |nth|
        [
          "Dummy::Other::Fake#{nth}Authorization",
          "Another::Thor::Exclude#{nth}Authorization",
          "TopFake#{nth}Authorization"
        ].each do |auth_name|
          acc[range_size.to_s].push(create_authorization_class(auth_name))
        end
      end
    end

    class << self
      attr_reader :auths
      attr_reader :auths_original
    end

    def teardown
      Authorizations.list = self.class.auths_original
    end

    def bench_initialize
      assert_performance_constant TRESHOLD do |range_size|
        Authorizations.list = auths[range_size.to_s]
        Finder.new(receiver_class)
      end
    end

    def bench_find_top_level_authorization
      assert_performance_constant TRESHOLD do |range_size|
        Authorizations.list = auths[range_size.to_s]
        finder = Finder.new(receiver_class)
        finder.find("TopFake#{(range_size - 1)}Authorization")
      end
    end

    def bench_find_non_exist_authorization
      assert_performance_constant TRESHOLD do |range_size|
        Authorizations.list = auths[range_size.to_s]
        finder = Finder.new(receiver_class)
        finder.find("NonExist#{range_size}Authorization")
      end
    end

    def bench_find_namespaced_authorization
      assert_performance_constant TRESHOLD do |range_size|
        Authorizations.list = auths[range_size.to_s]
        finder = Finder.new(receiver_class)
        finder.find("Fake#{(range_size - 1)}Authorization")
      end
    end

    def receiver_class
      Dummy::Other::Nested::TestReceiver
    end

    def auths
      self.class.auths
    end
  end
end
