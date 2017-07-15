# frozen_string_literal: true

module ActiveAuthorization
  class Authorization
    def self.inherited(authorization)
      ActiveAuthorization.register(authorization)
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
      false
    end

    def responding_method(message_name)
      methods.detect(-> { :default_status }) do |meth|
        meth.match?(message_name)
      end
    end
  end
end
