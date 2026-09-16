cask "kent-desktop" do
  version "2.8.0"
  sha256 "22add6f72f7b8653fef4be59242fdd557422f96f360a4170ac7365f2ae741c9a"

  url "https://github.com/respawn-llc/kent/releases/download/v#{version}/Kent_#{version}_aarch64.dmg"
  name "Kent"
  desc "Desktop client for the Kent coding agent"
  homepage "https://github.com/respawn-llc/kent"

  depends_on arch: :arm64
  depends_on formula: "kent"
  depends_on macos: :sequoia

  app "Kent.app"

  # Self-update is install-source-aware: Homebrew owns updates for cask installs
  # and locksteps with the kent formula, so the in-app updater is gated off by
  # writing the desktop settings file. Do NOT add `auto_updates true` — that would
  # make `brew upgrade` skip this cask and let the app self-update ahead of the
  # server. See docs/dev/specs/release-distribution.md.
  postflight_steps do
    mkdir_p "Library/Application Support/sh.kent", base: :home
    unless_path_exists "Library/Application Support/sh.kent/settings.json", base: :home do
      write_file "Library/Application Support/sh.kent/settings.json", "{}\n", base: :home
    end
    run "/usr/bin/ruby",
        args:           ["-rjson", "-rtempfile", "-e", <<~RUBY],
          path = "settings.json"
          data = begin
            parsed = JSON.parse(File.read(path))
            parsed.is_a?(Hash) ? parsed : {}
          rescue Errno::ENOENT, JSON::ParserError
            {}
          end
          data["version"] = 1
          data["selfUpdate"] = "disabled"

          Tempfile.create(["settings", ".json"], File.dirname(path)) do |file|
            file.write(JSON.pretty_generate(data))
            file.write("\n")
            file.flush
            file.fsync
            file.close
            File.rename(file.path, path)
          end
        RUBY
        chdir:          "~/Library/Application Support/sh.kent",
        writable_paths: ["Library/Application Support/sh.kent"],
        writable_base:  :home
  end

  uninstall quit: "sh.kent"

  zap trash: [
    "~/Library/Application Support/sh.kent",
    "~/Library/Caches/sh.kent",
    "~/Library/HTTPStorages/sh.kent",
    "~/Library/Saved Application State/sh.kent.savedState",
    "~/Library/WebKit/sh.kent",
  ]
end
