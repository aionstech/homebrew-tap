# AIONS Homebrew tap

Homebrew formulae for apps by AIONS (Animated Interactive Objects and Neural Software).

## TriEdit

An office suite for Word documents, PDFs, Excel spreadsheets and PowerPoint presentations. It opens and saves the
standard formats (.docx, .doc, .rtf, .txt, .pdf, .xlsx, .xls, .csv, .pptx, .ppt) and exports any of them to PDF.

```sh
brew install aionstech/tap/triedit
```

Then start it with `triedit`, or open a file directly: `triedit report.docx`.

Works on macOS 12 or later (Apple silicon and Intel) and on Linux (x64 and arm64) with a graphical desktop (X11, or Wayland through XWayland).
On Linux it needs the usual desktop libraries (fontconfig, X11) and ICU, which most distributions already have.

Update with `brew upgrade triedit`; remove with `brew uninstall triedit`.

### About the macOS build

The Mac build is signed during installation for that Mac only (an ad hoc signature), so it runs without an Apple
developer certificate. It is not notarised by Apple.

## Releases

Downloads for every version are on the [releases page](https://github.com/aionstech/homebrew-tap/releases). Current version:
1.1.0.

TriEdit is proprietary software by AIONS. This repository only hosts the Homebrew formula and the release downloads.
