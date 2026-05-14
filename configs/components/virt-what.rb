#####
# Component release information:
#   http://git.annexia.org/?p=virt-what.git;a=summary
#   https://people.redhat.com/~rjones/virt-what/files/
# Notes:
#   One of the first search results for this is
#   https://github.com/chuckleb/virt-what, which you
#   SHOULD NOT USE as this is a fork.
#####
component 'virt-what' do |pkg, settings, platform|
  pkg.load_from_json('configs/components/virt-what.json')
  pkg.mirror "#{settings[:buildsources_url]}/virt-what-#{pkg.get_version}.tar.gz"

  pkg.replaces 'pe-virt-what'

  # Run-time requirements
  requires 'util-linux' unless platform.is_deb?

  pkg.build_requires 'util-linux' if platform.is_rpm?

  pkg.configure do
    ["./configure --prefix=#{settings[:prefix]} --sbindir=#{settings[:prefix]}/bin --libexecdir=#{settings[:prefix]}/lib/virt-what"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end
end
