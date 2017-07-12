# frozen_string_literal: true

module ActiveAuthorization
  class Error < StandardError; end
  class NotImplemented < Error; end
  class AccessDenied < Error
    attr_reader :details

    def initialize(details)
      @details = details

      super()
    end
  end

  class PolicyAccessDenied < AccessDenied
  end

  class AuthorizableAccessDenied < AccessDenied
  end
end
