import '../models/route_model.dart';
import '../models/travel_mode.dart';

class CostService {
  final double fuelPricePerLitre;
  final double motorcycleEfficiency;
  final double carEfficiency;
  final double busFarePerKm;
  final double trainFarePerKm;
  final double ferryFarePerKm;
  final double bicycleMaintenancePerKm;
  final double valueOfTimePerHour;

  CostService({
    this.fuelPricePerLitre = 105,
    this.motorcycleEfficiency = 45,
    this.carEfficiency = 12,
    this.busFarePerKm = 2.12,
    this.trainFarePerKm = 1.50,
    this.ferryFarePerKm = 2.00,
    this.bicycleMaintenancePerKm = 0.20,
    this.valueOfTimePerHour = 100,
  });

  final Map<TravelMode, double> _modeSpeeds = {
    TravelMode.walking: 5.0,
    TravelMode.bicycle: 15.0,
    TravelMode.motorcycle: 40.0,
    TravelMode.car: 30.0,
    TravelMode.bus: 25.0,
    TravelMode.train: 60.0,
    TravelMode.ferry: 20.0,
  };

  double calculateTimeHours(RouteModel route) {
    double distance = route.distanceKm;
    double speed = _modeSpeeds[route.mode] ?? 30;
    return distance / speed;
  }

  double calculateTimeHoursForSegment(double distanceKm, TravelMode mode) {
    double speed = _modeSpeeds[mode] ?? 30;
    return distanceKm / speed;
  }

  double calculateCost(RouteModel route) {
    double distance = route.distanceKm;
    double speed = _modeSpeeds[route.mode] ?? 30;
    double timeHours = distance / speed;
    double cost = 0;

    switch (route.mode) {
      case TravelMode.walking:
        cost = timeHours * valueOfTimePerHour * 0.1;
        break;

      case TravelMode.bicycle:
        cost = (distance * bicycleMaintenancePerKm) +
            (timeHours * valueOfTimePerHour * 0.2);
        break;

      case TravelMode.motorcycle:
        double fuelCost = (distance / motorcycleEfficiency) * fuelPricePerLitre;
        cost = fuelCost + (timeHours * valueOfTimePerHour * 0.3);
        break;

      case TravelMode.car:
        double fuelCost = (distance / carEfficiency) * fuelPricePerLitre;
        cost = fuelCost + (timeHours * valueOfTimePerHour * 0.4);
        break;

      case TravelMode.bus:
        double fare = distance * busFarePerKm;
        cost = fare + (timeHours * valueOfTimePerHour * 0.2);
        break;

      case TravelMode.train:
        double fare = distance * trainFarePerKm;
        cost = fare + (timeHours * valueOfTimePerHour * 0.15);
        break;

      case TravelMode.ferry:
        double fare = distance * ferryFarePerKm;
        cost = fare + (timeHours * valueOfTimePerHour * 0.15);
        break;
    }

    return cost;
  }
}
