import '../models/dispute_model.dart';

abstract class DisputeRepository {
  Future<DisputeModel> createDispute(DisputeModel dispute);
  Future<DisputeModel> getDispute(String id);
  Future<List<DisputeModel>> getUserDisputes(String userId);
  Future<DisputeModel> updateStatus(String id, DisputeStatus status, {String? resolution});
}
