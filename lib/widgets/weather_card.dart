import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;
  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xCD55A1DF), Color(0xFF23ABF6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      weather.city,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
                const Icon(Icons.notifications_none, color: Colors.white),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  "https://openweathermap.org/img/wn/${weather.icon}@2x.png",
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${weather.temperature}°C",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Feels like: ${weather.feelsLike}°C",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              weather.description,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              "Max: ${weather.maxTemp}°  Min: ${weather.minTemp}°",
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoBox("Humidity", "${weather.humidity}%"),
                _infoBox("Wind", "${weather.windSpeed}", isWind: true),
                _infoBox("Precipitation", "${weather.precipitation}%"),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(color: Colors.white38),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoBoxSmall(
                    "Sunrise", _formatTime(weather.sunrise), icon: Icons.wb_sunny),
                _infoBoxSmall(
                    "Sunset", _formatTime(weather.sunset), icon: Icons.nights_stay),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String label, String value, {bool isWind = false}) {
    String displayValue = value;
    if (isWind) {
      final speedMs = double.tryParse(value) ?? 0;
      displayValue = "${(speedMs * 3.6).toStringAsFixed(1)} km/h";
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xAAFFFFFF), Color(0x55B3E5FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(_formatLabel(label), style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(displayValue,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _infoBoxSmall(String label, String value, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xAAFFFFFF), Color(0x55B3E5FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_formatLabel(label), style: const TextStyle(color: Colors.white70)),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(String time24) {
    try {
      final parts = time24.split(":");
      int hour = int.parse(parts[0]);
      final minute = parts.length > 1 ? int.parse(parts[1]) : 0;
      final ampm = hour >= 12 ? "PM" : "AM";
      hour = hour % 12;
      if (hour == 0) hour = 12;
      return "$hour:${minute.toString().padLeft(2,'0')} $ampm";
    } catch (_) {
      return time24;
    }
  }

  String _formatLabel(String label) {
    final lowerWords = ["in", "on", "at", "for", "the", "a", "an", "and", "or", "of"];
    return label.split(' ').map((word) {
      if (lowerWords.contains(word.toLowerCase())) return word.toLowerCase();
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
