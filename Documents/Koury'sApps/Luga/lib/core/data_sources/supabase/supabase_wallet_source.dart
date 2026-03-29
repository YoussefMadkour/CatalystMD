import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/wallet_model.dart';
import '../../repositories/wallet_repository.dart';

class SupabaseWalletSource implements WalletRepository {
  SupabaseWalletSource(this._client);
  final SupabaseClient _client;

  @override
  Future<WalletModel> getWallet(String userId) async {
    final data = await _client.from('wallets').select('*, transactions:wallet_transactions(*)').eq('user_id', userId).single();
    return WalletModel.fromJson(data);
  }

  @override
  Future<WalletModel> topUp(String userId, double amount, String paymentMethodId) async {
    final data = await _client.functions.invoke('wallet-topup', body: {
      'user_id': userId,
      'amount': amount,
      'payment_method_id': paymentMethodId,
    });
    return WalletModel.fromJson(data.data as Map<String, dynamic>);
  }

  @override
  Future<void> holdEscrow(String userId, String bookingId, double amount) async {
    await _client.functions.invoke('escrow-hold', body: {
      'user_id': userId,
      'booking_id': bookingId,
      'amount': amount,
    });
  }

  @override
  Future<void> releaseEscrow(String bookingId) async {
    await _client.functions.invoke('escrow-release', body: {'booking_id': bookingId});
  }

  @override
  Future<void> refundEscrow(String bookingId) async {
    await _client.functions.invoke('escrow-refund', body: {'booking_id': bookingId});
  }

  @override
  Stream<WalletModel> watchWallet(String userId) {
    return _client.from('wallets').stream(primaryKey: ['id']).eq('user_id', userId).map((rows) => WalletModel.fromJson(rows.first));
  }

  @override
  Future<List<WalletTransaction>> getTransactionHistory(String userId) async {
    final data = await _client.from('wallet_transactions').select().eq('user_id', userId).order('created_at', ascending: false);
    return data.map((e) => WalletTransaction.fromJson(e)).toList();
  }
}
