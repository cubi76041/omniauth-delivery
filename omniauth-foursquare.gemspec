# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-delivery/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-delivery"
  s.version     = Omniauth::Delivery::VERSION
  s.authors     = ["Hoai Ngo"]
  s.email       = ["heochoat76041@gmail.com"]
  s.homepage    = "https://github.com/cubi76041/omniauth-delivery"
  s.summary     = %q{Delivery.com OAuth strategy for OmniAuth}
  s.description = %q{Delivery.com OAuth strategy for OmniAuth}

  s.rubyforge_project = "omniauth-delivery"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'omniauth', '~> 1.0'
  s.add_dependency 'omniauth-oauth2', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 2.7'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
end
