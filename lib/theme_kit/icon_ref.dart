/// An icon that is either an emoji/text glyph or an image path relative to
/// `assets/theme/`.
class IconRef {
  const IconRef(this.value);

  final String value;

  static final _imagePattern = RegExp(r'\.(png|webp|jpe?g)$', caseSensitive: false);

  bool get isImage => _imagePattern.hasMatch(value);
}
