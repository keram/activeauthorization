# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_authorization/version'

Gem::Specification.new do |spec|
  spec.name          = 'activeauthorization'
  spec.version       = ActiveAuthorization::VERSION
  spec.authors       = ['Marek L']
  spec.email         = ['nospam.keram@gmail.com']

  spec.summary       = 'Authorization library'
  spec.description   = 'Role based authorization library not just for Rails'
  spec.homepage      = 'http://github.com/keram/active_authorization'

  spec.metadata['allowed_push_host'] = 'TODO: Set to http://mygemserver.com'

  spec.files = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/})
  }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.4.1'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'minitest', '~> 5.10'
  spec.add_development_dependency 'simplecov', '~> 0.14'
  spec.add_development_dependency 'overcommit', '~> 0.40'
  spec.add_development_dependency 'rubocop', '~> 0.49'
  spec.add_development_dependency 'reek', '~> 4.7'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1'
  spec.add_development_dependency 'yard', '~> 0.9'
end
