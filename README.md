# Zulu

A gentle self-care pet app, built with Flutter. Android first; iOS later from the same code.

- Design spec: `docs/superpowers/specs/2026-09-29-zulu-v1-design.md`
- Build plans: `docs/superpowers/plans/`

## Setup (Windows)

1. Turn on **Developer Mode**: Settings → System → For developers. Flutter needs it to build plugins.
2. The Flutter SDK is at `C:\src\flutter`. Add `C:\src\flutter\bin` to your user PATH to use `flutter` and `dart` directly.
3. Start an Android emulator from Android Studio (Device Manager).

## Everyday commands

```bash
flutter run                                         # run on the emulator
flutter test                                        # all tests
flutter analyze                                     # lints
dart run tool/validate_assets.dart                  # check art + content references
dart run build_runner build --delete-conflicting-outputs --force-jit   # after changing database tables
dart run tool/gen_placeholders.dart                 # regenerate placeholder art (overwrites!)
```

## Replacing the art

All art, colors and in-world names live in `assets/theme/`:

| File | What it controls |
|---|---|
| `theme.json` | App name, pet species name, currency name and icon, light and dark colors, the 5 mood icons |
| `pet/pet.json` | Egg images, and each growth stage's poses (`png`, `rive` or `lottie`) plus where outfits sit |
| `items/items.json` | Outfits and decor: name, slot, price, image |
| `rooms/rooms.json` | The home background and where decor goes |
| `effects/effects.json` | Lottie celebration effects |

To swap a picture, replace the file and keep its name. For example, replace `assets/theme/pet/baby/happy.png` with your own 512×512 PNG. To use a Rive or Lottie pose, change that pose's `type` and `path` in `pet/pet.json`. If you add a new folder, list it under `flutter: assets:` in `pubspec.yaml`.

Then run `dart run tool/validate_assets.dart`. It lists anything missing, misnamed (letter case matters on Android) or the wrong size.
