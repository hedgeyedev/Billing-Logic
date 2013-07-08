Given /^I have the following subscriptions:$/ do |table|
  # table is a Cucumber::Ast::Table
  profiles =  table.raw.map do |row|
    paid_until_date = str_to_date(row[3])
    products = str_to_product_formatting(row[0])
    products.each { |product| product.billing_cycle.anniversary = paid_until_date}
    billing_cycle = str_to_billing_cycle(row[0], paid_until_date)
    active_or_pending = row[1] =~ /active/
    ostruct = OpenStruct.new(
               :identifier => row[0],
               :products =>  products,
               :current_products => (paid_until_date >= Date.current) ? products : [],
               :active_products => active_or_pending ? products : [],
               :paid_until_date =>  paid_until_date,
               :billing_cycle => billing_cycle,
               :active_or_pending? => active_or_pending ,
              )
    def ostruct.refundable_payment_amount(foo)
      @refundable_payment_amount || 0.0
    end
    ostruct
  end
  strategy.current_state = BillingLogic::CurrentState.new(profiles)
end

When /^I change to having: (nothing|.*)$/ do |products|
  strategy.desired_state = products == 'nothing' ? [] : products
end
