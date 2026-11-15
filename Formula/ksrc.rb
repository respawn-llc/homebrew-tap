class Ksrc < Formula
  desc "One-liner search and read for Kotlin dependency sources"
  homepage "https://github.com/respawn-llc/ksrc"
  url "https://github.com/respawn-llc/ksrc/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c05e9bd6f393db7413331af1d60f7edc9f4ef8a76f652e6ab6d2881c0ff1af3f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/respawn-llc/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "b0dd47c20fd75831f5c69a89a6cfee682efa36cdf4b1ca8ba2265c9f568bf18e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b4fb25176fab73bb2bf5816879dbdac216125dc04182079789bb1c26d1b5beb1"
  end
  depends_on "go" => :build
  depends_on "ripgrep"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/respawn-app/ksrc/internal/cli.Version=#{version}"), "./cmd/ksrc"
  end
  test do
    assert_match "ksrc", shell_output("#{bin}/ksrc --help")
  end
end
