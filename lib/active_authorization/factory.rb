# frozen_string_literal: true

module ActiveAuthorization
  class Factory
    SUFFIX = 'Authorization'

    def initialize(finder)
      @finder = finder
    end

    def build(seeker:, receiver:, role:)
      authorization_class(
        role.dup.concat(SUFFIX)
      ).new(seeker: seeker, receiver: receiver)
    end

    private

    def authorization_class(class_name)
      @finder.find(class_name)
    end
  end
end
