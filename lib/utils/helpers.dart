import '../models/route_model.dart';
import '../models/travel_mode.dart';
import '../services/cost_service.dart';

String formatDate(DateTime? date) {
  if (date == null) return '';
  return "${date.day}/${date.month}/${date.year}";
}

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

String formatDistance(double? distanceKm) {
  if (distanceKm == null) return "0.0 km";
  return "${distanceKm.toStringAsFixed(1)} km";
}

String formatDuration(int? durationMinutes) {
  if (durationMinutes == null) return "0 min";
  if (durationMinutes < 60) return "$durationMinutes min";
  final hours = durationMinutes ~/ 60;
  final minutes = durationMinutes % 60;
  return minutes == 0 ? "${hours}h" : "${hours}h ${minutes}m";
}

String formatDurationFromSegment(
    double distanceKm, TravelMode mode, CostService costService) {
  final timeHours = costService.calculateTimeHoursForSegment(distanceKm, mode);
  final totalMinutes = (timeHours * 60).round();
  return formatDuration(totalMinutes);
}

String formatCost(double? cost) {
  if (cost == null) return "N/A";
  return "৳${cost.toStringAsFixed(2)}";
}

String formatEnvironmentalImpact(double? impact) {
  if (impact == null) return "N/A";
  return "${impact.toStringAsFixed(2)} units";
}

List<String> generateDirections(RouteModel route, CostService costService) {
  final steps = <String>[];

  steps.add("Start at ${route.startLocation ?? 'Origin'}");

  for (final segment in route.segments) {
    final durationText =
    formatDurationFromSegment(segment.distanceKm, segment.mode, costService);
    final distanceText = formatDistance(segment.distanceKm);

    switch (segment.mode) {
      case TravelMode.walking:
        steps.add("Walk $distanceText ($durationText)");
        break;

      case TravelMode.bicycle:
        steps.add("Ride Bicycle $distanceText ($durationText)");
        break;

      case TravelMode.motorcycle:
        steps.add("Ride Motorcycle $distanceText ($durationText)");
        break;

      case TravelMode.car:
        steps.add("Drive Car $distanceText ($durationText)");
        break;

      case TravelMode.bus:
        steps.add(
          "Take Bus ${segment.line ?? ''} for $distanceText ($durationText)",
        );
        break;

      case TravelMode.train:
        steps.add(
          "Take Train ${segment.line ?? ''} for $distanceText ($durationText)",
        );
        break;

      case TravelMode.ferry:
        steps.add(
          "Board Ferry ${segment.line ?? ''} for $distanceText ($durationText)",
        );
        break;
    }
  }

  steps.add("Arrive at ${route.endLocation ?? 'Destination'}");
  return steps;
}