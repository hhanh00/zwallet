---
title: Changelog
weight: 80
icon: wrench
---

# 1.4.0

- Support for [Ledger Nano S, Nano S+ and Nano X]({{< relref "advanced/ledger" >}}) (pending Ledger publication)

# 1.3.6

- Auto hide balance setting
- Customizable block explorer
- Improved snackbar
- Don't use memo as subject anymore
- Tweak main account display
- Optimize sync history
- Show FX rate when balance is hidden
- Save server and block explorer selection to DB
- JSON -> flatbuffers
- Rebase librustzcash
- Archlinux pkgbuild
- Flutter 3.7.7
- Fix Crash on UA/O, zview
- Fix reinit when no network
- Fix contact resolver against UA
- Fix display of tx item
- Fix missing address when empty memo
- Fix scan taddrs
- Fix switch account not updating price chart

# 1.3.5

- [Database Encryption]({{< relref "db_encrypt" >}})
- Forgotten Password/Reset App

# 1.3.4

- BIP 39 + 1 extra word
- Merge flatpak/appimage builders
- Add Contact buttons
- Diversifier Addresses by time
- Bug fixes

# 1.3.3

- [Sweep external transparent address]({{< relref "custom_path#sweep-funds" >}})
- Desktop versions save/restore the app window size
- Fix crash when sending to t3 addresses
- Hide titlebar on MacOS
- Barcode scanner & QR save for Batch Backups
- Bug fixes

# 1.3.0

## NU-5 / Orchard
- **Warp Sync support for Orchard**
- Seamless account migration from previous versions
- Sapling & Orchard Transaction Builder
- **Privacy-oriented Transaction Optimizer**
- Minimum Privacy Blocker
- Pool Transfer Page
- Offline Signer (recommended for high value usage scenarios)

## UA
- Multi receiver UA
- UA Receiver Selection
- Sapling/Orchard merged accounts
- Unified Viewing Key
- Unified Diversified Addresses
- Unified Payment URI
- Contacts with UA

## Batch Backups
- Strongly Encrypted with state of the art PK/SK encryption
- Saves every ZCASH & YCASH account
- Saves synchronization data
- Compatible between devices & portable between platforms
- Upward compatible
- Recoverable with third-party open source tools

## UI
- Pre-flight Transaction Report
- Import QR code from image
- Export QR code to PNG

## UI Framework
- Upgrade to Flutter 3.7.x
- UI Revamp: Material UI 3
- Per coin settings

## Distribution
- Universal DMG for MacOS (Intel & Apple chips)
- Android build without Google Play and Google Services. 
  - Runs on FDroid, GrapheneOS, LineageOS, etc.
  - Recommended version for a hardware signer
- AppImage added
- Github Auto-builder for all platforms (except iOS)
- CI Auto publish to Google Play

