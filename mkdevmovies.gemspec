
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mkdevmovies/version"

Gem::Specification.new do |spec|
  spec.name          = "mkdevmovies"
  spec.version       = Mkdevmovies::VERSION
  spec.authors       = ["Pavel Novokshonov"]
  spec.email         = ["novokshonovp@gmail.com"]

  spec.summary       = %q{Collection of IMDB top 250 movies}
  spec.description   = %q{Parse IMDB top 250 movies from csv. Add fields to collection by parse imdb.com and tmdb.com. Set of toolbox to routine the collection.}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'safe_yaml', "~> 1.04"
  spec.add_dependency 'money', "~> 6.10.1"
  spec.add_dependency 'nokogiri', "~> 1.8.1"
  spec.add_dependency 'dotenv', "~>2.2.1"
  spec.add_dependency 'dry-initializer', "~> 2.3.0"
  spec.add_dependency 'haml', "~> 5.0.4"
  spec.add_dependency 'ruby-progressbar', "~> 1.9.0"

  spec.add_development_dependency 'simplecov', "~> 0.15.1"
  spec.add_development_dependency 'webmock', "~> 3.1.1"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.7.0"
end
