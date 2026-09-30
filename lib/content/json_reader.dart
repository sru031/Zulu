import 'dart:convert';

/// Reads the text of a bundled file, e.g. `rootBundle.loadString` in the app
/// or `File(path).readAsString` in tools and tests.
typedef ReadText = Future<String> Function(String assetPath);

/// Thrown when a content or theme JSON file doesn't match its schema.
class ContentFormatException implements Exception {
  ContentFormatException(this.file, this.path, this.message);

  final String file;
  final String path;
  final String message;

  @override
  String toString() => '$file → $path: $message';
}

/// Typed access to decoded JSON where every error names the file and the
/// exact field, e.g. `goal_library.json → $.goals[3].area: expected a string`.
class JsonReader {
  JsonReader(this.file, this.value, [this.path = r'$']);

  factory JsonReader.decode(String file, String source) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (e) {
      throw ContentFormatException(file, r'$', 'invalid JSON (${e.message})');
    }
    return JsonReader(file, decoded);
  }

  final String file;
  final String path;
  final Object? value;

  Never fail(String message) => throw ContentFormatException(file, path, message);

  Map<String, Object?> _asMap() {
    final v = value;
    if (v is Map<String, Object?>) return v;
    fail('expected an object');
  }

  JsonReader _child(String key) => JsonReader(file, _asMap()[key], '$path.$key');

  bool has(String key) => _asMap()[key] != null;

  JsonReader field(String key) {
    final child = _child(key);
    if (child.value == null) child.fail('is required');
    return child;
  }

  JsonReader? optional(String key) => has(key) ? _child(key) : null;

  String asString() {
    final v = value;
    if (v is String) return v;
    fail('expected a string');
  }

  int asInt() {
    final v = value;
    if (v is int) return v;
    fail('expected a whole number');
  }

  double asDouble() {
    final v = value;
    if (v is num) return v.toDouble();
    fail('expected a number');
  }

  bool asBool() {
    final v = value;
    if (v is bool) return v;
    fail('expected true or false');
  }

  List<JsonReader> asList() {
    final v = value;
    if (v is! List<Object?>) fail('expected a list');
    return [for (var i = 0; i < v.length; i++) JsonReader(file, v[i], '$path[$i]')];
  }

  List<String> asStringList() => [for (final r in asList()) r.asString()];

  Map<String, JsonReader> asMap() => {for (final key in _asMap().keys) key: _child(key)};

  String string(String key) => field(key).asString();

  String? optString(String key) => optional(key)?.asString();

  int integer(String key) => field(key).asInt();

  int? optInt(String key) => optional(key)?.asInt();

  double number(String key) => field(key).asDouble();

  double? optNumber(String key) => optional(key)?.asDouble();

  bool boolean(String key, {bool? orElse}) {
    final r = optional(key);
    if (r != null) return r.asBool();
    if (orElse != null) return orElse;
    return field(key).asBool();
  }

  List<JsonReader> list(String key) => field(key).asList();

  List<String> strings(String key) => field(key).asStringList();

  List<String> optStrings(String key) => optional(key)?.asStringList() ?? const [];

  Map<String, JsonReader> map(String key) => field(key).asMap();
}
