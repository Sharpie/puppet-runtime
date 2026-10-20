#####
# Component release information:
#   https://rubygems.org/gems/aws-sdk-ec2
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-sdk-ec2/CHANGELOG.md
#####
component 'rubygem-aws-sdk-ec2' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.657.0'
  pkg.sha256sum 'ac6022594b223350aede3e1f466bc480d799f698377c5f84d10c454eabf87a57'
  pkg.build_requires 'rubygem-aws-sdk-core'
  pkg.build_requires 'rubygem-aws-sigv4'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
