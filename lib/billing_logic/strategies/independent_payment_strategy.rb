module BillingLogic::Strategies

  # The IndependentPaymetStrategy is to be used whenever you wish to
  # associate a product (and its ProductProfileOwnership) with its
  # own recurring payment profile. That is, the product is to be paid for
  # independently of other products. In other word, the product is not part
  # of a bundle.
  class IndependentPaymentStrategy < BaseStrategy

    # Declares IndependentPaymentStrategy's #default_command_builder to be
    #   BillingLogic::CommandBuilders::WordBuilder
    # @return [BillingLogic::CommandBuilders::WordBuilder]
    def default_command_builder
      BillingLogic::CommandBuilders::WordBuilder
    end

    # adds recurring payment command (strings) to @command_list for the 
    #   group_of_products and date passed as block parameters
    def add_commands_for_products_to_be_added!
      with_products_to_be_added do |group_of_products, date|
        group_of_products.each do |products|
          @command_list << create_recurring_payment_command([products], :paid_until_date => date)
        end
      end
    end

  end
end

