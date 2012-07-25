@wip @deferred
Feature: Customer Service Notification
  Defer until after DMQ2?

  As a customer service manager
  I want to automate the user communications with customer service
  So that labor is saved and the user has his problems addressed more quickly and effectively

  Scenario: Directing the user to customer service when an incident occurs
    When the system needs to notify customer server about an incident
    Then it will direct the subscriber to the existing contact link

  Scenario: Incident data needed by customer service when PayPal fails
    When the subscriber attempts to add products and cancel products
    And PayPal fails during one of the operations
    Then the system notifies customer service with the following data:
      | Contact information for the affected subscriber             |
      | The product's name that PayPal failed on                    |
      | The nature of the PayPal failure                            |
      | That the subscriber was attempting to cancel HI and add HRM |
      | Whether HRM has been added                                  |
      | Whether HI has been cancelled                               |

