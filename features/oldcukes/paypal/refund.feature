Feature: Refund under different error scenarios
  As a product manager
  I would like for the billing engine to be robust in its handling of PayPal error conditions
  So that less developer time is spent manually correcting errors and the subscriber has a better experience

  Scenario: Subscriber changes credit card, then changes Pro subscription and is issued refund.
    Presently this is a bug that should be addressed in https://www.pivotaltracker.com/story/show/27034067.
    The bug manifested itself as described here: https://www.pivotaltracker.com/story/show/28914007.
    The following steps show the sequence.  The bug is that presently CMS applies the refund to the
    most recent IPN ('Y') which fails because 'Y' has no payment to apply the refund to.
    Given that a subscriber, Fido, exists
    And he has a subscription to pro product A at $50/mo
    When PayPal receives a $50 payment for his subscription to A
    Then it applies this to his existing 'X' IPN
    When Fido changes his credit card halfway through his subscription to A
    Then PayPal creates a new IPN, 'Y' for Fido
    And it cancels his 'X' IPN
    And it does not change the end of the subscription date
    When PayPal does not charge Fido's credit card for the credit card change
    Then there is no payment history for IPN 'Y'
    When at 3/5 the time into Fido's subscription for A, he changes his subscription to pro product B at $75/mo
    Then PayPal refunds Fido's credit card $20 for the remainder of his A subscription
    And it applies the refund to his 'X' IPN because it has a payment to refund against
    But it does not apply the refund to his 'Y' IPN even though it is more recent
