require 'forwardable'

module BillingLogic::Strategies

  # The BaseStrategy defines generic functions used by various BillingLogic::Strategies.
  # @abstract
  class BaseStrategy

    attr_accessor :desired_state, :current_state, :payment_command_builder_class, :default_command_builder

    # Defines an initializer for subclasses to use
    def initialize(opts = {})
      @current_state = opts.delete(:current_state) || []
      @desired_state = opts.delete(:desired_state) || []
      @command_list = []
      self.payment_command_builder_class = opts.delete(:payment_command_builder_class)
    end

    # Sets @payment_command_builder_class (or raises exception if attempting to instantiate Strategies::BaseClass)
    def payment_command_builder_class=(builder_class)
      if builder_class
        @payment_command_builder_class = builder_class
      else
        raise "BillingLogic::Strategies::BaseClass is an abstract class. Please instantiate a concrete subclass."
      end
    end

    # Returns a string representing the commands the Strategy generates
    #
    # @return [String] the string representation of the commands the Strategy generates
    def command_list
      calculate_list
      @command_list.flatten
    end

    # Returns an array of BillingEngine::Client::Products to be added, grouped by date
    #
    # @return [Array]
    def products_to_be_added_grouped_by_date
      group_by_date(products_to_be_added)
    end

    # Returns an array of BillingEngine::Client::Products to be added because they're desired but not active
    # 
    # @return [Array<BillingEngine::Client::Product>] array of desired but inactive BillingEngine::Client::Products scheduled to be added
    def products_to_be_added
      desired_state.reject do |product|
        ProductComparator.new(product).in_like?(active_products)
      end
    end

    # Returns an array of BillingEngine::Client::Products to be removed because they're active but not desired
    # 
    # @return [Array<BillingEngine::Client::Product>] array of active but no longer desired BillingEngine::Client::Products scheduled for removal
    def products_to_be_removed
      active_products.reject do |product|
        ProductComparator.new(product).included?(desired_state)
      end
    end

    # Returns an array of inactive BillingEngine::Client::Products in the CurrentState
    #
    # @return [Array<BillingEngine::Client::Product>] array of inactive BillingEngine::Client::Products in the CurrentState
    def inactive_products
      neither_active_nor_pending_profiles.map { |profile| profile.products }.flatten
    end

    # Returns an array of PaymentProfiles with profile_status 'ActiveProfile' or 'PendingProfile'
    #
    # @return [Array<PaymentProfile>]
    def active_profiles
      active_or_pending_profiles
    end

    # Returns an array of active BillingEngine::Client::Products from the CurrentState
    #
    # @return [Array<BillingEngine::Client::Product>] array of active BillingEngine::Client::Products in the CurrentState
    def active_products
      current_state.active_products
    end

    # CurrentState PaymentProfiles with payment_profile of 'ActiveProfile' or 'PendingProfile'
    #
    # @return [Array<PaymentProfile>] array of all 'ActiveProfile' or 'PendingProfile' PaymentProfiles
    #   for the CurrentState
    def active_or_pending_profiles
      current_state.reject { |profile| !profile.active_or_pending }
    end

    # CurrentState PaymentProfiles with payment_profile of neither 'ActiveProfile' nor 'PendingProfile' (i.e., either
    # 'CancelledProfile' or 'ComplimentaryProfile')
    #
    # @return [Array<PaymentProfile>] array of all PaymentProfiles for the CurrentState with payment_profile of neither 
    # 'ActiveProfile' nor 'PendingProfile'
    def neither_active_nor_pending_profiles
      current_state.reject { |profile| profile.active_or_pending }
    end

    # @deprecated Too confusing. Please call either #active_or_pending_profiles or #neither_active_nor_pending_profiles
    def profiles_by_status(active_or_pending = nil)
      current_state.reject { |profile| !profile.active_or_pending? == active_or_pending}
    end

    protected

    def default_command_builder
      BillingLogic::CommandBuilders::BasicBuilder
    end

    def removed_obsolete_subscriptions(subscriptions)
      [subscriptions.select{ |sub| sub.active_or_pending? } + subscriptions.reject { |sub| !sub.paid_until_date || sub.paid_until_date < today } ].flatten.compact.uniq
    end

    def calculate_list
      reset_command_list!
      add_commands_for_products_to_be_added!
      add_commands_for_products_to_be_removed!
    end

    # NOTE: This method is the most likely to be have different implementations in
    # each strategy.
    # @return [nil]
    def add_commands_for_products_to_be_added!
      raise "Called BaseStrategy#add_commands_for_products_to_be_added!"
    end

    # this doesn't feel like it should be here
    def group_by_date(new_products)
      group = {}
      new_products.each do |product|
        date = nil
        if previously_cancelled_product?(product)
          date = next_payment_date_from_profile_with_product(product, :active => false)
        elsif (previous_product = changed_product_subscription?(product))
          update_product_billing_cycle_and_payment!(product, previous_product)
          date = next_payment_date_from_product(product, previous_product)
        end
        date = (date.nil? || date < today) ? today : date
        group[date] ||= []
        group[date] << product
      end
      group.map { |k, v| [v, k] }
    end

    def previously_cancelled_product?(product)
      inactive_products.detect do |inactive_product|
        ProductComparator.new(inactive_product).same_class?(product)
      end
    end

    def changed_product_subscription?(product)
      products_to_be_removed.detect do |removed_product|
        ProductComparator.new(removed_product).same_class?(product)
      end
    end

    def next_payment_date_from_profile_with_product(product, opts = {:active => false})
      profiles = opts[:active] ? active_or_pending_profiles : neither_active_nor_pending_profiles
      profiles.map do |profile|
        profile.paid_until_date if ProductComparator.new(product).in_class_of?(profile.products)
      end.compact.max
    end

    def update_product_billing_cycle_and_payment!(product, previous_product)
      if product.billing_cycle.periodicity > previous_product.billing_cycle.periodicity
        product.initial_payment = product.price
        product.billing_cycle.anniversary = previous_product.billing_cycle.anniversary
      end
    end

    def next_payment_date_from_product(product, previous_product)
      if product.billing_cycle.periodicity > previous_product.billing_cycle.periodicity
        product.billing_cycle.next_payment_date
      else
        product.billing_cycle.anniversary = next_payment_date_from_profile_with_product(product, :active => true)
      end
    end

    # for easy stubbing/subclassing/replacement
    def today
      Date.current
    end

    public
    # this should be part of a separate strategy object
    def add_commands_for_products_to_be_removed!
      active_profiles.each do |profile|

        # We need to issue refunds before cancelling profiles
        refund_options = issue_refunds_if_necessary(profile)
        remaining_products = remaining_products_after_product_removal_from_profile(profile)

        if remaining_products.empty? # all products in payment profile needs to be removed

          @command_list << cancel_recurring_payment_command(profile, refund_options)

        elsif remaining_products.size == profile.products.size # nothing has changed
          #
          # do nothing
          #
        else  # only some products are being removed and the profile needs to be updated

          if remaining_products.size >= 1

            @command_list << remove_product_from_payment_profile(profile.identifier,
                                                                 removed_products_from_profile(profile),
                                                                 refund_options)
          else

            @command_list << cancel_recurring_payment_command(profile, refund_options)
            @command_list << create_recurring_payment_command(remaining_products,
                                                              :paid_until_date => profile.paid_until_date,
                                                              :period => extract_period_from_product_list(remaining_products))
          end
        end
      end
    end

    def extract_period_from_product_list(products)
      products.first.billing_cycle.period
    end

    def remaining_products_after_product_removal_from_profile(profile)
      profile.active_products.reject { |product| products_to_be_removed.include?(product) }
    end

    def removed_products_from_profile(profile)
      profile.products.select { |product| products_to_be_removed.include?(product) }
    end

    def issue_refunds_if_necessary(profile)
      ret = {}
      unless profile.refundable_payment_amount(removed_products_from_profile(profile)).zero?
        ret.merge!(refund_recurring_payments_command(profile.identifier, profile.refundable_payment_amount(removed_products_from_profile(profile))))
        ret.merge!(disable_subscription(profile.identifier))
      end
      ret
    end

    def refund_recurring_payments_command(profile_id, amount)
      { :refund => amount, :profile_id => profile_id }
    end

    def disable_subscription(profile_id)
      { :disable => true }
    end

    # these messages seems like they should be pluggable
    def cancel_recurring_payment_command(profile, opts = {})
      payment_command_builder_class.cancel_recurring_payment_commands(profile, opts)
    end

    def remove_product_from_payment_profile(profile_id, removed_products, opts = {})
      payment_command_builder_class.remove_product_from_payment_profile(profile_id, removed_products, opts)
    end

    def create_recurring_payment_command(products, opts = {:paid_until_date => Date.current})
      payment_command_builder_class.create_recurring_payment_commands(products, opts)
    end

    def with_products_to_be_added(&block)
      unless (products_to_be_added = products_to_be_added_grouped_by_date).empty?
        products_to_be_added.each do |group_of_products, date|
          yield(group_of_products, date)
        end
      end
    end

    class ProductComparator
      extend Forwardable
      def_delegators :@product, :name, :price, :billing_cycle
      def initialize(product)
        @product = product
      end

      def included?(product_list)
        product_list.any? { |product| ProductComparator.new(product).similar?(self) }
      end

      def in_class_of?(product_list)
        product_list.any? { |product| ProductComparator.new(product).same_class?(self) }
      end

      def in_like?(product_list)
        product_list.any? { |product| ProductComparator.new(product).like?(self) }
      end

      def like?(other_product)
        similar?(other_product) && same_periodicity?(other_product)
      end

      def similar?(other_product)
        same_class?(other_product) &&  same_price?(other_product)
      end

      def same_periodicity?(other_product)
        @product.billing_cycle.periodicity == other_product.billing_cycle.periodicity
      end

      def same_class?(other_product)
        @product.name == other_product.name
      end

      def same_price?(other_product)
        BigDecimal(@product.price.to_s) == BigDecimal(other_product.price.to_s)
      end

    end

    def reset_command_list!
      @command_list.clear
    end

  end
end
