#####
# Component release information:
#   https://gitlab.gnome.org/GNOME/libxml2/-/releases
#   https://github.com/GNOME/libxml2/tags
#####
component 'libxml2' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/libxml2.json')
  pkg.mirror "#{settings[:buildsources_url]}/libxml2-#{pkg.get_version}.tar.xz"

  pkg.environment 'LDFLAGS', settings[:ldflags]
  pkg.environment 'CFLAGS', settings[:cflags]

  if platform.is_macos?
    pkg.environment 'CC', settings[:cc]
    pkg.environment 'MACOSX_DEPLOYMENT_TARGET', settings[:deployment_target]
  end

  pkg.build_requires "runtime-#{settings[:runtime_project]}"

  pkg.configure do
    ["./configure --prefix=#{settings[:prefix]} --without-python #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    [
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      "rm -rf #{settings[:datadir]}/gtk-doc",
      "rm -rf #{settings[:datadir]}/doc/#{pkg.get_name}*"
    ]
  end
end
