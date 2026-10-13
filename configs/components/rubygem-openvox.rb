#####
# Component release information (lol):
#   https://rubygems.org/gems/openvox
#   https://github.com/OpenVoxProject/openvox/releases
#####
component 'rubygem-openvox' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '9.1.0'
  pkg.sha256sum 'fd7a947b743cdb84097ebfa8961e4efed4570b9c19e4b3d882b903371b795959'
  pkg.build_requires 'rubygem-concurrent-ruby'
  pkg.build_requires 'rubygem-deep_merge'
  pkg.build_requires 'rubygem-fast_gettext'
  pkg.build_requires 'rubygem-locale'
  pkg.build_requires 'rubygem-openfact'
  pkg.build_requires 'rubygem-puppet-resource_api'
  pkg.build_requires 'rubygem-scanf'
  pkg.build_requires 'rubygem-semantic_puppet'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
