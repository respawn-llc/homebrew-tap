class Kent < Formula
  desc "Minimal terminal coding agent for professional engineering workflows"
  homepage "https://github.com/respawn-llc/kent"
  url "https://github.com/respawn-llc/kent/releases/download/v2.10.0/kent_2.10.0_darwin_arm64.tar.gz"
  sha256 "1a46bb374047506085d7cbc94b91fcce7908f7e6f36ab5e00e1ed3ea53c7f06d"
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
      url "https://github.com/respawn-llc/kent/releases/download/v2.10.0/kent_2.10.0_linux_arm64.tar.gz"
      sha256 "7424e0712624623c1be0453754404fbe39557dacdb321d133849a59cfdc97682"
    end
    on_intel do
      url "https://github.com/respawn-llc/kent/releases/download/v2.10.0/kent_2.10.0_linux_amd64.tar.gz"
      sha256 "18405195c5358a89000b84cfe1bb9eba7062da3d369d7db6080f03b73962f373"
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
