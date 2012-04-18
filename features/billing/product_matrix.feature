@wip
Feature: Product Matrix

  Scenario: Mass Market Product Lineup
    When the subscriber is mass market
    Then he can add any combination of products in the table:
      | RTSA |
      | WHI  |
      | MN   |

  Scenario: Pro Product Lineup
    When the subscriber is professional
    Then he can add only one of the products in the table in a monthly or yearly subscription as indicated:
      | Product | Subscription length |
      | HRM     | mo or yr            |
      | Pro     | mo or yr            |

  Scenario Outline: Grandfathered Pro Subscriber
    When the subscriber has <existing> products
    Then he can replace his existing products with <replace> or he can obtain a mass market subscription
  Examples:
    | existing | replace       |
    | HRM-mo   | HRM-yr        |
    | HRM-yr   | HRM-mo        |
    | M22      | HRM-yr HRM-mo |
    | M40      | HRM-yr HRM-mo |
    | HI-mo    | HRM-yr HRM-mo |
    | HI-yr    | HRM-yr HRM-mo |

