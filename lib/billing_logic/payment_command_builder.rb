module BillingLogic

  # Converts an array of BillingEngine::Client::Products and a next_payment_date into (string) commands
  # for creating recurring_payments. Also converts a list of PaymentProfile#ids into
  # commands for canceling their recurring_payments.
  class PaymentCommandBuilder

    # Creates a PaymentCommandBuilder from an array of BillingEngine::Client::Products
    #
    # @param products [Array<BillingEngine::Client::Product>]
    def initialize(products)
      @products = products
    end

    # Groups BillingEngine::Client::Products into a hash with keys of BillingEngine::Client::Product#billing_cycle and values of the products
    def group_products_by_billing_cycle
      @products.inject({}) do |a, e|
        a[e.billing_cycle] ||= []
        a[e.billing_cycle] << e
        a
      end
    end

    class << self

      
      # @return [String] the (string) command for creating recurring payments for
      #   the passed-in array of BillingEngine::Client::Products with the passed-in next_payment_date
      def create_recurring_payment_commands(products, next_payment_date = Date.current)
        self.new(products).group_products_by_billing_cycle.map do |k, prods|
          {
            :action => 'create_recurring_payment',
            :products => prods,
            :price => prods.inject(0) { |a, e| a + e.price; a },
            :next_payment_date => next_payment_date,
            :billing_cycle => k
          }
        end
      end

      # @return [String] the (string) command for canceling recurring payments for
      #   the passed-in array of PaymentProfile#ids
      def cancel_recurring_payment_commands(*profile_ids)
        profile_ids.map do |profile_id| 
          {
            :action => :cancel_recurring_payment,
            :payment_profile_id => profile_id
          }
        end
      end
    end

  end
end
