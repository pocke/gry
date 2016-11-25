# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gry/version'

Gem::Specification.new do |spec|
  spec.name          = "gry"
  spec.version       = Gry::VERSION
  spec.authors       = ["Masataka Kuwabara"]
  spec.email         = ["p.ck.t22@gmail.com"]

  spec.summary       = %q{}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/pocke/gry"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.2.0'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5.0"
  spec.add_development_dependency "rspec-power_assert", "~> 0.4.0"
  spec.add_development_dependency "guard", "~> 2.14.0"
  spec.add_development_dependency "guard-rspec", "~> 4.7.3"
  spec.add_development_dependency "guard-bundler", "~> 2.1.0"

  spec.add_runtime_dependency "rubocop", "~> 0.45.0"
  spec.add_runtime_dependency "concurrent-ruby", "~> 1.0.2"
end
