#####
# Component release information:
#   https://rubygems.org/gems/net-scp
#   https://github.com/net-ssh/net-scp/tags
#####
component 'rubygem-net-scp' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '4.1.1'
  pkg.sha256sum '6017d1af1ca175cb193e8a33ca4bb7c53ddd40de7a050643b3b15ec386b2d392'
  pkg.build_requires 'rubygem-net-ssh'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
