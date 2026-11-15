class Ksrc < Formula
  desc "One-liner search and read for Kotlin dependency sources"
  homepage "https://github.com/respawn-llc/ksrc"
  url "https://github.com/respawn-llc/ksrc/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c05e9bd6f393db7413331af1d60f7edc9f4ef8a76f652e6ab6d2881c0ff1af3f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/respawn-llc/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "796ccf5a90db297b78f8ec1fa970f51c1e3d4e5d01a6b1e5c370fbc18de4cb6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "951fe8db0f1d3b9e2fcadea34b71f71aef2b7066056b2c81a58b7583702cf956"
    sha256 cellar: :any,                 x86_64_linux: "e6fa15abae13874a8a9199b6e00cc282e63cd9de1a3859faa5b32c0152822b8d"
  end

  depends_on "go" => :build
  depends_on "ripgrep"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/respawn-llc/ksrc/internal/cli.Version=#{version}"), "./cmd/ksrc"
  end
  test do
    assert_match "ksrc", shell_output("#{bin}/ksrc --help")
  end
end
