# frozen_string_literal: true

require 'test_helper'

module ActiveAuthorization
  class ConcernBenchmark < Minitest::Benchmark
    TRESHOLD = 0.999

    subjects = ['ConcernedObject.new',
                'ConcernedSubObject.new',
                'ConcernedObject',
                'ConcernedSubObject']

    # rubocop: disable Metrics/BlockLength
    subjects.each_with_index do |sub, index|
      %w[authorized prohibited].each do |action|
        module_eval %(
          def bench_authorized_#{action}_#{index}
            assert_performance_linear TRESHOLD do |n|
              n.times do
                #{sub}.authorized?(
                  seeker: current_user,
                  message_name: #{action}_action
                )
              end
            end
          end

          def bench_authorize_bang_#{action}_#{index}
            assert_performance_linear TRESHOLD do |n|
              n.times do
                begin
                  #{sub}.authorize!(
                    seeker: current_user,
                    message_name: #{action}_action
                  )
                rescue ActiveAuthorization::AccessDenied
                end
              end
            end
          end

          def bench_authorize_#{action}_#{index}
            assert_performance_linear TRESHOLD do |n|
              n.times do
                #{sub}.authorize(
                  seeker: current_user,
                  message_name: #{action}_action
                ) { }
              end
            end
          end
        )
      end
    end
    # rubocop: enable Metrics/BlockLength

    def authorized_action
      'make_a_tea'
    end

    def prohibited_action
      'have_a_cake'
    end
  end
end
