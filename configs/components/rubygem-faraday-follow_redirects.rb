#####
# Component release information:
#   https://rubygems.org/gems/faraday-follow_redirects
#   https://github.com/tisba/faraday-follow-redirects/blob/main/CHANGELOG.md
#####
component 'rubygem-faraday-follow_redirects' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '0.5.0'
  pkg.sha256sum '5cde93c894b30943a5d2b93c2fe9284216a6b756f7af406a1e55f211d97d10ad'
  pkg.build_requires 'rubygem-faraday'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
