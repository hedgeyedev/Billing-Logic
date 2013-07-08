require 'bigdecimal'
require "billing_logic/version"
require 'billing_logic/current_state'
require 'billing_logic/billing_cycle'
require 'billing_logic/proration_calculator'
require 'billing_logic/payment_command_builder'
require 'billing_logic/command_builders/command_builders'
require 'active_support/core_ext/date/calculations'
module BillingLogic
  module CommandBuilders
    autoload :BuilderHelpers, 'billing_logic/command_builders/command_builders'
    autoload :BasicBuilder, 'billing_logic/command_builders/command_builders'
    autoload :WordBuilder , 'billing_logic/command_builders/command_builders'
    autoload :AggregateWordBuilder, 'billing_logic/command_builders/command_builders'
    autoload :ActionObject,         'billing_logic/command_builders/command_builders'
    autoload :SINGLE_PRODUCT_REGEX, 'billing_logic/command_builders/command_builders'
    autoload :CurrentState,         'billing_logic/current_state'

  end
  module Strategies
    autoload :BaseStrategy              , 'billing_logic/strategies/base_strategy'
    autoload :IndependentPaymentStrategy, 'billing_logic/strategies/independent_payment_strategy'
    autoload :SinglePaymentStrategy     , 'billing_logic/strategies/single_payment_strategy'
  end
end
