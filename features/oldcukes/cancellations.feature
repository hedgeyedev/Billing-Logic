# probably Billing Logic
@wip
Feature: Cancellation Policy
  As a subscription provider
  I want my customers to be able to switch between plans without overcharging them when making multiple changes on the same day.

  @duplicate
  Scenario: User subscribes, then cancels withing the grace period
    Note that this is a duplicate of what same_day_cancellation_policy.feature already tests
    Given an available product, A, priced @ $30/monthly
    And we allow full refunds on same day cancellations
    And a customer named beta
    When beta subscribes to A on 1/1
    Then beta get charged $30
    And beta has access to plan A till the end of the month
    When later that day beta cancels A
    Then beta is refunded $30
    And all of beta’s access is revoked immediately

  @duplicate
  Scenario: User subscribes to two products, then cancels one of them within the grace period
    Note that this is a duplicate of what independent_payment_strategy.feature already tests
    Given a user beta
    And an available product, A, priced @ $30/monthly
    And an available product, B, priced @ $35/monthly
    When beta subscribes to A
    Then beta is charged $30 for A
    And beta has access to A for a month
    When beta subscribes to B
    Then beta is charged $35 for B
    And beta has access to B for a month
    And there is not change to his subscription A
    When beta cancels A
    Then beta's credit card is credited $30
    And beta immediately loses access to A
    And there is no change to his subscription to B

  @duplicate
  Scenario: User subscribes and doesn't cancel
    Duplicated with same_day_cancellation_policy.feature scenario "Creating a new recurring payment profile"
    except that the renewal is not tested there.  Not sure that isn't already existing functionality
    so not sure this has high priority.
    Given a user beta
    And an available product, A, priced @ $30/monthly
    When beta subscribes to A
    Then beta is charged $30 for A
    And beta has access to A for a month
    When a month passes
    Then beta is charged $30 for A again
    And beta has access to A for the new month

  @duplicate
  Scenario: User subscribes, then cancels after the grace period
    Note that this is a duplicate of what same_day_cancellation_policy.feature already tests
    Given a user beta
    And an available product, A, priced @ $30/monthly
    When beta subscribes to A
    Then beta is charged $30 for A
    And beta has access to A for a month
    When the grace period to cancel this subscription passes
    And then beta cancels his subscription
    Then his access to A continues to until the next billing day
    And he will not be charged for this subscription again.
