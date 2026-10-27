class Triedit < Formula
  desc "Office suite for Word documents, PDFs, Excel spreadsheets and PowerPoint slides"
  homepage "https://github.com/aionstech/homebrew-tap"
  version "1.3.2"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.2/triedit-1.3.2-osx-arm64.tar.gz"
      sha256 "d697f1887911585a5c127265959ad41cbb17bbad2179e585968cf3287ac9e5fe"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.2/triedit-1.3.2-osx-x64.tar.gz"
      sha256 "6bce46b187c1a53961598085e58b8d53f6938c3fa453fa4a651df1d02e06a305"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.2/triedit-1.3.2-linux-arm64.tar.gz"
      sha256 "4929ad077e78be8419ae49f8a81a3e746ba192744223e55c51807932afc14f69"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.3.2/triedit-1.3.2-linux-x64.tar.gz"
      sha256 "f6acbe00ce608594f0ade89ccf9e4b9507e261a7544b9f14fdf4ca0a65d4e734"
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
