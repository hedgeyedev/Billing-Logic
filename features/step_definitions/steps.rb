Then /^(?:|I )(#{ASSERTION})expect the following action: ((?:remove|add|cancel|disable|refund \$\d+ to) .*)$/ do |assertion, commands|
  puts "---------------------"
  ap commands
  puts "---------------------"
  commands.split(/, /).each do |command|
    command_list_should_include(command, assertion)
  end
end

Given /^I don't have any subscriptions$/ do
  strategy.current_state = BillingLogic::CurrentState.new([])
end

Given /^Today is (\d+\/\d+\/\d+)$/ do |date|
  Timecop.travel(Date.strptime(date, '%m/%d/%y'))
end

