import '../models/travel_mode.dart';

class RouteSegment {
  final TravelMode mode;
  final String line;
  final double distanceKm;
  final int durationMinutes;

  RouteSegment({
    required this.mode,
    required this.line,
    required this.distanceKm,
    required this.durationMinutes,
  });

  factory RouteSegment.fromJson(Map<String, dynamic> json) {
    return RouteSegment(
      mode: TravelMode.values.firstWhere(
            (e) => e.toString().split('.').last == json['mode'],
        orElse: () => TravelMode.walking,
      ),
      line: json['line'] ?? '',
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      durationMinutes: json['durationMinutes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'mode': mode.toString().split('.').last,
    'line': line,
    'distanceKm': distanceKm,
    'durationMinutes': durationMinutes,
  };
}

class RouteModel {
  final String startLocation;
  final String endLocation;
  final List<RouteSegment> segments;
  final int durationMinutes;
  final double distanceKm;
  final double? estimatedCost;
  final double? environmentalImpact;

  RouteModel({
    required this.startLocation,
    required this.endLocation,
    required this.segments,
    required this.durationMinutes,
    required this.distanceKm,
    this.estimatedCost,
    this.environmentalImpact,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      startLocation: json['startLocation'] ?? '',
      endLocation: json['endLocation'] ?? '',
      segments: (json['segments'] as List<dynamic>? ?? [])
          .map((s) => RouteSegment.fromJson(s))
          .toList(),
      durationMinutes: json['durationMinutes'] ?? 0,
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      estimatedCost: (json['estimatedCost'] ?? 0).toDouble(),
      environmentalImpact: (json['environmentalImpact'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'startLocation': startLocation,
    'endLocation': endLocation,
    'segments': segments.map((s) => s.toJson()).toList(),
    'durationMinutes': durationMinutes,
    'distanceKm': distanceKm,
    'estimatedCost': estimatedCost,
    'environmentalImpact': environmentalImpact,
  };

  /// 👇 Add this so CostService works
  TravelMode get mode =>
      segments.isNotEmpty ? segments.first.mode : TravelMode.walking;
}
