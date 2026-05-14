#####
# Component release information:
#   https://rubygems.org/gems/ffi
#   https://github.com/ffi/ffi/blob/master/CHANGELOG.md
# Notes:
#   Read the comments in the code below carefully.
#####
component 'rubygem-ffi' do |pkg, settings, platform|
  ### Maintained by update_gems automation ###
  pkg.version '1.17.4'
  pkg.sha256sum 'bcd1642e06f0d16fc9e09ac6d49c3a7298b9789bcb58127302f934e437d60acf'
  ### End automated maintenance section ###

  # Prior to ruby 3.2, both ruby and the ffi gem vendored a version of libffi.
  # If libffi happened to be installed in /usr/lib, then the ffi gem preferred
  # that instead of building libffi itself. To ensure consistency, we use
  # --disable-system-libffi so that the ffi gem *always* builds libffi, then
  # builds the ffi_c native extension and links it against libffi.so.
  #
  # In ruby 3.2 and up, libffi is no longer vendored. So we created a separate
  # libffi vanagon component which is built before ruby. The ffi gem still
  # vendors libffi, so we use the --enable-system-libffi option to ensure the ffi
  # gem *always* uses the libffi.so we already built. Note the term "system" is
  # misleading, because we override PKG_CONFIG_PATH below so that our libffi.so
  # is preferred, not the one in /usr/lib.
  settings["#{pkg.get_name}_gem_install_options".to_sym] = '-- --enable-system-libffi'
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment 'PKG_CONFIG_PATH', '/opt/puppetlabs/puppet/lib/pkgconfig:$(PKG_CONFIG_PATH)'

  if platform.is_cross_compiled? && !platform.is_macos?
    # Change this someday if we ever end up cross compiling OpenVox on Linux
    # as we won't be using pl-build-tools there
    base_ruby = '/opt/pl-build-tools/lib/ruby/2.1.0'

    # FFI 1.13.1 forced the minimum required ruby version to ~> 2.3
    # In order to be able to install the gem using pl-ruby(2.1.9)
    # we need to remove the required ruby version check
    pkg.configure do
      %(#{platform[:sed]} -i '0,/ensure_required_ruby_version_met/b; /ensure_required_ruby_version_met/d' #{base_ruby}/rubygems/installer.rb)
    end
  end
end
