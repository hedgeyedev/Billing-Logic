require 'spec_helper'

describe BillingLogic::CommandBuilders::ActionObject do

  before do
    Time.zone = "Eastern Time (US & Canada)"
  end

  it "removes two products from a bundle with one payment profile" do
    command = "remove (B @ $20/mo & C @ $20/mo) from [(A @ $30/mo & B @ $20/mo & C @ $20/mo) @ $70/mo] now"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "adds two new products" do
    command = "add (B @ $20/mo & C @ $20/mo) @ $40.00/mo now"
    translated_command = command.gsub("now", "on ") + Time.zone.now.strftime('%m/%d/%y')
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == translated_command
  end

  it "cancels a product" do
    command = "cancel [A @ $30/mo] now"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "cancels a product that is also a bundle (indicated by parentheses)" do
    command = "cancel [(A @ $30/mo) @ $30/mo] now"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "adds a product on a future date" do
    command = "add (B @ $300/yr) @ $300.00/yr on 03/10/12"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "cancels and disables a product" do
    command = "cancel and disable [(A @ $30/mo & B @ $40/mo & C @ $25/mo) @ $95/mo] with refund $30.00 now"
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "expects you to pass in 'from [...]' when removing a product" do
    command = "remove (B @ $20/mo & C @ $20/mo) now"
    translated_command = command.sub("now","from [] now")
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == translated_command
  end

end

