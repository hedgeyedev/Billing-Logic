require 'spec_helper'
require 'awesome_print'
require 'active_support/all'
require 'timecop'

describe BillingLogic::CommandBuilders::ActionObject do

  before do
    Time.zone = "Eastern Time (US & Canada)"
  end

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

  it "recognizes a valid command to add a product on a future date" do
    fake_time = Time.zone.local(2012, 3, 3, 12, 0, 0)
    Timecop.travel(fake_time)
    command = "cancel [(A @ $30/mo) @ $30/mo] now, add (B @ $300/yr) @ $300.00/yr on 03/10/12"
    ap BillingLogic::CommandBuilders::ActionObject.from_string(command)
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "recognizes a valid command to cancel a product and add a different project" do
    fake_time = Time.zone.local(2012, 3, 3, 12, 0, 0)
    Timecop.travel(fake_time)
    command = "cancel [(A @ $30/mo) @ $30/mo] now, add (B @ $300/yr) @ $300.00/yr now"
    ap BillingLogic::CommandBuilders::ActionObject.from_string(command)
    BillingLogic::CommandBuilders::ActionObject.from_string(command).to_s.should == command
  end

  it "recognizes a valid command to cancel one product and add another in the future" do
    fake_time = Time.zone.local(2012, 3, 3, 12, 0, 0)
    Timecop.travel(fake_time)
    command = "cancel [(A @ $30/mo) @ $30/mo] now, add (B @ $300/yr) @ $300.00/yr on 03/10/12"
    ap BillingLogic::CommandBuilders::ActionObject.from_string(command)
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

