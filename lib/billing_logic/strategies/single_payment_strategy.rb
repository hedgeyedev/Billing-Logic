module BillingLogic::Strategies

  # The Single Payment Strategy is to be used whenever you are supporting
  # a bundle of products managed under a single recurring payment profile.
  # This strategy will try to figure out the appropriate thing to do
  # when a adding, removing, changing a subscription.
  class SinglePaymentStrategy < BaseStrategy

    # Declares SinglePaymentStrategy's #default_command_builder to be
    #   BillingLogic::CommandBuilders::AggregateWordBuilder.
    #
    # @return [BillingLogic::CommandBuilders::AggregateWordBuilder]
    def default_command_builder
      BillingLogic::CommandBuilders::AggregateWordBuilder
    end

    # Adds recurring payment command (strings) to @command_list for the group_of_products
    #   and date passed as block parameters.
    def add_commands_for_products_to_be_added!
      with_products_to_be_added do |group_of_products, date|
        @command_list << create_recurring_payment_command(group_of_products, 
                                                          :paid_until_date => date,
                                                          :period => extract_period_from_product_list(group_of_products))
      end
    end

    # Calculates the proration for a product based on the billing_cycle, price and current date.
    def proration_for_product(product)
      BillingLogic::ProrationCalculator.new(:billing_cycle => product.billing_cycle,
                                            :price => product.price,
                                            :date   => today + 1 ).prorate
    end

    # Recalculates the initial_payment and billing_cycle#anniversary for a product when
    #   changing the product to have a longer periodicity
    def update_product_billing_cycle_and_payment!(product, previous_product)
      if product.billing_cycle.periodicity > previous_product.billing_cycle.periodicity
        product.initial_payment = product.price - proration_for_product(previous_product)
        product.billing_cycle.anniversary = today
      end
    end

    # Recalculates the billing_cycle#next_payment_date for a product when its billing_cycle
    #   changes
    def next_payment_date_from_product(product, previous_product)
      if product.billing_cycle.periodicity > previous_product.billing_cycle.periodicity
        product.billing_cycle.next_payment_date
      else
        next_payment_date_from_profile_with_product(product, :active => true)
      end
    end

  end
end
