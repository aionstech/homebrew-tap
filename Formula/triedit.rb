class Triedit < Formula
  desc "Office suite for Word documents, PDFs, Excel spreadsheets and PowerPoint slides"
  homepage "https://github.com/aionstech/homebrew-tap"
  version "1.2.0"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.2.0/triedit-1.2.0-osx-arm64.tar.gz"
      sha256 "8a17b3cd0c73d71e8baaa5154c9980ecc7eaf33b435ebe3290934a6a5d093139"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.2.0/triedit-1.2.0-osx-x64.tar.gz"
      sha256 "a2214d8167176c14fd9cf734680c4136c0324766793db82173be94197ae52a33"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.2.0/triedit-1.2.0-linux-arm64.tar.gz"
      sha256 "14eca4a670abed627b9e88efaeafb5fa350c6e056d6f2b3c7e94ad5bd01b96ce"
    end
    on_intel do
      url "https://github.com/aionstech/homebrew-tap/releases/download/triedit-v1.2.0/triedit-1.2.0-linux-x64.tar.gz"
      sha256 "7aeb2a59b301e3c8100f319436947b01a129322b22c42d51f6c23d7d97257f50"
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
