import '../models/wallet_model.dart';

/// Wallet ledger — tracks traveler earnings and payouts. All USD.
/// Sender payments go directly through Stripe (no wallet top-up).
abstract class WalletRepository {
  Future<List<WalletLedgerEntry>> getLedger(String userId);
  Future<double> getTravelerBalance(String userId);
  Future<void> requestPayout(String userId, PayoutMethod method);
  Stream<List<WalletLedgerEntry>> watchLedger(String userId);
}
