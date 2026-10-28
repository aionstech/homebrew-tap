class Triedit < Formula
  desc "Office suite for Word documents, PDFs, Excel spreadsheets and PowerPoint slides"
  homepage "https://github.com/aionstech/homebrew-tap"
  version "1.3.3"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.3/triedit-1.3.3-osx-arm64.tar.gz"
      sha256 "33dc9d640c37c73189867a64ccc8621eb0dcf52c869f5777083da4a557aa36ca"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.3/triedit-1.3.3-osx-x64.tar.gz"
      sha256 "65ddb4f4e86914c8b10c953d41cd84fa3afeaf239dc80eaf648ec4a241edc28b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.3/triedit-1.3.3-linux-arm64.tar.gz"
      sha256 "7f01f5fbaae9678708f8998e022abafc26d12f9acabedcedde84939b3f1bdfc8"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.3/triedit-1.3.3-linux-x64.tar.gz"
      sha256 "e77a58a752aaf00c28599273039142c8f2d509673500d35aa3c802a18e22e7dd"
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
