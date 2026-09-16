class Kent < Formula
  desc "Minimal terminal coding agent for professional engineering workflows"
  homepage "https://github.com/respawn-llc/kent"
  url "https://github.com/respawn-llc/kent/releases/download/v2.8.0/kent_2.8.0_darwin_arm64.tar.gz"
  sha256 "3bdbcaf350c0cdbf4ec9f0130cadb0e3703f359db0fc33e54764b2469d05a8ab"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/respawn-llc/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "be9e1427e290e29d216c9b54a3bcb7b6e1815834eedd9942d9b001e9e262e2b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6f8313b8e0aa75b4fc834763c2f63bea0e4cfc5cc902598b8dad61b6493d12b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "46b4a770c6ea70f2c038aa3d352b46213ed1d37ab646ff7fa5bfd4025ead3e6b"
  end

  depends_on "ripgrep"

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    on_arm do
      url "https://github.com/respawn-llc/kent/releases/download/v2.8.0/kent_2.8.0_linux_arm64.tar.gz"
      sha256 "1beb24bcf48443013f6982be140676c0c2559878c3803385b1858927265080c0"
    end
    on_intel do
      url "https://github.com/respawn-llc/kent/releases/download/v2.8.0/kent_2.8.0_linux_amd64.tar.gz"
      sha256 "f41899bd1ec05866281c5035f7088136fc09a6a09a3ccd97a483e7df9a2bfb89"
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
