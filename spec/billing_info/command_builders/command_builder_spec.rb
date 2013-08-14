require 'spec_helper'

describe BillingLogic::CommandBuilders::ActionObject do

  before do
    Time.zone = "Eastern Time (US & Canada)"
  end

  it "recognizes a valid command to remove products from a bundle" do
    # Remove two products from a bundle with one payment_profile
    command = "remove (B @ $20/mo & C @ $20/mo) from [(A @ $30/mo & B @ $20/mo & C @ $20/mo) @ $70/mo] now"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "recognizes a valid command to add two products" do
    command = "add (B @ $20/mo & C @ $20/mo) @ $40.00/mo now"
    translated_command = command.gsub("now", "on ") + Time.zone.now.strftime('%m/%d/%y')
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == translated_command
  end

  it "recognizes a valid command to cancel a product" do
    command = "cancel [A @ $30/mo] now"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "recognizes a valid command to cancel a product (with parens)" do
    # This is considered a bundle within Billing-Logic
    command = "cancel [(A @ $30/mo) @ $30/mo] now"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "recognizes a valid command to add a product on a future date" do
    command = "add (B @ $300/yr) @ $300.00/yr on 03/10/12"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "recognizes a valid command to cancel and disable a product" do
    command = "cancel and disable [(A @ $30/mo & B @ $40/mo & C @ $25/mo) @ $95/mo] with refund $30.00 now"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "expects you to pass in 'from [...]' when removing a product" do
    command = "remove (B @ $20/mo & C @ $20/mo) now"
    translated_command = command.sub("now","from [] now")
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == translated_command
  end

end

