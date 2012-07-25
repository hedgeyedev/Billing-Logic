Given /^this scenario where\s+(.*)\s+last payment date$/ do | time_category |
  pending # express the regexp above with the code you wish you had
end

And /^the subscriber is subscribed to product A for\s+(\$(\d+))\/(month|year)$/ do |prev_bill, period|
  pending # express the regexp above with the code you wish you had
end

And /^A is eligible for proration$/ do
  pending # express the regexp above with the code you wish you had
end

And /^his last payment was on (\w{3}) (\d+), (\d+)$/ do |month_abbrev, day, year|
  pending # express the regexp above with the code you wish you had
end

And /^today is (\w{3}) (\d+)$/ do |month_abbrev, day|
  pending # express the regexp above with the code you wish you had
end

When /^the subscriber cancels A$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^his prorated amount is \$\s*(\d+\.\d+)$/ do |amount|
  pending # express the regexp above with the code you wish you had
end

When /^a subscriber adds and cancels one or more products within the same session$/ do
  pending # express the regexp above with the code you wish you had
end

And /^he commits his requests$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^perform the add subscriptions first$/ do
  pending # express the regexp above with the code you wish you had
end

And /^then perform the cancellations$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^a subscriber chooses to cancel a subscription$/ do
  pending # express the regexp above with the code you wish you had
end

And /^subscribe to a product with a different price$/ do
  pending # express the regexp above with the code you wish you had
end

And /^commits the request$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the system calculates the value of the remaining days on the cancelled subscription$/ do
  pending # express the regexp above with the code you wish you had
end

And /^it calculates how many days that value would purchase on the new subscription$/ do
  pending # express the regexp above with the code you wish you had
end

And /^it adds that many days to the new subscription$/ do
  pending # express the regexp above with the code you wish you had
end

And /^it generates the added subscription with the extended time period$/ do
  pending # express the regexp above with the code you wish you had
end

And /^it sets the next billing date to the end of the extended time period$/ do
  pending # express the regexp above with the code you wish you had
end

And /^it immediately removes access to the cancelled subscription$/ do
  pending # express the regexp above with the code you wish you had
end

And /^it subtracts that amount from the cost of the new subscription$/ do
  pending # express the regexp above with the code you wish you had
end

And /^it subtracts the cost of the added subscription from that value because the value is more than the cost of the added subscription$/ do
  pending # express the regexp above with the code you wish you had
end

And /^it calculates how many days the new value would purchase on the added subscription$/ do
  pending # express the regexp above with the code you wish you had
end

And /^it adds that many days to the added subscription$/ do
  pending # express the regexp above with the code you wish you had
end
