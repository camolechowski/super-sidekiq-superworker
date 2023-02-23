require File.expand_path('../lib/sidekiq/superworker/version', __FILE__)

Gem::Specification.new do |s|
  s.authors       = ['Tom Benner']
  s.email         = ['tombenner@gmail.com']
  s.description = s.summary = %q{Define dependency graphs of Sidekiq jobs}
  s.homepage      = 'https://github.com/Invoca/sidekiq-superworker'

  s.files         = Dir['{lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.name          = 'sidekiq-superworker'
  s.require_paths = ['lib']
  s.version       = Sidekiq::Superworker::VERSION
  s.license       = 'MIT'
  s.metadata["allowed_push_host"] = "https://gem.fury.io/invoca"

  s.add_dependency 'sidekiq', '>= 5.0', '< 7'
  s.add_dependency 'activesupport', '>= 5.0', '< 7'
  s.add_dependency 'activemodel', '>= 5.0', '< 7'
end
