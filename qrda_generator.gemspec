# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "qrda_generator"
  s.summary = "A library for generating QRDA Cat 1."
  s.description = "A library for generating QRDA Cat 1."
  s.email = "talk@projectpophealth.org"
  s.homepage = "https://github.com/projectcypress/qrda_generator"
  s.authors = ["Andy Gregorowicz"]
  s.version = '1.0.2'
  
  s.add_dependency 'health-data-standards', '~> 2.2.0'
  s.add_dependency 'hqmf-parser', '~> 1.1.0'
  s.add_dependency 'mongoid', '~> 3.0.6'
  s.add_dependency 'uuid', '~> 2.3.5'
  s.add_dependency 'nokogiri', '~> 1.5.5'
  s.add_dependency 'log4r', '~> 1.1.10'

  s.files = Dir.glob('lib/**/*.rb') + Dir.glob('templates/*.erb') +
            Dir.glob('lib/**/*.json') + ["Gemfile", "Rakefile"]
end
