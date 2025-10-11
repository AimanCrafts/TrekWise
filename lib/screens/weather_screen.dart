import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../widgets/weather_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController();

  WeatherModel? _weather;
  bool _loading = false;
  String _city = "Dhaka";

  final List<String> touristCities = [
    "Cox's Bazar",
    "Gazipur",
    "Sajek",
    "Sylhet",
    "Bandarban",
    "Kuakata",
    "Khulna",
    "Srimangal",
    "Rangamati",
  ];

  Map<String, WeatherModel> _touristWeather = {};

  @override
  void initState() {
    super.initState();
    _fetchWeather();
    _fetchTouristWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() => _loading = true);
    try {
      final data = await _weatherService.fetchWeather(_city);
      setState(() {
        _weather = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not fetch weather for $_city")),
      );
    }
  }

  Future<void> _fetchTouristWeather() async {
    for (String city in touristCities) {
      try {
        final data = await _weatherService.fetchWeather(city);
        setState(() {
          _touristWeather[city] = data;
        });
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0960C8), Color(0xFF3C97E8)],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // City input and search button
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _cityController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: "Enter city",
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (_cityController.text.isNotEmpty) {
                    _city = _cityController.text;
                    _fetchWeather();
                    _cityController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(), // capsule shape
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                ),
                child: const Text("Search"),
              ),
            ],
          ),
          const SizedBox(height: 20),


          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _weather != null
                ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WeatherCard(weather: _weather!),
                  const SizedBox(height: 24),

                  if (_touristWeather.isNotEmpty) ...[
                    const Text(
                      "Major Tourist Destinations",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 160,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _touristWeather.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final city =
                          _touristWeather.keys.elementAt(index);
                          final weather = _touristWeather[city]!;
                          return Container(
                            width: 160,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xAAFFFFFF),
                                  Color(0x55B3E5FC)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  city,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Image.network(
                                  "https://openweathermap.org/img/wn/${weather.icon}@2x.png",
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${weather.temperature}°C",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  weather.description,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            )
                : const Center(
              child: Text(
                "No weather data available",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
