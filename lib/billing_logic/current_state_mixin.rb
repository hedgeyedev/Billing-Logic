module BillingLogic
  module CurrentStateMixin
    def self.included(clazz)
      clazz.send(:attr_accessor, :profiles)
      clazz.send(:include, Enumerable)
    end

    def each(&block)
      profiles.each(&block)
    end

    def current_products
      map { |profile| profile.current_products }.flatten
    end

    def active_products
      map { |profile| profile.active_products }.flatten
    end
  end
end
