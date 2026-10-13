#####
# Component release information:
#   https://rubygems.org/gems/winrm
#   https://github.com/WinRb/WinRM/releases
#####
component 'rubygem-winrm' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '2.4.2'
  pkg.sha256sum '1dd3377cb9e414097b23718af5640b0bff726889f6cce2542985417c1c78abca'
  pkg.build_requires 'rubygem-builder'
  pkg.build_requires 'rubygem-gssapi'
  pkg.build_requires 'rubygem-gyoku'
  pkg.build_requires 'rubygem-httpclient'
  pkg.build_requires 'rubygem-nori'
  pkg.build_requires 'rubygem-rexml'
  pkg.build_requires 'rubygem-rubyntlm'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
