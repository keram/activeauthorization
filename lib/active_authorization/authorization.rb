# frozen_string_literal: true

module ActiveAuthorization
  class Authorization
    DEFAULT_STATUS = false
    CHECK_METHOD_PREFIX = 'can_'
    CHECK_METHOD_SUFFIX = '?'
    CHECK_METHOD_REGEXP = Regexp.compile(
      '\A'.dup
      .concat(Regexp.quote(CHECK_METHOD_PREFIX))
      .concat('[a-z]+[a-z_]+[^_]')
      .concat(Regexp.quote(CHECK_METHOD_SUFFIX))
      .concat('\z')
    )

    def self.inherited(other)
      ActiveAuthorization.list.push(other)
    end
    private_class_method :inherited

    def self.check_method?(method_name)
      method_name.match?(CHECK_METHOD_REGEXP)
    end

    def self.check_method_name(message_name)
      CHECK_METHOD_PREFIX.dup
                         .concat(message_name)
                         .concat(CHECK_METHOD_SUFFIX)
    end

    def initialize(seeker:, receiver:)
      @seeker = seeker
      @receiver = receiver
    end

    def authorized?(message_name)
      send(self.class.check_method_name(message_name))
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
      self.class::DEFAULT_STATUS
    end

    def respond_to_missing?(method_name, include_private)
      {
        true => true,
        false => super
      }[self.class.check_method?(method_name)]
    end

    def method_missing(method_name, *arguments, &block)
      {
        true => -> { default_status },
        false => -> { super }
      }[respond_to_missing?(method_name, false)].call
    end
  end
end
