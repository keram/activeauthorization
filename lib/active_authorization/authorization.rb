# frozen_string_literal: true

module ActiveAuthorization
  class Authorization
    DEFAULT_STATUS = false
    MOD_SEPARATOR = '::'
    FALLBACK = -> { :default_status }

    def self.inherited(other)
      ActiveAuthorization.tree[other.name.split(MOD_SEPARATOR).slice(1...-1)]
                         .push(other)
    end
    private_class_method :inherited

    def initialize(seeker:, receiver:)
      @seeker = seeker
      @receiver = receiver
    end

    def authorized?(message_name)
      send(responding_method(message_name))
    end

    def authorize!(message_name)
      {
        true => -> { true },
        false => lambda {
          raise AccessDenied.new(seeker: seeker,
                                 receiver: receiver,
                                 message_name: message_name)
        }
      }[authorized?(message_name)].call
    end

    def authorize(message_name)
      {
        true => yield,
        false => nil
      }[authorized?(message_name)]
    end

    private

    attr_reader :seeker, :receiver

    def default_status
      DEFAULT_STATUS
    end

    def responding_method(message_name)
      methods.detect(FALLBACK) { |meth| meth.match?(message_name) }
    end
  end
end
