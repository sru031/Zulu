import 'package:drift/drift.dart';

import '../../core/clock.dart';
import '../db/database.dart';

/// Coins as a ledger: every earn or refund is a row, the balance is the sum.
class WalletRepository {
  WalletRepository(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  Selectable<int> get _sum {
    final total = _db.walletLedger.amount.sum();
    return (_db.selectOnly(_db.walletLedger)..addColumns([total])).map((r) => r.read(total) ?? 0);
  }

  Future<int> balance() => _sum.getSingle();

  Stream<int> watchBalance() => _sum.watchSingle();

  Future<void> add(int amount, String reason, {String? refId}) async {
    await _db.into(_db.walletLedger).insert(WalletLedgerCompanion.insert(
          amount: amount,
          reason: reason,
          refId: Value(refId),
          createdAt: _clock.now(),
        ));
  }
}
