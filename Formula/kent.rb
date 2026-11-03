class Kent < Formula
  desc "Minimal terminal coding agent for professional engineering workflows"
  homepage "https://github.com/respawn-llc/kent"
  url "https://github.com/respawn-llc/kent/releases/download/v2.12.0/kent_2.12.0_darwin_arm64.tar.gz"
  sha256 "e13bb9954e47d1e35d991a332fa6ecff24b2066e9b8b801732d42ba82c23c42f"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/respawn-llc/tap"
  end

  depends_on "ripgrep"

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    on_arm do
      url "https://github.com/respawn-llc/kent/releases/download/v2.12.0/kent_2.12.0_linux_arm64.tar.gz"
      sha256 "fead40b31a2894a3736ffd545e2054488e72e5498527ec96e30f4e1b4076883b"
    end
    on_intel do
      url "https://github.com/respawn-llc/kent/releases/download/v2.12.0/kent_2.12.0_linux_amd64.tar.gz"
      sha256 "77218194e07017924c2414a72083245712b08b3b5c0d53ce07c84b0f87f0e334"
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "kent_#{version}_#{os}_#{arch}" => "kent"
  end

  post_install_steps do
    run "kent",
        args:         ["service", "restart", "--if-installed"],
        base:         :bin,
        must_succeed: false,
        print_stdout: true
  end

  def caveats
    <<~EOS
      Homebrew does not install the Kent server background service.

      If you want one shared background server for all Kent frontends (~70 MB RAM), run:
        kent service install
    EOS
  end

  test do
    assert_match "Usage of kent:", shell_output("#{bin}/kent --help 2>&1")
  end
end
