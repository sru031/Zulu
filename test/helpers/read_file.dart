import 'dart:io';

/// Reads a project file the way `rootBundle.loadString` reads an asset.
Future<String> readFile(String path) => File(path).readAsString();
