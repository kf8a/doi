
# -*- encoding: utf-8 -*-
$:.push('lib')
require "doijs/version"

Gem::Specification.new do |s|
  s.name     = "doijs"
  s.version  = Doijs::VERSION.dup
  s.date     = "2015-11-20"
  s.summary  = "A library to download doi information and pdfs"
  s.email    = "bohms@msu.edu"
  s.homepage = "http://github.com/kf8a/doi.js"
  s.authors  = ['Sven Bohm']
  
  s.description = <<-EOF
TODO: Long description 
EOF
  
  dependencies = [
    # Examples:
    [:runtime,     "typheous"],
    [:runtime,     "nokogiri"],
    [:runtime,     "json"],
    [:development, "rspec", "~> 2.1"],
    [:development, "csv"],
  ]
  
  s.files         = Dir['**/*']
  s.test_files    = Dir['test/**/*'] + Dir['spec/**/*']
  s.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  
  ## Make sure you can build the gem on older versions of RubyGems too:
  s.rubygems_version = "2.4.6"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.specification_version = 3 if s.respond_to? :specification_version
  
  dependencies.each do |type, name, version|
    if s.respond_to?("add_#{type}_dependency")
      s.send("add_#{type}_dependency", name, version)
    else
      s.add_dependency(name, version)
    end
  end
end
