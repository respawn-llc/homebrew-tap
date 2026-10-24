class Kent < Formula
  desc "Minimal terminal coding agent for professional engineering workflows"
  homepage "https://github.com/respawn-llc/kent"
  url "https://github.com/respawn-llc/kent/releases/download/v2.11.0/kent_2.11.0_darwin_arm64.tar.gz"
  sha256 "738d1d54340d01d47ce77c7447ba4d5eb09ef03e8cc7f6ae89a192f360277c85"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/respawn-llc/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "7597cc359503998e07133a4808b9b10c3d8c7b4ada12f89f06faadf35ff877c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "99f6365e52b38563e1d7a75ca84de60e8ce94850bc9f5f5b8785cb069b6d5041"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "19706510be66861a3b55edce2cf6d43bed697e656ff8a8a31919f3173816f151"
  end

  depends_on "ripgrep"

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    on_arm do
      url "https://github.com/respawn-llc/kent/releases/download/v2.11.0/kent_2.11.0_linux_arm64.tar.gz"
      sha256 "cae933390ccdef95635b3977c41b6b936b4187682a141d75fc696d00440f9acd"
    end
    on_intel do
      url "https://github.com/respawn-llc/kent/releases/download/v2.11.0/kent_2.11.0_linux_amd64.tar.gz"
      sha256 "2af0a4278dfc33958d4596105a757433bd7304886c42accd21ff8968f64e0bdd"
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
