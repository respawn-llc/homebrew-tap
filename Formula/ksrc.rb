class Ksrc < Formula
  desc "One-liner search and read for Kotlin dependency sources"
  homepage "https://github.com/respawn-llc/ksrc"
  url "https://github.com/respawn-llc/ksrc/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c05e9bd6f393db7413331af1d60f7edc9f4ef8a76f652e6ab6d2881c0ff1af3f"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "ripgrep"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/respawn-llc/ksrc/internal/cli.Version=#{version}"), "./cmd/ksrc"
  end
  test do
    assert_match "ksrc", shell_output("#{bin}/ksrc --help")
  end
end
