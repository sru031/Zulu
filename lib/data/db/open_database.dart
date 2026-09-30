import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// Opens `zulu.sqlite` in the app's documents folder.
QueryExecutor openZuluDatabase() => driftDatabase(name: 'zulu');
