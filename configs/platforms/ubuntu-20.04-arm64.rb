platform 'ubuntu-20.04-arm64' do |plat|
  plat.servicedir '/lib/systemd/system'
  plat.defaultdir '/etc/default'
  plat.servicetype 'systemd'
  plat.codename 'focal'
  plat.platform_triple 'aarch64-linux-gnu'
  plat.cross_compiled true
  plat.output_dir File.join('deb', plat.get_codename, 'PC1')


  plat.install_build_dependencies_with 'DEBIAN_FRONTEND=noninteractive; apt-get install -qy --no-install-recommends '

  # STORY TIME: In order to keep on-disk sizes low, most docker containers
  #             are configured to skip installation of man pages. This
  #             generally works out fine except the post-install script
  #             of `openjdk-11-jdk-headless` assumes noone would ever do
  #             such a thing and fails.
  plat.provision_with 'mkdir -p /usr/share/man/man1'
  plat.provision_with "dpkg --add-architecture #{plat.get_architecture}"

  # MORE STORY TIME: Ubuntu doesn't keep all of its architectures in one
  #                  spot (because that would just make too much sense).
  #                  Therefore, adding arm64 above will cause
  #                  `apt update` to be very sad. So, we have to lock
  #                  the default repos to amd64.
  plat.provision_with "sed -i 's/^deb/deb [arch=amd64]/' /etc/apt/sources.list"
  #  ...and then create copies for arm64 that use the ports archive
  # see: https://askubuntu.com/questions/430705/how-to-use-apt-get-to-download-multi-arch-library
  plat.provision_with "sed -E -e 's/amd64/#{plat.get_architecture}/' -e 's/(archive|security).ubuntu.com\\/ubuntu/ports.ubuntu.com/' /etc/apt/sources.list > /etc/apt/sources.list.d/ports.list"

  packages = [
    'build-essential',
    'cmake',
    "crossbuild-essential-#{plat.get_architecture}",
    'debhelper',
    'devscripts',
    'fakeroot',
    "libc6-dev:#{plat.get_architecture}",
    # The middle component should match the GCC version.
    "libstdc++-9-dev:#{plat.get_architecture}",
    "libbz2-dev:#{plat.get_architecture}",
    "libffi-dev:#{plat.get_architecture}",
    "libreadline-dev:#{plat.get_architecture}",
    "libselinux1-dev:#{plat.get_architecture}",
    'make',
    'openjdk-11-jdk-headless',
    'pkg-config',
    'qemu-user-static',
    'quilt',
    'rsync',
    'swig',
    "zlib1g-dev:#{plat.get_architecture}",
  ]
  plat.provision_with "export DEBIAN_FRONTEND=noninteractive; apt-get update -qq; apt-get install -qy --no-install-recommends #{packages.join(' ')}"

  plat.setting :use_pl_build_tools, false
  plat.setting :cc, "#{_platform.platform_triple}-gcc"
  plat.setting :cxx, "#{_platform.platform_triple}-g++"

  # CMake configuration
  # Allow the CMake search path for cross-compiled libraries to be extended
  # by passing -DCMAKE_FIND_ROOT_PATH when running cmake.
  plat.provision_with "sed -i 's/SET (CMAKE_FIND_ROOT_PATH/list (INSERT CMAKE_FIND_ROOT_PATH 0/' /etc/dpkg-cross/cmake/CMakeCross.txt"
  plat.setting :cmake_toolchain, "-DCMAKE_TOOLCHAIN_FILE=/etc/dpkg-cross/cmake/CMakeCross.txt -DCMAKE_FIND_ROOT_PATH='/opt/puppetlabs/puppet;/usr'"
  plat.environment 'DEB_HOST_ARCH', _platform.architecture
  plat.environment 'DEB_HOST_GNU_TYPE', _platform.platform_triple


  plat.vmpooler_template 'ubuntu-2004-x86_64'

  plat.docker_image ENV.fetch('VANAGON_DOCKER_IMAGE', 'ubuntu:20.04')
  # Vanagon starts detached containers, adding `--tty` and using a shell as
  # the entry point causes the container to persist for other commands to run.
  plat.docker_run_args ['--tty', '--entrypoint=/bin/sh']
  plat.use_docker_exec true
end
