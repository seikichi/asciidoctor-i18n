# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'asciidoctor/i18n/version'

Gem::Specification.new do |spec|
  spec.name          = 'asciidoctor-i18n'
  spec.version       = Asciidoctor::I18n::VERSION
  spec.authors       = ['Seiichi KONDO']
  spec.email         = ['seikichi@kmc.gr.jp']

  spec.summary       = ''
  spec.description   = ''
  spec.homepage      = 'https://github.com/seikichi/asciidoctor-i18n'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'asciidoctor', '~> 2.0'
  spec.add_dependency 'gettext', '~> 3.2.6'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '0.52.1'
  spec.add_development_dependency 'simplecov', '~> 0.15.0'
  spec.add_development_dependency 'test-unit', '>= 3.0.0'

  %w[pry pry-byebug pry-coolline pry-doc pry-inline pry-theme].each do |dep|
    spec.add_development_dependency dep
  end
end
