require 'spec_helper'
require 'active_support/values/time_zone'
require 'active_support/core_ext/time/calculations'
require 'active_support/time_with_zone'

Time.zone = "Eastern Time (US & Canada)"

describe BillingLogic::CommandBuilders::ActionObject do
  it "recognizes a valid command to remove products" do
    command = "remove (B @ $20/mo & C @ $20/mo) from [(A @ $30/mo & B @ $20/mo & C @ $20/mo) @ $70/mo] now"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "recognizes a valid command to add a product" do
    command = "add (B @ $20/mo & C @ $20/mo) @ $40.00/mo now"
    translated_command = command.gsub("now", "on ") + Time.zone.now.strftime('%m/%d/%y')
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == translated_command
  end

  it "recognizes a valid command to cancel a product" do
    command = "cancel [A @ $30/mo] now"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "recognizes a valid command to cancel two products" do
    command = "cancel [A @ $30/mo] now, cancel [B @ $20/mo] now"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "expects you to pass in 'from [...]' when removing a product" do
    command = "remove (B @ $20/mo & C @ $20/mo) now"
    translated_command = command.sub("now","from [] now")
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == translated_command
  end

end

