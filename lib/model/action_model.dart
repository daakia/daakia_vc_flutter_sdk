class ActionModel {
  final String? action;
  final String? message;
  final String? token;
  final bool value;

  ActionModel({
    this.action,
    this.message = "",
    this.token = "",
    this.value = true,
  });

  // Converts ActionModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'message': message,
      'token': token,
      'value': value,
    };
  }

  // Creates an ActionModel from JSON
  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
      action: json['action'] as String?,
      message: json['message'] as String? ?? "",
      token: json['token'] as String? ?? "",
      value: json['value'] as bool? ?? true,
    );
  }
}
