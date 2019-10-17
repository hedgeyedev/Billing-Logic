Feature: Change of periodicity Policy on signup day
  As a service provider
  In order to provide a fair experience to the customers and not overcharging them when making multiple changes on the same day.
  I want to offer a grace period for for cancellation, during which I'll issue a refund even in case of change of periodicity

  Scenario Outline: User subscribes to a product, then changes periodicity to within the grace period
    Given I support <strategy>
    And   The cancellation grace period is of <grace period>
    And   Today is 3/15/12
    And   I have the following subscriptions:
     #| product names | status | comments                                                 | next billing date |
      | A @ $30/mo | active | and the next billing date is on | 4/15/12 | 3/15/12 |
      | B @ $99/yr | active | and the next billing date is on | 3/15/13 | 3/15/12 |
    And   I made the following payment: <payment made>
    When  I change to having: <desired state>
    Then  I expect the following action: <actions>
    Examples: A customer that have made a payment of $30 the same day of cancellation
      | strategy                     | grace period | payment made                                                            | desired state | actions                    |
      | Independent Payment Strategy | 24 hours     | paid $30 for A @ $30/mo on 3/15/12                                      | A @ $99/yr, B @ $99/yr       | cancel and disable [A @ $30/mo] with refund $30.00 now, add (A @ $99/yr) on 03/15/12 |
      | Independent Payment Strategy | 24 hours     | paid $30 for A @ $30/mo on 3/15/12                                      | A @ $30/mo, B @ $30/mo       | cancel and disable [B @ $99/yr] now, add (B @ $30/mo) on 03/15/12 |
      | Independent Payment Strategy | 24 hours     | paid $30 for A @ $30/mo on 3/15/12                                      | A @ $99/yr, B @ $30/mo       | cancel and disable [B @ $99/yr] now, cancel and disable [A @ $30/mo] with refund $30.00 now, add (A @ $99/yr) on 03/15/12, add (B @ $30/mo) on 03/15/12 |

      | Independent Payment Strategy | 24 hours     | paid $99 for B @ $99/yr on 3/15/12                                      | A @ $99/yr, B @ $99/yr    | cancel and disable [A @ $30/mo] now, add (A @ $99/yr) on 03/15/12 |
      | Independent Payment Strategy | 24 hours     | paid $99 for B @ $99/yr on 3/15/12                                      | A @ $30/mo, B @ $30/mo    | cancel and disable [B @ $99/yr] with refund $99.00 now, add (B @ $30/mo) on 03/15/12 |
      | Independent Payment Strategy | 24 hours     | paid $99 for B @ $99/yr on 3/15/12                                      | A @ $99/yr, B @ $30/mo    | cancel and disable [B @ $99/yr] with refund $99.00 now, cancel and disable [A @ $30/mo] now, add (A @ $99/yr) on 03/15/12, add (B @ $30/mo) on 03/15/12 |

      | Independent Payment Strategy | 24 hours     | paid $30 for A @ $30/mo on 3/15/12, paid $99 for B @ $99/yr on 3/15/12  | A @ $99/yr, B @ $99/yr    | cancel and disable [A @ $30/mo] with refund $30.00 now, add (A @ $99/yr) on 03/15/12 |
      | Independent Payment Strategy | 24 hours     | paid $30 for A @ $30/mo on 3/15/12, paid $99 for B @ $99/yr on 3/15/12  | A @ $30/mo, B @ $30/mo    | cancel and disable [B @ $99/yr] with refund $99.00 now, add (B @ $30/mo) on 03/15/12 |
      | Independent Payment Strategy | 24 hours     | paid $30 for A @ $30/mo on 3/15/12, paid $99 for B @ $99/yr on 3/15/12  | A @ $99/yr, B @ $30/mo    | cancel and disable [B @ $99/yr] with refund $99.00 now, cancel and disable [A @ $30/mo] with refund $30.00 now, add (A @ $99/yr) on 03/15/12, add (B @ $30/mo) on 03/15/12 |

      | Independent Payment Strategy | 24 hours     | none                                                                    | A @ $99/yr, B @ $99/yr    | cancel and disable [A @ $30/mo] now, add (A @ $99/yr) on 03/15/12 |
      | Independent Payment Strategy | 24 hours     | none                                                                    | A @ $30/mo, B @ $30/mo    | cancel and disable [B @ $99/yr] now, add (B @ $30/mo) on 03/15/12 |
      | Independent Payment Strategy | 24 hours     | none                                                                    | A @ $99/yr, B @ $30/mo    | cancel and disable [B @ $99/yr] now, cancel and disable [A @ $30/mo] now, add (A @ $99/yr) on 03/15/12, add (B @ $30/mo) on 03/15/12 |

