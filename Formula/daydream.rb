class Daydream < Formula
  desc "Design tool for the web where real HTML/CSS is the grain, with an MCP host for agents"
  homepage "https://github.com/martinbavio/daydream-public"
  version "0.1.40"

  on_macos do
    on_arm do
      url "https://github.com/martinbavio/daydream-public/releases/download/v0.1.40/daydream-0.1.40-darwin-arm64.tar.gz"
      sha256 "9d73481c03619e235718be504eaa337cfbed0e8915f5d48e305f86370ed79cee"
    end
    on_intel do
      url "https://github.com/martinbavio/daydream-public/releases/download/v0.1.40/daydream-0.1.40-darwin-x64.tar.gz"
      sha256 "20e2fe073fc9ff2ab3a890b781df6de4bb9e65115c30171f1c8bbaee303a84bb"
    end
  end

  def install
    bin.install "bin/daydream"
    (share/"daydream").install Dir["share/daydream/*"], Dir["share/daydream/.daydream"]
  end

  # `brew services start daydream`: the host at login, restarted if it
  # dies — what a launchd agent does, managed by Homebrew.
  service do
    run [opt_bin/"daydream", "serve"]
    keep_alive true
    log_path var/"log/daydream.log"
    error_log_path var/"log/daydream.log"
  end

  def caveats
    <<~EOS
      Start the host once with `daydream`, or keep it running across logins with
      `brew services start daydream` (it serves ~/Daydream on 127.0.0.1:37326).
      Then register it with every agent harness on this machine: `daydream connect`
      (or by hand, for Claude Code:
        claude mcp add daydream --transport http http://127.0.0.1:37326/mcp --scope user).
      Upgrades: `daydream update` (it runs brew for you and restarts the service).
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/daydream version")
  end
end
