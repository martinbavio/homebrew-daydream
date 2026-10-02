class Daydream < Formula
  desc "Design tool for the web where real HTML/CSS is the grain, with an MCP host for agents"
  homepage "https://github.com/martinbavio/daydream-public"
  version "0.1.53"

  on_macos do
    on_arm do
      url "https://github.com/martinbavio/daydream-public/releases/download/v0.1.53/daydream-0.1.53-darwin-arm64.tar.gz"
      sha256 "b969269bbd6f5c19108c618d84bf069db4f469518d9da460f9ded5f46c8d4eb9"
    end
    on_intel do
      url "https://github.com/martinbavio/daydream-public/releases/download/v0.1.53/daydream-0.1.53-darwin-x64.tar.gz"
      sha256 "6faf4ce1d4c3ae6918dbb6c16e9e9f6d356b8c929c1ab82e6eec66d0d9e8a33d"
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
      Open a project with `daydream <folder>` (any folder of html files; `daydream`
      alone reopens the last one), or keep the host running across logins with
      `brew services start daydream`. It listens on 127.0.0.1:37326.
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
