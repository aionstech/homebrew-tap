class Triedit < Formula
  desc "Office suite for Word documents, PDFs, Excel spreadsheets and PowerPoint slides"
  homepage "https://github.com/aionstech/homebrew-tap"
  version "1.3.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.0/triedit-1.3.0-osx-arm64.tar.gz"
      sha256 "776e6f622e34860fe691192ef159dc660372f131383e0920aaed1383c369a558"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.0/triedit-1.3.0-osx-x64.tar.gz"
      sha256 "91a72990e5f649b348a2dbb94e186dd4d97c6c0924a6ea1ac8ef4648f05b589c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.0/triedit-1.3.0-linux-arm64.tar.gz"
      sha256 "675ab0af3a92b218f2d011a1bb6a831ac820c2c51c8cbb44d8f248c9c1cfee2d"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.0/triedit-1.3.0-linux-x64.tar.gz"
      sha256 "4cebb042ddbdade7d0710559c7d61c3a02995252b2daddd37b7c2ae62561a6d7"
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
      Update later with:
        brew upgrade triedit
    EOS
  end

  test do
    assert_predicate libexec/APP_NAME, :executable?
    assert_path_exists libexec/"TriEdit.Core.dll"
  end
end
