# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gry/version'

Gem::Specification.new do |spec|
  spec.name          = "gry"
  spec.version       = Gry::VERSION
  spec.authors       = ["Masataka Kuwabara"]
  spec.email         = ["p.ck.t22@gmail.com"]

  spec.summary       = %q{Gry generates `.rubocop.yml` automatically from your source code.}
  spec.description   = %q{Gry generates `.rubocop.yml` automatically from your source code.}
  spec.homepage      = "https://github.com/pocke/gry"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.licenses = ['Apache-2.0']

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5.0"
  spec.add_development_dependency "rspec-power_assert", "~> 0.4.0"
  spec.add_development_dependency 'coveralls', '~> 0.8.16'
  spec.add_development_dependency 'simplecov', '~> 0.12.0'
  spec.add_development_dependency "guard", "~> 2.14.0"
  spec.add_development_dependency "guard-rspec", "~> 4.7.3"
  spec.add_development_dependency "guard-bundler", "~> 2.1.0"
  spec.add_development_dependency "guard-rubocop", "~> 1.2.0"
  spec.add_development_dependency "rubocop", ">= 0.46.0"
  spec.add_development_dependency "meowcop", ">= 1.4.0"

  # TODO: specify 0.47.0
  spec.add_runtime_dependency "rubocop", ">= 0.46.0"
  spec.add_runtime_dependency "parallel", "~> 1.10.0"
end
