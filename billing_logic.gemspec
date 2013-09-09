# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "billing_logic/version"

Gem::Specification.new do |s|
  s.name        = "billing_logic"
  s.version     = BillingLogic::VERSION
  s.authors     = ["Diego Scataglini"]
  s.email       = ["diego@junivi.com"]
  s.homepage    = ""
  s.summary     = %q{The only recurring billing logic you'll need}
  s.description = %q{There are only a few way to calculate prorations & manage recurring payments.}

  s.rubyforge_project = "billing_logic"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency("activesupport", '~> 3.2')

  # because activesupport forgot to require tzinfo
  # see https://github.com/rails/rails/issues/4909
  # can remove once we upgrade activesupport
  s.add_development_dependency("tzinfo")

  s.add_development_dependency("awesome_print")
  s.add_development_dependency("rspec", '~> 2.12')
  s.add_development_dependency('rake', '~> 10.0')
  s.add_development_dependency('cucumber', '~> 1.2')
  s.add_development_dependency('timecop', '~> 0.5')
  s.add_development_dependency('guard', '~> 1.6')
  s.add_development_dependency('guard-rspec', '~> 2.4')
  s.add_development_dependency('guard-cucumber', '~> 1.3')
  s.add_development_dependency('yard')
end
