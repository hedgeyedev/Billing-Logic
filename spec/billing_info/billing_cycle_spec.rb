require 'spec_helper'
require 'active_support/all'
require 'timecop'

describe BillingLogic::BillingCycle do
  context "a billing cycle" do
    before do 
      @cycle_45_days      = BillingLogic::BillingCycle.new(:period => :day,       :frequency => 45)
      @one_day_cycle      = BillingLogic::BillingCycle.new(:period => :day,       :frequency => 1)
      @one_week_cycle     = BillingLogic::BillingCycle.new(:period => :week,      :frequency => 1)
      @semimonth_cycle    = BillingLogic::BillingCycle.new(:period => :semimonth, :frequency => 1)
      @one_month_cycle    = BillingLogic::BillingCycle.new(:period => :month,     :frequency => 1)
      @one_year_cycle     = BillingLogic::BillingCycle.new(:period => :year,      :frequency => 1)
    end

    it "should know about its period type" do
      @cycle_45_days.period.should == :day
    end

    it "should know about its frequency" do
      @cycle_45_days.frequency.should == 45
    end

    it "should be able to calculate its periodicity" do
      @cycle_45_days.periodicity.should == 45
      @one_year_cycle.periodicity.should == 365
    end

    it "should know how to compare itself" do
      @one_day_cycle.should   < @one_week_cycle
      @one_week_cycle.should  < @semimonth_cycle
      @semimonth_cycle.should < @one_month_cycle
      @one_month_cycle.should < @cycle_45_days
      @cycle_45_days.should   < @one_year_cycle 
    end
  end

  context "a billing cycle with anniversary" do

    before do
      Time.zone = "Eastern Time (US & Canada)"
      @noon_on_may_27 = Time.zone.local(2013,5,27,12,0,0)
      Timecop.travel(@noon_on_may_27)
    end

    context "anniversary is today" do
      before do
        @cycle_starting_today = BillingLogic::BillingCycle.new(:period => :month,
                                                               :frequency => 1,
                                                               :anniversary => @noon_on_may_27.to_date)
      end

      it "correctly calculates future anniversary dates" do
        @noon_on_june_27 = Time.zone.local(2013,6,27,12,0,0)
        @cycle_starting_today.closest_future_anniversary_date_including(@noon_on_may_27.to_date).should == @noon_on_june_27.to_date
      end

    end

    context "anniversary is exactly two cycles ago" do
      before do
        @noon_on_july_27 = Time.zone.local(2013,7,27,12,0,0)
        @cycle_starting_today = BillingLogic::BillingCycle.new(:period => :month,
                                                               :frequency => 1,
                                                               :anniversary => @noon_on_july_27.to_date)
      end

      it "correctly calculates future anniversary dates" do
        @noon_on_june_27 = Time.zone.local(2013,6,27,12,0,0)
        @cycle_starting_today.closest_future_anniversary_date_including(@noon_on_may_27.to_date).should == @noon_on_june_27.to_date
      end

    end

    context "anniversary is tomorrow" do
      before do
        @noon_on_may_28 = Time.zone.local(2013,5,28,12,0,0)
        @cycle_starting_tomorrow = BillingLogic::BillingCycle.new(:period => :month,
                                                               :frequency => 1,
                                                               :anniversary => @noon_on_may_28.to_date)
      end

      it "correctly calculates future anniversary dates" do
        @cycle_starting_tomorrow.closest_future_anniversary_date_including(@noon_on_may_27.to_date).should == @noon_on_may_28.to_date
      end

    end

    context "anniversary was yesterday" do
      before do
        @noon_on_may_26 = Time.zone.local(2013,5,26,12,0,0)
        @noon_on_june_26 = Time.zone.local(2013,6,26,12,0,0)
        @cycle_starting_yesterday = BillingLogic::BillingCycle.new(:period => :month,
                                                                   :frequency => 1,
                                                                   :anniversary => @noon_on_may_26.to_date)
      end

      it "correctly calculates future anniversary dates" do
        @cycle_starting_yesterday.closest_future_anniversary_date_including(@noon_on_may_27.to_date).should == @noon_on_june_26.to_date
      end

    end

  end
end
