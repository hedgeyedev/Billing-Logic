require 'billing_logic/current_state_mixin'
module BillingLogic
  class CurrentState
    include BillingLogic::CurrentStateMixin
    def initialize(profiles)
      @profiles = profiles
    end
  end
end
