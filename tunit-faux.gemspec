# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tunit/faux/version'

Gem::Specification.new do |spec|
  spec.name          = "tunit-faux"
  spec.version       = Tunit::Faux::VERSION
  spec.authors       = ["Teo Ljungberg"]
  spec.email         = ["teo@teoljungberg.com"]
  spec.summary       = %q{Minimal mocking/stubbing framework}
  spec.description   = %q{Minimal mocking/stubbing framework}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
