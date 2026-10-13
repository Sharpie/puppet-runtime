#####
# Component release information:
#   https://rubygems.org/gems/multi_json
#   https://github.com/sferik/multi_json/blob/main/CHANGELOG.md
#####
component 'rubygem-multi_json' do |pkg, settings, _platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.21.2'
  pkg.sha256sum '245531eaf54bdba57aba515ff08b4503505c5e09911daa89c5a561e2f85bea8e'
  pkg.build_requires 'rubygem-concurrent-ruby'
  ### End automated maintenance section ###

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
