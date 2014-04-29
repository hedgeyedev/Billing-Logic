require 'billing_logic/current_state_mixin'
module BillingLogic

  # Holds the array of current PaymentProfiles
  class CurrentState

    include BillingLogic::CurrentStateMixin
    
    # Initializes a CurrentState object holding an array of current PaymentProfiles
    #
    # @return [CurrentState] the CurrentState object holding an array of current PaymentProfiles
    def initialize(profiles)
      @profiles = profiles
    end

  end

end
