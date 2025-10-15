class DispatchState {
  final List<dynamic> jobs;
  final String createdAt;
  final String deletedAt;

  DispatchState({
    required this.jobs,
    required this.createdAt,
    required this.deletedAt,
  });

  factory DispatchState.fromJson(Map<String, dynamic> json) {
    return DispatchState(
      jobs: List<dynamic>.from(json['jobs'] ?? []),
      createdAt: json['createdAt'],
      deletedAt: json['deletedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
    'jobs': jobs,
    'createdAt': createdAt,
    'deletedAt': deletedAt,
  };
}