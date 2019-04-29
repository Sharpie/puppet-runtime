platform "debian-9-armhf" do |plat|
  plat.servicedir "/lib/systemd/system"
  plat.defaultdir "/etc/default"
  plat.servicetype "systemd"
  plat.codename "stretch"
  plat.platform_triple "arm-linux-gnueabihf"

  plat.install_build_dependencies_with "DEBIAN_FRONTEND=noninteractive; apt-get install -qy --no-install-recommends "

  # STORY TIME: In order to keep on-disk sizes low, most docker containers
  #             are configured to skip installation of man pages. This
  #             generally works out fine except the post-install script
  #             of `openjdk-8-jdk-headless` assumes noone would ever do
  #             such a thing and fails.
  plat.provision_with 'mkdir -p /usr/share/man/man1'
  plat.provision_with "dpkg --add-architecture #{plat.get_architecture}"

  packages = [
    'cmake',
    "crossbuild-essential-#{plat.get_architecture}",
    'debhelper',
    'devscripts',
    'fakeroot',
    "libc6-dev:#{plat.get_architecture}",
    "libbz2-dev:#{plat.get_architecture}",
    "libreadline-dev:#{plat.get_architecture}",
    'make',
    'openjdk-8-jdk-headless',
    'pkg-config',
    'quilt',
    'rsync',
    "zlib1g-dev:#{plat.get_architecture}",
  ]
  plat.provision_with "export DEBIAN_FRONTEND=noninteractive; apt-get update -qq; apt-get install -qy --no-install-recommends #{packages.join(' ')}"

  plat.cross_compiled "true"
  plat.output_dir File.join("deb", plat.get_codename, "PC1")

  plat.vmpooler_template "debian-9-x86_64"

  # NOTE: Bring your own image. The image is expected to satisfy the following
  #       conditions:
  #
  #         - Runs SystemD
  #         - Runs SSHD under SystemD
  #           - SSHD allows pubkey access to the root user via a
  #             key set by the VANAGON_SSH_KEY environment variable.
  plat.docker_image ENV['VANAGON_DOCKER_IMAGE']
  plat.ssh_port 4222
  plat.docker_run_args ['--tmpfs=/tmp:exec',
                        '--tmpfs=/run',
                        '--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro',
                        # SystemD requires some elevated privilages.
                        '--cap-add=SYS_ADMIN']
end
