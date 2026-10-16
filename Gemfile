source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place)
  if place =~ /^((?:git[:@]|https:)[^#]*)#(.*)/
    [{ :git => $1, :branch => $2, :require => false }]
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

gem 'artifactory'
gem 'packaging', *location_for(ENV['PACKAGING_LOCATION'] || '~> 0.105')
gem 'rake', '~> 13.0'
gem 'rubocop', '~> 1.86'
gem 'rubocop-rake', '~> 0.7'
gem 'vanagon', *location_for(ENV['VANAGON_LOCATION'] || 'https://github.com/openvoxproject/vanagon#main')

gem 'octokit', '< 11'

group(:development, optional: true) do
  gem 'hashdiff', require: false
  gem 'highline', require: false
  gem 'parallel', require: false
end

group(:release, optional: true) do
  gem 'faraday-retry', '~> 2.1', require: false
  gem 'github_changelog_generator', '~> 1.18', require: false
end
