class Triedit < Formula
  desc "Office suite for Word documents, PDFs, Excel spreadsheets and PowerPoint slides"
  homepage "https://github.com/aionstech/homebrew-tap"
  version "1.3.1"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.1/triedit-1.3.1-osx-arm64.tar.gz"
      sha256 "716e07bcae8547033cae8e3b45eb2e138d44603330f82d0956ddbd9bf2c70de5"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.1/triedit-1.3.1-osx-x64.tar.gz"
      sha256 "e2d058e53ea16b2e35f73a018fcc8f059acc745d6338c09e9faf0950fd92620d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.1/triedit-1.3.1-linux-arm64.tar.gz"
      sha256 "7fabf9bfa474f44b9b9a803798ae60daa2d30ef8867c03823889850ed068ef9a"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.1/triedit-1.3.1-linux-x64.tar.gz"
      sha256 "f2c2183b77216e4c07171ac2029107fd6e59463d85a582339f9901d5f432e2c4"
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
