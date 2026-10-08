# Recent Screenshots 0.6.0

A small native macOS shelf for your latest ten screenshots, built with Codex for a Logitech screenshot-to-clipboard workflow.

- Two rows of five images, with compact one-row height when there are five or fewer.
- Configurable centered hover zone and a shelf that stays where it opens.
- Click to copy; right-click to open or show in Finder.
- Local clipboard-image history and optional saved-screenshot folder watching.
- Clear-history button, monochrome icon, and optional Open at login.

## Install

Download `Recent Screenshots-0.6.0.pkg`, run it, then open the app from Applications.

This installer targets Apple silicon. Source builds on Intel are possible but untested. The deployment target is macOS 14; runtime checks so far were on macOS 26.6.2.

The installer is unsigned, and the app is ad hoc signed, not notarized. macOS may block the download. Building from source is an alternative; do not disable macOS security protections to install it.

## Please read before using

Clipboard-image capture is enabled by default. Any copied PNG/TIFF image can be stored, including browser images. Only ten clipboard copies are kept; older app-created copies are removed automatically. No text history, network calls, account, or analytics are included. Disable capture in Controls if you do not want it.

This is a personal, vibe-coded project built with OpenAI Codex, shared as-is and not independently security-audited. Clipboard polling may miss rapid changes; real display, permissions, installation, and startup behavior need testing on more machines.

Inspired by Tendedero by Alejandro Buján. This is a separate project with its own icon and is not endorsed by its author or OpenAI.
