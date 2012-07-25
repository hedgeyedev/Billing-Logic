# https://www.pivotaltracker.com/story/show/27313399
# billing engine
@wip
Feature: PayPal fails during mass market subscription changes
  As a product manager
  I want to make sure that
  if there's a failure during a change of subscriptions
  then the failure is handled in such a way that customer service can understands exactly what the outcome is
  and that the added subscriptions have the highest probability of being kept
  and that unprocessed cancelled subscriptions have the highest probability of being kept
  and that unchanged subscriptions persist
  So that the subscriber accomplishes acquiring the Hedgeye services that he wants
  and Hedgeye maximizes revenue

  Legend:
  MN  -> Morning Newsletter
  SA  -> Stock Alerts
  WHI -> Weekly Hot Ideas

  Scenario Outline: PayPal fails during mass market subscription change
    Given the subscriber has <existing> products
    When he attempts to add <to add> and cancel <to cancel>
    And the system successfully adds <added>
    And it successfully cancels <cancelled>
    And PayPal fails causing the system's <action> <target> attempt to fail
    And the <unchanged> products are left in place
    And the <cancelled> products are cancelled
    And the <added> products are added
    And it instructs the subscriber to contact customer service

  Examples:
    | existing | to add | to cancel | action | target | unchanged | cancelled | added  |
    | MN SA    | WHI    |           | add    | WHI    | MN SA     |           |        |
    | MN SA    | WHI    | MN        | cancel | MN     | MN SA     |           | WHI    |
    | MN SA    | WHI    | MN SA     | cancel | SA     | SA        | MN        | WHI    |
    | MN       | SA WHI |           | add    | WHI    | MN        |           | SA     |
    | MN       | SA WHI |           | add    | SA     | MN        |           |        |
    | MN       | SA WHI | MN        | cancel | MN     | MN        |           | SA WHI |

