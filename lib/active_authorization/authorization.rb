# frozen_string_literal: true

module ActiveAuthorization
  class Authorization
    def self.inherited(authorization)
      ActiveAuthorization.register(authorization)
    end
    private_class_method :inherited

    # @param seeker [?] the entity requesting message to be send.
    # @param receiver [?] receiver of the message
    def initialize(seeker:, receiver:)
      @seeker = seeker
      @receiver = receiver
    end

    # @param message_name [String] The message to be send to the receiver
    # @return [Boolean]
    #   true or false based on the response from `#:message_name:?`
    #   or #by_default? when method with name `message_name` is not defined.
    def authorized?(message_name)
      send(responding_method(message_name))
    end

    # @param message_name [String] The message to be send to the receiver
    # @return [true, StandardError]
    #         true or raise ActiveAuthorization::AccessDenied exception
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

    # @param message_name [String] The message to be send to the receiver
    # @param block [Proc]
    # @return [nil, *] nil or content of the block passed in
    def authorize(message_name, &block)
      {
        true => block,
        false => -> {}
      }[authorized?(message_name)].call
    end

    # Fallback method when specific query method `#:message_name:?`
    # is not defined on authorization.
    # This method is expected to be overwritten in a children.
    #
    # @return [Boolean] false
    def by_default?
      false
    end

    private

    attr_reader :seeker, :receiver

    def responding_method(message_name)
      methods.detect(-> { :by_default? }) do |meth|
        meth.match?(message_name)
      end
    end
  end
end
