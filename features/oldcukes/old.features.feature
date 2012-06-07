@wip
Feature: forgotten functionality
  As a business analyst
  I would like for collaborated-upon business rules to not be forgotten
  So that we don't lose hard-won knowledge

  These are from the early days; making sure that these are (or are not) still relevant

# https://www.pivotaltracker.com/story/show/27041927
# belongs to Billing Engine
  Scenario: subscriber with current products
    Given that I'm on the account setting page
    When I add/remove/update a product
    Then all outstanding products are updated with the newly submitted credit card

# https://www.pivotaltracker.com/story/show/27042017
# belongs to Billing Engine
  Scenario: Cancel Subscription
    When the subscriber cancels one or more products
    Then the system cancels the payment profile for each product
    And it updates each product's corresponding hedgeye accesses' end date to the profile's next payment date - 1 day
