Feature: Subscription Failure
  As a product manager
  I would like for failure during subscriptions to preserve adds and avoid cancellations
  So that subscribers don't miss the features they desire and Hedgeye maximizes revenue

# No Pivotal card
# billing engine or logic

  Scenario: Cancellation fails after add operations - retry
    Given a subscriber has committed his add and cancellation requests
    And all of the affected subscriptions have the same price
    When the adds have been added successfully
    But one of the cancellations fails
    Then inform the subscriber that his subscriptions have been successfully added
    And it informs him which cancellations succeeded
    But the failed cancellation happened and instructions on what to do next

# No Pivotal card
# billing engine or logic

  Scenario: Add operation fails before Cancellations
    Given a subscriber has committed his add and cancellation requests
    And all of the affected subscriptions have the same price
    When the system processes the adds
    And one of the adds fails
    Then the system continues with the remaining adds that it hasn't processed yet
    And it does NOT process any of the cancellations
    And it informs the subscriber which adds succeeded
    And it has not performed any of the cancellations
    And instructions on what to do next

  # This adapts the first scenario above to the existing Diego step-definitions and implementation
  Scenario Outline: Cancellation fails after add operations - retry
    Given I support Independent Payment Strategy
    And   Today is 3/15/12
    And   the subscriber has the following subscriptions:
    #| product names | status    | comments                                                 | next billing date |
      | A @ $30/mo | active    | with current permissions and the next billing date is on | 4/1/12  |
      | B @ $20/mo | active    | with current permissions and the next billing date is on | 4/20/12 |
      | C @ $50/yr | cancelled | with permissions expiring in the future on               | 4/25/12 |
      | F @ $10/mo | cancelled | with permissions expiring today                          | 3/15/12 |
      | G @ $15/mo | cancelled | with permissions expired in the past on                  | 3/13/12 |
    When  he changes to having: <desired state>
    And Paypal fails while attempting to <failing action>
    Then  the system should report <state>
    And it should
  Examples: Removing all products
    | desired state | failing action        | state              |
    | B @ $20/mo    | cancel A @ $30/mo now | failed to cancel A |
