@wip
Feature: Miscellaneous Subscription Flows

# https://www.pivotaltracker.com/story/show/27042017
# billing engine
  @ambigous
  Scenario: Cancel Subscription
    Ambiguous because it doesn't specify independent vs single payment
    Given that I'm logged in
    And I'm on the Subscription in the Account Settings page
    When I cancel one or more subscriptions
    Then my profile for the subscription is cancelled
    And my corresponding hedgeye accesses end dates are updated to profile next payment date - 1 day

# No Pivotal Card
  Scenario: Secret HRM Subscription
# link to Steve's page on this?
# mo
# yr

