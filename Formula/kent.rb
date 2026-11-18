class Kent < Formula
  desc "Minimal terminal coding agent for professional engineering workflows"
  homepage "https://github.com/respawn-llc/kent"
  url "https://github.com/respawn-llc/kent/releases/download/v2.14.0/kent_2.14.0_darwin_arm64.tar.gz"
  sha256 "61ae67a3ff25d937b1c2daba8392dd6d7b7bc7af876b1a01cf876fbf45da694a"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/respawn-llc/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "5c2a2e4e5f3a1f8be22aae66114988f52a20e866ba8e81553b8e5e5b582d007c"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "0f0ad37f660d57f91ebd431926420c8b176833b81d83a7b6d092f83d5031c29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b2ee78db9ed551aeaa9e15f67a92d9cb220acbf5fb4f706c7e5306daa74afe49"
  end

  depends_on "ripgrep"

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    on_arm do
      url "https://github.com/respawn-llc/kent/releases/download/v2.14.0/kent_2.14.0_linux_arm64.tar.gz"
      sha256 "d7595acc8aaa76050e28207cf55a2e6c2f46abcc71f0104d7d76608a11b57659"
    end
    on_intel do
      url "https://github.com/respawn-llc/kent/releases/download/v2.14.0/kent_2.14.0_linux_amd64.tar.gz"
      sha256 "133e62ee5fd1fbd73c7e7c1b2daf4854291dcaab6cef827aa6d7f9ff8771cb9a"
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
