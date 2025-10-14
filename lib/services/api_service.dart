import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/route_model.dart';
import '../models/tour_guide_model.dart';
import '../models/tour_package_model.dart';
import '../data/dummy_guides.dart';
import '../data/dummy_packages.dart';
import '../models/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static const String baseUrl =
      'https://firestore.googleapis.com/v1/projects/YOUR-FIREBASE-ID/databases/(default)/documents';

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };


  static Future<List<RouteModel>> searchRoutes(String from, String to) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/routes/search'),
        headers: headers,
        body: jsonEncode({
          'from': from,
          'to': to,
          'date': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic>? routesJson = data['routes'];
        if (routesJson == null) return [];
        return routesJson.map((json) => RouteModel.fromJson(json)).toList();
      } else {
        debugPrint("searchRoutes failed: ${response.body}");
        return [];
      }
    } catch (e) {
      debugPrint("⚠️ Error searching routes: $e");
      return [];
    }
  }

  static Future<bool> saveRoute(RouteModel route) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/routes/save'),
        headers: headers,
        body: jsonEncode(route.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("⚠️ Error saving route: $e");
      return false;
    }
  }

  /// ---------------- TOUR GUIDES ----------------
  Future<List<TourGuideModel>> getTourGuidesDummy() async {
    await Future.delayed(const Duration(seconds: 1));
    return sampleTourGuides;
  }

  Future<List<TourGuideModel>> getTourGuides() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/guides'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic>? guidesJson = data['guides'];
        if (guidesJson == null) return await getTourGuidesDummy();
        return guidesJson.map((json) => TourGuideModel.fromJson(json)).toList();
      } else {
        debugPrint("❌ getTourGuides failed: ${response.body}");
        return await getTourGuidesDummy();
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching guides: $e");
      return await getTourGuidesDummy();
    }
  }

  /// ---------------- TOUR PACKAGES ----------------
  Future<List<TourPackageModel>> getTourPackages() async {
    try {
      final response =
      await http.get(Uri.parse('$baseUrl/packages'), headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic>? packagesJson = data['packages'];
        if (packagesJson == null) return sampleTourPackages;
        return packagesJson
            .map((json) => TourPackageModel.fromJson(json))
            .toList();
      } else {
        debugPrint("❌ getTourPackages failed: ${response.body}");
        return sampleTourPackages;
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching packages: $e");
      return sampleTourPackages;
    }
  }

  static Future<bool> bookPackage(
      String packageId, Map<String, dynamic> bookingData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings/package/$packageId'),
        headers: headers,
        body: jsonEncode(bookingData),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("⚠️ Error booking package: $e");
      return false;
    }
  }
}

/// ---------------- WEATHER SERVICE ----------------

class WeatherService {
  static final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  static const String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<WeatherModel> fetchWeather(String city) async {
    if (city.trim().isEmpty) {
      throw Exception("City name cannot be empty");
    }

    final url = Uri.parse("$baseUrl?q=$city&appid=$apiKey&units=metric");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}
