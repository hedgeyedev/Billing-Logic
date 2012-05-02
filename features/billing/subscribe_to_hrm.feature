# This is pulled from https://docs.google.com/document/d/1kVKCMFHcNYwTJjKMu5KcY00ioJOB0TLC3qGw7wNvqWk/edit
@wip
Feature: Subscribe to HRM
  As the director of product development
  In order to make the Hedgeye Risk Manager (HRM) product available for direct signup
  The existing HRM product will be re-introduced as a product for online subscription

  Scenario: New Subscriber Wants HRM
    When a prospect looks for a Professional product
    Then the following professional products are available:
      | HRM-Mo |
      | HRM-Yr |
    And the following mass market products are not available:
      | RTSA |
      | WHI  |
      | MN   |

  Scenario: New Subscriber Wants Mass Market
    When a prospect looks for Mass Market products
    Then the following mass market products are available:
      | RTSA |
      | WHI  |
      | MN   |
    And the following professional products are not available:
      | HRM-Mo |
      | HRM-Yr |

  Scenario Outline: Possible professional products paths
    Given I am subscribed to <current product>
    Then <valid upgrade products> are the a possible product changes
    And I expect to be charged
  Examples:
    | current product | valid upgrade products |
    | HI mo           | HRM-Mo HRM-Yr          |
    | HI yr           | HRM-Yr                 |
    | HRM-Mo          | HRM-Yr                 |
    | M22             | HRM-Mo HRM-Yr          |
    | M40             | HRM-Mo HRM-Yr          |

  Scenario Outline: Unavailable professional products paths
    Given I am subscribed to <current product>
    Then <invalid upgrade products> are NOT possible product changes
  Examples:
    | current product | invalid upgrade products |
    | HI yr           | HRM-Mo                   |









