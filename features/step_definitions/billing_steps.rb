
Given /^(?:the subscriber|he|she)\s+has\s+(.*)\s+product(?:s?)$/ do | existing_subscriptions |
  pending # express the regexp above with the code you wish you had
end

When /^(?:the subscriber|he|she)\s+attempts to add\s+(.*)\s+and cancel\s+(.*)$/ do |to_add, to_cancels |
  pending # express the regexp above with the code you wish you had
end

And /^(?:the system|it)\s+informs the subscriber that the\s+(.*)\s+is unavailable$/ do | unavailable_system |
  pending # express the regexp above with the code you wish you had
end

And /^(?:the system|it)\s+instructs the subscriber to contact customer service$/ do
  pending # express the regexp above with the code you wish you had
end

And /^(?:the system|it)\s+(successfully|attempts to)\s+(add|adds|cancel|cancels|\<action\>)\s+(.*)$/ do | whether_successful, action,
    subscriptions |
  pending # express the regexp above with the code you wish you had
end

When /^(.*)\s+fails\s*(.*)$/ do | service, operation |
  pending # express the regexp above with the code you wish you had
end

And /^(?:the system|it)\s+has cancelled subscriptions\s+(.*)$/ do | system, subscriptions |
  pending # express the regexp above with the code you wish you had
end

And /^(?:the system|it)\s+has subscribed to\s+(.*)$/ do | system, subscriptions |
  pending # express the regexp above with the code you wish you had
end

Given /^that the subscriber is in the process of adding and cancelling subscriptions$/ do
  pending # express the regexp above with the code you wish you had
end

When /^(.*)\s+fails during one of the subscription operations$/ do | service |
  pending # express the regexp above with the code you wish you had
end

Then /^(?:the subscriber|he|she)\s+can replace his existing products with\s+(.*)$/ do | replacement_products |
  pending # express the regexp above with the code you wish you had
end

And /^he can add\s+(.*)\s+products$/ do | added_products |
  pending # express the regexp above with the code you wish you had
end

And /^the\s+(.*)\s+(?:product|products) (?:is|are)\s+(.*)/ do | products, action |
  pending # express the regexp above with the code you wish you had
end

Then /^(?:the system|it)\s+cancels the non\-PayPal aspects of\s+(.*)\s+anyways$/ do | products |
  pending # express the regexp above with the code you wish you had
end

