import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/wallet_model.dart';

final walletProvider = FutureProvider<WalletModel?>((ref) async {
  // TODO: Fetch wallet from repository
  return null;
});
