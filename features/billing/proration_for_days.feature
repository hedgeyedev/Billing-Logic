# https://www.pivotaltracker.com/story/show/27626017
Feature: Calculate the Proration Amount
  As a marketing manager
  I want for existing customer to be encouraged to subscribe to new products
  when he cancels
  So that the customer gets more services
  and our organization gets more revenue

# No Pivotal card
# billing logic
  Scenario Outline: User Cancels Subscription
    Given this scenario where <time category> last payment date
    And the subscriber is subscribed to product A for <prev bill>/<period>
    And A is eligible for proration
    And his last payment was on <last pymt date>
    And today is Mar 15
    When the subscriber cancels A
    Then his prorated amount is <amount>
  Examples:
    | time category                 | last pymt date | prev bill | period | amount  |
    | user cancels in same month as | Mar 10, 2012   | $45       | month  | $  7.50 |
    | user cancels in month after   | Feb 20, 2012   | $45       | month  | $ 36.00 |
    | user cancels on same day as   | Mar 15, 2012   | $45       | month  | $  0.00 |
    | user cancels in same year as  | Jan 10, 2012   | $450      | year   | $ 80.14 |
    | user cancels in year after    | Apr 20, 2011   | $450      | year   | $406.85 |
    | user cancels on same day as   | Mar 15, 2012   | $450      | year   | $  0.00 |

# No Pivotal card
# billing engine or logic
  Scenario: Perform Adds Before Cancellations
    When a subscriber adds and cancels one or more products within the same session
    And he commits his requests
    Then perform the add subscriptions first
    And then perform the cancellations

# No Pivotal card
# billing engine or logic
  Scenario: Cancellation fails after add operations - retry
    Given a subscriber has committed his request some adds and cancellations
    And all of the affected subscriptions have the same price
    When the adds have been added successfully
    But one of the cancellations fails
    Then inform the subscriber that his subscriptions have been successfully added
    And inform him which cancellations succeeded
    But that the failed cancellation happened and instructions on what to do next

# No Pivotal card
# billing engine or logic
  Scenario: Add operation fails before Cancellations
    Given a subscriber has committed his request some adds and cancellations
    And all of the affected subscriptions have the same price
    When the system processes all of the adds
    And one of the adds fails
    Then the system continues with the remaining adds that it hasn't processed yet
    And it does NOT process any of the cancellations
    And inform the subscriber which adds succeeded
    And that it has not performed any of the cancellations
    And instructions on what to do next

# No Pivotal card
# billing engine or logic
  Scenario: User Cancels Pro Product and Adds Different Pro Product with different price - Append Time
    Given a subscriber chooses to cancel a subscription
    And subscribe to a product with a different price
    And commits the request
    Then the system calculates the value of the remaining days on the cancelled subscription
    And it calculates how many days that value would purchase on the new subscription
    And it adds that many days to the new subscription
    And it generates the added subscription with the extended time period
    And it sets the next billing date to the end of the extended time period
    And it immediately removes access to the cancelled subscription

  Scenario: User Cancels Pro Product and Adds Different Pro Product with different price - Reduce Price
    Given a subscriber chooses to cancel a subscription
    And subscribe to a product with a different price
    And commits the request
    Then the system calculates the value of the remaining days on the cancelled subscription
    And it subtracts that amount from the cost of the new subscription
    And it immediately removes access to the cancelled subscription

  Scenario: User Cancels Pro Product and Adds Different Pro Product with different price - Reduce Price and Extend Time
    Given a subscriber chooses to cancel a subscription
    And subscribe to a product with a different price
    And commits the request
    Then the system calculates the value of the remaining days on the cancelled subscription
    And it subtracts the cost of the added subscription from that value because the value is more than the cost of the added subscription
    And it calculates how many days the new value would purchase on the added subscription
    And it adds that many days to the added subscription
    And it generates the added subscription with the extended time period
    And it sets the next billing date to the end of the extended time period
    And it immediately removes access to the cancelled subscription
