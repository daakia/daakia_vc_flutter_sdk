import 'features.dart';

class FeatureData {
  Features? features;

  FeatureData({this.features});

  FeatureData.fromJson(Map<String, dynamic> json) {
    features = json['features'] != null
        ? Features.fromJson(json['features'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (features != null) {
      data['features'] = features!.toJson();
    }
    return data;
  }
}
