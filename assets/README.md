# Assets

This directory contains app assets such as images and icons.

## Structure

- `images/` - App screenshots, backgrounds, etc.
- `icons/` - Custom icons and graphics

## Usage

To use assets in your Flutter app, uncomment the assets section in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
```

Then reference them in your code:

```dart
Image.asset('assets/images/logo.png')
```
