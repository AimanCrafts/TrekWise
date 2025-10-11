class WeatherModel {
  final String city;
  final String description;
  final double temperature;
  final double minTemp;
  final double maxTemp;
  final double humidity;
  final double windSpeed;
  final double pressure;
  final double precipitation;
  final double feelsLike;
  final String sunrise;
  final String sunset;
  final String icon;

  WeatherModel({
    required this.city,
    required this.description,
    required this.temperature,
    required this.minTemp,
    required this.maxTemp,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.precipitation,
    required this.icon,
    this.feelsLike = 0,
    this.sunrise = '',
    this.sunset = '',
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    double precip = 0;
    if (json['rain'] != null && json['rain']['1h'] != null) {
      precip = (json['rain']['1h'] ?? 0).toDouble();
    } else if (json['snow'] != null && json['snow']['1h'] != null) {
      precip = (json['snow']['1h'] ?? 0).toDouble();
    }

    return WeatherModel(
      city: json['name'] ?? '',
      description: json['weather'][0]['description'] ?? '',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      minTemp: (json['main']['temp_min'] ?? 0).toDouble(),
      maxTemp: (json['main']['temp_max'] ?? 0).toDouble(),
      humidity: (json['main']['humidity'] ?? 0).toDouble(),
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      pressure: (json['main']['pressure'] ?? 0).toDouble(),
      precipitation: precip,
      icon: json['weather'][0]['icon'] ?? '01d',
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      sunrise: json['sys'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
          (json['sys']['sunrise'] ?? 0) * 1000)
          .toLocal()
          .toString()
          .substring(11, 16)
          : '',
      sunset: json['sys'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
          (json['sys']['sunset'] ?? 0) * 1000)
          .toLocal()
          .toString()
          .substring(11, 16)
          : '',
    );
  }
}
