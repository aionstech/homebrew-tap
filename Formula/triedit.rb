class Triedit < Formula
  desc "Office suite for Word documents, PDFs, Excel spreadsheets and PowerPoint slides"
  homepage "https://github.com/aionstech/homebrew-tap"
  version "1.1.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.1.0/triedit-1.1.0-osx-arm64.tar.gz"
      sha256 "9b57993d173c42ec0d3002268dd064e722d94b00ab9397246903d59a7c0cd453"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.1.0/triedit-1.1.0-osx-x64.tar.gz"
      sha256 "63a743d8fb849f48bb8f90ab5e639ae1be57cfe107215faf22a0a8888190b1f9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.1.0/triedit-1.1.0-linux-arm64.tar.gz"
      sha256 "a50d810ee2ff2f27aabf58291d74ea1fde26bc5d19768e8def80e7ed978621ff"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.1.0/triedit-1.1.0-linux-x64.tar.gz"
      sha256 "3a9e1b03eea2597e583a907d989fa9348fa7607e792352e24cc3a6f38bf77908"
    end
  end

  # The app is a self-contained .NET program: its libraries find each other through @rpath, so keep those names.
  preserve_rpath

  APP_NAME = "Animated Interactive Objects and Neural Software TriEdit".freeze

  def install
    libexec.install Dir["*"]
    app = libexec/APP_NAME
    chmod 0755, app

    # Apple silicon only runs signed code and this build has no Apple developer signature, so sign the program
    # for this Mac ("ad hoc", no account needed). Homebrew re-signs the libraries it adjusts the same way.
    system "/usr/bin/codesign", "--force", "--sign", "-", app if OS.mac?

    (bin/"triedit").write <<~SH
      #!/bin/bash
      exec "#{app}" "$@"
    SH
  end

  def caveats
    <<~EOS
      Start TriEdit with:
        triedit
      or open a file directly:
        triedit report.docx
    EOS
  end

  test do
    assert_predicate libexec/APP_NAME, :executable?
    assert_path_exists libexec/"TriEdit.Core.dll"
  end
end
