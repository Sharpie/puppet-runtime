#####
# Component release information:
#   https://rubygems.org/gems/aws-eventstream
#   https://github.com/aws/aws-sdk-ruby/blob/version-3/gems/aws-eventstream/CHANGELOG.md
#####
component 'rubygem-aws-eventstream' do |pkg, _settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.4.1'
  pkg.sha256sum 'ceb6a99c61df4bb00344e54aed0351574beca24f87a0d1487d1d2ed80929ce96'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
