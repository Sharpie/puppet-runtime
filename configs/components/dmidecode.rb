#####
# Component release information: https://github.com/mirror/dmidecode/tags
#####
component 'dmidecode' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/dmidecode.json')

  pkg.apply_patch 'resources/patches/dmidecode/dmidecode-install-to-bin.patch'
  pkg.mirror "#{settings[:buildsources_url]}/dmidecode-#{pkg.get_version}.tar.xz"

  pkg.environment 'LDFLAGS', settings[:ldflags]
  pkg.environment 'CFLAGS', settings[:cflags]

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    [
      "#{platform[:make]} prefix=#{settings[:prefix]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      "rm -f #{settings[:bindir]}/vpddecode #{settings[:bindir]}/biosdecode #{settings[:bindir]}/ownership",
      "rm -f #{settings[:mandir]}/man8/ownership.8 #{settings[:mandir]}/man8/biosdecode.8 #{settings[:mandir]}/man8/vpddecode.8"
    ]
  end
end
