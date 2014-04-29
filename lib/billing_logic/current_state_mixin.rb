module BillingLogic
  module CurrentStateMixin
    def self.included(clazz)
      clazz.send(:attr_accessor, :profiles)
      clazz.send(:include, Enumerable)
    end

    # Iterates through profiles, yielding each one-by-one to the block for processing
    def each(&block)
      profiles.each(&block)
    end

    # Returns array with only BillingEngine::Client::Products belonging to the CurrentState's current
    # (i.e., currently paid-up) PaymentProfiles
    #
    # @return [Array] array of BillingEngine::Client::Products belonging to CurrentState's "current"
    #   PaymentProfiles (i.e., where paid_until_date >= Date.current )
    def current_products
      map { |profile| profile.current_products }.flatten
    end

    # Returns array with only BillingEngine::Client::Products belonging to the CurrentState's active
    # (i.e., enabled & active/pending) PaymentProfiles
    #
    # @return [Array] array of BillingEngine::Client::Products belonging to CurrentState's
    #   "active" PaymentProfiles (i.e., where an 'active' PaymentProfile has #enabled => 1/true
    #   and #profile_status either 'active' or 'pending')
    def active_products
      map { |profile| profile.active_products }.flatten
    end
  end
end
