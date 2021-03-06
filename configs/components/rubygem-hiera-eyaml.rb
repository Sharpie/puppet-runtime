component 'rubygem-hiera-eyaml' do |pkg, settings, platform|
  pkg.version '3.2.0'
  pkg.md5sum '33b3794e2e580de8baf037ef0b624879'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.build_requires 'rubygem-optimist'
  pkg.build_requires 'rubygem-highline'

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end
