# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wappalyzer_rb/version"

Gem::Specification.new do |s|
  s.name        = "wappalyzer_rb"
  s.version     = WappalyzerRb::VERSION
  s.authors     = ["Kostas Karachalios"]
  s.email       = ["kostas.karachalios@me.com"]
  s.homepage    = "https://github.com/vrinek/wappalyzer-ruby"
  s.summary     = %q{Analyzes a provided url and returns any services it can detect}
  s.description = %q{This is merely a port of the javascript parts of Wappalyzer extension for Firefox and Chrome}

  s.rubyforge_project = "wappalyzer_rb"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  # s.add_runtime_dependency "rest-client"
end
