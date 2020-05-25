component "rubygem-ffi" do |pkg, settings, platform|
  pkg.version '1.9.25'
  pkg.md5sum "e8923807b970643d9e356a65038769ac"

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Windows versions of the FFI gem have custom filenames, so we overwite the
  # defaults that _base-rubygem provides here, just for Windows.
  if platform.is_windows?
    # Vanagon's `pkg.mirror` is additive, and the _base_rubygem sets the
    # non-Windows gem as the first mirror, which is incorrect. We need to unset
    # the list of mirrors before adding the Windows-appropriate ones here:
    @component.mirrors = []
    # Same for install steps:
    @component.install = []

    if platform.architecture == "x64"
      pkg.md5sum "e263997763271fba35562245b450576f"
      pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}-x64-mingw32.gem"
      pkg.mirror "#{settings[:buildsources_url]}/ffi-#{pkg.get_version}-x64-mingw32.gem"
    else
      pkg.md5sum "3303124f1ca0ee3e59829301ffcad886"
      pkg.url "https://rubygems.org/downloads/ffi-#{pkg.get_version}-x86-mingw32.gem"
      pkg.mirror "#{settings[:buildsources_url]}/ffi-#{pkg.get_version}-x86-mingw32.gem"
    end

    pkg.install do
      "#{settings[:gem_install]} ffi-#{pkg.get_version}-#{platform.architecture}-mingw32.gem"
    end
  end

  # due to contrib/make_sunver.pl missing on solaris 11 we cannot compile libffi, so we provide the opencsw library
  pkg.environment "CPATH", "/opt/csw/lib/libffi-3.2.1/include" if platform.name =~ /solaris-11/
  pkg.environment "MAKE", platform[:make] if platform.is_solaris?

  if platform.is_cross_compiled? || platform.is_solaris?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:/opt/csw/bin:$$PATH"
  end

  if platform.name =~ /solaris-11-sparc/
    pkg.install_file "#{settings[:tools_root]}/#{settings[:platform_triple]}/sysroot/usr/lib/libffi.so.5.0.10", "#{settings[:libdir]}/libffi.so"
  elsif platform.name =~ /solaris-11-i386/
    pkg.install_file "/usr/lib/libffi.so.5.0.10", "#{settings[:libdir]}/libffi.so"
  end

  if platform.name =~ /el-5-x86_64/
    pkg.install_file "/usr/lib64/libffi.so.5", "#{settings[:libdir]}/libffi.so.5"
  elsif platform.is_cross_compiled? && ( platform.name =~ /debian-(?:9|10)/ )
    pkg.environment "PKG_CONFIG_PATH", "#{File.join(settings[:libdir], 'pkgconfig')}:/usr/lib/#{settings[:platform_triple]}/pkgconfig"
  elsif platform.is_cross_compiled?
    ruby_api_version = settings[:ruby_version].gsub(/\.\d*$/, '.0')
    base_ruby = case platform.name
                when /solaris-10/
                  "/opt/csw/lib/ruby/2.0.0"
                else
                  "/opt/pl-build-tools/lib/ruby/2.1.0"
                end

    # solaris 10 uses ruby 2.0 which doesn't install native extensions based on architecture
    unless platform.name =~ /solaris-10/
      # weird architecture naming conventions...
      target_triple = if platform.architecture =~ /ppc64el|ppc64le/
                        "powerpc64le-linux"
                      elsif platform.name =~ /solaris-11-sparc/
                        "sparc-solaris-2.11"
                      else
                        "#{platform.architecture}-linux"
                      end

      pkg.build do
        [
          %(#{platform[:sed]} -i 's/Gem::Platform.local.to_s/"#{target_triple}"/' #{base_ruby}/rubygems/basic_specification.rb),
          %(#{platform[:sed]} -i 's/Gem.extension_api_version/"#{ruby_api_version}"/' #{base_ruby}/rubygems/basic_specification.rb)
        ]
      end
    end

    # make rubygems use our target rbconfig when installing gems
    sed_command = %(s|Gem.ruby|&, '-r/opt/puppetlabs/puppet/share/doc/rbconfig-#{settings[:ruby_version]}-orig.rb'|)
    pkg.build do
      [
        %(#{platform[:sed]} -i "#{sed_command}" #{base_ruby}/rubygems/ext/ext_conf_builder.rb)
      ]
    end
  end

  pkg.environment 'PATH', '/opt/freeware/bin:/opt/pl-build-tools/bin:$(PATH)' if platform.is_aix?
end
