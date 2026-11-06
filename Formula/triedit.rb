class Triedit < Formula
  desc "Office suite for Word documents, PDFs, Excel spreadsheets and PowerPoint slides"
  homepage "https://github.com/aionstech/homebrew-tap"
  version "1.3.6"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.6/triedit-1.3.6-osx-arm64.tar.gz"
      sha256 "3e2fcd578c413ffd4eda20ec3499511b37572bc743632e1cf0a0db8f2918eaf4"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.6/triedit-1.3.6-osx-x64.tar.gz"
      sha256 "1060d007195eb89496436e2327d8c4d9203e2671e7f0eb9b0e46facb06263654"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.6/triedit-1.3.6-linux-arm64.tar.gz"
      sha256 "30a6cbda57d385819756d4c5a8b2acafc88e59a92793c2744c493df191b19767"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.6/triedit-1.3.6-linux-x64.tar.gz"
      sha256 "668076981e7aa549bb455bb8d208fb19de2edf65e15615d59216af79e8a42a72"
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
