# https://www.pivotaltracker.com/story/show/27194523
# billing engine
Feature: Determine ordinal day of a month or year from now
  As a marketing manager
  I want to charge a subscriber's credit card on the day that a subscriber expects
  So that the subscriber won't feel ripped off

  Scenario: Subscriber is Charged Every Month
    When a the subscriber's credit card is charged
    Then his next payment will occur on PayPal's "next billing date"

  Scenario: Subscriber is Charged Every Year
    When a the subscriber's credit card is charged
    Then his next payment will occur on PayPal's "next billing date"

