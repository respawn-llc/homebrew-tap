class Kent < Formula
  desc "Minimal terminal coding agent for professional engineering workflows"
  homepage "https://github.com/respawn-llc/kent"
  url "https://github.com/respawn-llc/kent/releases/download/v2.13.0/kent_2.13.0_darwin_arm64.tar.gz"
  sha256 "dc8a2e9bf3effa451ffeb01063af828c9d09fd0df747255659bf674e4c7407d9"
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
      url "https://github.com/respawn-llc/kent/releases/download/v2.13.0/kent_2.13.0_linux_arm64.tar.gz"
      sha256 "c5f336000984ec3e16127289fa4346f39f23002107d869b825f9dbdc02df3e33"
    end
    on_intel do
      url "https://github.com/respawn-llc/kent/releases/download/v2.13.0/kent_2.13.0_linux_amd64.tar.gz"
      sha256 "ab6725f237ebe762df8155667a906491ab3770bf5e80afc1663f8ba7eec15d97"
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
