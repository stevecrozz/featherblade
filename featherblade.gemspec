# coding: utf-8

Gem::Specification.new do |spec|
  spec.name        = 'featherblade'
  spec.summary     = 'Shave the shit out of your CSS'
  spec.version     = '0.1.0'
  spec.authors     = ["Stephen Crosby"]
  spec.email       = 'stevecrozz@gmail.com'
  spec.homepage    = 'https://github.com/stevecrozz/featherblade'
  spec.licenses    = ["MIT"]

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'nokogiri', '~> 1.0.0'
  spec.add_development_dependency 'css_parser', '~> 1.3.6'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'bundler', '~> 1.6'
end
