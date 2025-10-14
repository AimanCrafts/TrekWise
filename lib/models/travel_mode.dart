enum TravelMode {
  walking,
  bicycle,
  motorcycle,
  car,
  bus,
  train,
  ferry,
}

extension TravelModeExtension on TravelMode {
  String get name {
    switch (this) {
      case TravelMode.walking:
        return "Walking";
      case TravelMode.bicycle:
        return "Bicycle";
      case TravelMode.motorcycle:
        return "Motorcycle";
      case TravelMode.car:
        return "Car";
      case TravelMode.bus:
        return "Bus";
      case TravelMode.train:
        return "Train";
      case TravelMode.ferry:
        return "Ferry";
    }
  }
}

