class Kent < Formula
  desc "Minimal terminal coding agent for professional engineering workflows"
  homepage "https://github.com/respawn-llc/kent"
  url "https://github.com/respawn-llc/kent/releases/download/v2.9.0/kent_2.9.0_darwin_arm64.tar.gz"
  sha256 "2a363ebc189730edd675be14c515bcdbc5f2cf47aa70fd65f30cefddf6049cc7"
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
      url "https://github.com/respawn-llc/kent/releases/download/v2.9.0/kent_2.9.0_linux_arm64.tar.gz"
      sha256 "863d9a183a9301cec386ab1c3f27fd2872a89551b1f4fafb1d49ef282c4fbae9"
    end
    on_intel do
      url "https://github.com/respawn-llc/kent/releases/download/v2.9.0/kent_2.9.0_linux_amd64.tar.gz"
      sha256 "ddacd8c2262f8241b0067ab527dbfd0da8c99765bd7d809a4b336124597c4c9f"
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
