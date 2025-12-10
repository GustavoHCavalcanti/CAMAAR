# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "saikuro/version"

Gem::Specification.new do |s|
  s.name        = "saikuro"
  s.version     = Saikuro::VERSION
  s.authors     = ["Zev Blut", "Roman V. Babenko"]
  s.email       = ["zb@ubit.com", "romanvbabenko@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Saikuro is a Ruby cyclomatic complexity analyzer}
  s.description = %q{When given Ruby source code Saikuro will generate a report listing the cyclomatic complexity of each method found.  In addition, Saikuro counts the number of lines per method and can generate a listing of the number of tokens on each line of code.}

  s.rubyforge_project = "saikuro"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
