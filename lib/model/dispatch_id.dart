import 'dispatch_state.dart';

class DispatchId {
  final String id;
  final String agentName;
  final String room;
  final String metadata;
  final DispatchState state;

  DispatchId({
    required this.id,
    required this.agentName,
    required this.room,
    required this.metadata,
    required this.state,
  });

  factory DispatchId.fromJson(Map<String, dynamic> json) {
    return DispatchId(
      id: json['id'],
      agentName: json['agentName'],
      room: json['room'],
      metadata: json['metadata'],
      state: DispatchState.fromJson(json['state']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'agentName': agentName,
    'room': room,
    'metadata': metadata,
    'state': state.toJson(),
  };
}