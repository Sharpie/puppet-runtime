#####
# Component release information: https://github.com/libffi/libffi/releases
#####
component 'libffi' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/libffi.json')
  pkg.mirror "#{settings[:buildsources_url]}/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  pkg.environment 'LDFLAGS', settings[:ldflags]
  pkg.environment 'CFLAGS', settings[:cflags]

  if platform.is_macos?
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]
  elsif platform.is_windows?
    pkg.environment 'PATH', "$(shell cygpath -u #{settings[:gcc_bindir]}):$(PATH)"
    pkg.apply_patch 'resources/patches/libffi/revert_clang_32bit.patch' if platform.architecture == 'x86'
  end

  pkg.build_requires "runtime-#{settings[:runtime_project]}"

  pkg.configure do
    ["./configure --prefix=#{settings[:prefix]} --sbindir=#{settings[:prefix]}/bin --libexecdir=#{settings[:prefix]}/lib/libffi --disable-multi-os-directory #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    [
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      "rm -rf #{settings[:datadir]}/doc/#{pkg.get_name}*"
    ]
  end
end
