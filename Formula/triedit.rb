class Triedit < Formula
  desc "Office suite for Word documents, PDFs, Excel spreadsheets and PowerPoint slides"
  homepage "https://github.com/aionstech/homebrew-tap"
  version "1.3.5"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.5/triedit-1.3.5-osx-arm64.tar.gz"
      sha256 "35cd521b37904c0461d81412962c756f93a6d743d749eba73353244a735d896a"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.5/triedit-1.3.5-osx-x64.tar.gz"
      sha256 "8f69f3434397911272e7e0dad6edcb87d2f99d07fc2bad248ec51429899fa0a5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.5/triedit-1.3.5-linux-arm64.tar.gz"
      sha256 "35da6e764e424de10c7640e3d6edd95fdb9316a5f8362a2d2cba454cfefb6ac0"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.5/triedit-1.3.5-linux-x64.tar.gz"
      sha256 "0dc6222c7e96aef7b2536f9de5c910f0bec5cc794b49d4312ea2b8ad3a3b04af"
    end
  end

  # The app is a self-contained .NET program: its libraries find each other through @rpath, so keep those names.
  # (Homebrew older than 5.0 does not have preserve_rpath; there the formula still installs, without it.)
  preserve_rpath if respond_to?(:preserve_rpath)

  APP_NAME = "Animated Interactive Objects and Neural Software TriEdit".freeze

  def install
    libexec.install Dir["*"]
    app = libexec/APP_NAME
    chmod 0755, app

    # Apple silicon only runs signed code and this build has no Apple developer signature, so sign the program
    # for this Mac ("ad hoc", no account needed). Homebrew re-signs the libraries it adjusts the same way.
    system "/usr/bin/codesign", "--force", "--sign", "-", app if OS.mac?
    # The native libraries (graphics, speech, microphone) get the same signature, in case any came unsigned.
    Dir[libexec/"**/*.dylib"].each { |library| system "/usr/bin/codesign", "--force", "--sign", "-", library } if OS.mac?

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

      Privacy: on its first start TriEdit asks whether it may report the
      installation (operating system, version and processor type only).
      Nothing is sent unless you choose Allow. Privacy policy:
        https://triedit.aions.click/privacy.html
    EOS
  end

  test do
    assert_predicate libexec/APP_NAME, :executable?
    assert_path_exists libexec/"TriEdit.Core.dll"
  end
end
