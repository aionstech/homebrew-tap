# AIONS Homebrew tap

Homebrew formulae for apps by AIONS (Animated Interactive Objects and Neural Software).

## TriEdit

An office suite for Word documents, PDFs, Excel spreadsheets and PowerPoint presentations. It opens and saves the
standard formats (.docx, .doc, .rtf, .txt, .pdf, .xlsx, .xls, .csv, .pptx, .ppt) and exports any of them to PDF.
It has a Word-style ribbon, Dictate (speech to text on your computer), a resume maker with five designs, built-in
tools such as QR codes, barcodes, word clouds and a unit converter, and light, dark and coloured looks with carved
patterns behind the ribbon.

Add this tap once:

```sh
brew tap aionstech/tap
```

From then on TriEdit installs like any other Homebrew package:

```sh
brew install triedit
```

(Or both steps in one go: `brew install aionstech/tap/triedit`.)

Then start it with `triedit`, or open a file directly: `triedit report.docx`.

Update with `brew upgrade triedit`; remove with `brew uninstall triedit`.

Works on macOS 12 or later (Apple silicon and Intel) and on Linux (x64 and arm64) with a graphical desktop (X11, or Wayland through XWayland).
On Linux it needs the usual desktop libraries (fontconfig, X11) and ICU, which most distributions already have.

### Dictate

Dictate downloads a speech model (75 MB or larger, you choose) the first time you use it, after asking, and then works
offline. On macOS, the microphone permission is asked for the terminal app you start TriEdit from.

### Privacy

On its first start TriEdit asks whether it may report the installation: the operating system, its version and the
processor type, nothing else. Nothing is sent unless you choose Allow, and you can change it later with Privacy on the
Help tab. See the [privacy policy](https://triedit.aions.click/privacy.html).

### About the macOS build

The Mac build is signed during installation for that Mac only (an ad hoc signature), so it runs without an Apple
developer certificate. It is not notarised by Apple.

## Releases

Downloads for every version are on the [releases page](https://github.com/aionstech/homebrew-tap/releases). Current version:
1.3.2.

TriEdit is proprietary software by AIONS. This repository only hosts the Homebrew formula and the release downloads.
