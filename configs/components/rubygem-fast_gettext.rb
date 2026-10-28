#####
# Component release information:
#   https://rubygems.org/gems/fast_gettext
#   https://github.com/grosser/fast_gettext/blob/master/CHANGELOG
# Notes:
#   This is pinned as the 4.2.0 release of fast_gettext dropped support
#   for Ruby 3.2. This causes builds of agent-runtome-8x to fail.
#####
component 'rubygem-fast_gettext' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  # PINNED
  pkg.version '4.1.1'
  pkg.sha256sum 'e8c532f6945b0dc31efb2e91366bd56630bc3ae6a05a4126937124e40366efd8'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
