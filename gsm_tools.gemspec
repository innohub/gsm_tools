# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gsm_tools/version"

Gem::Specification.new do |s|
  s.name        = "gsm_tools"
  s.version     = GsmTools::VERSION
  s.authors     = ["Andrew Ang"]
  s.email       = ["andukz@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{GSM 03.38 extension libraries}
  s.description = %q{Adds various methods to check GSM 03.38 character encoding compatibility.}

  s.rubyforge_project = "gsm_tools"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"

  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
end
