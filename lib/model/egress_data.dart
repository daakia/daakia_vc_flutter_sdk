import 'dispatch_id.dart';

class EgressData {
  final String egressId;
  final DispatchId dispatchId;

  EgressData({
    required this.egressId,
    required this.dispatchId,
  });

  factory EgressData.fromJson(Map<String, dynamic> json) {
    return EgressData(
      egressId: json['egress_id'],
      dispatchId: DispatchId.fromJson(json['dispatch_id']),
    );
  }

  Map<String, dynamic> toJson() => {
    'egress_id': egressId,
    'dispatch_id': dispatchId.toJson(),
  };
}