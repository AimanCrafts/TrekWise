import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/travel_mode.dart';
import '../services/cost_service.dart';
import '../models/route_model.dart';

class RoutePlannerMapScreen extends StatefulWidget {
  final String start;
  final String end;
  final TravelMode mode;

  const RoutePlannerMapScreen({
    super.key,
    required this.start,
    required this.end,
    required this.mode,
  });

  @override
  State<RoutePlannerMapScreen> createState() => _RoutePlannerMapScreenState();
}

class _RoutePlannerMapScreenState extends State<RoutePlannerMapScreen>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  final CostService _costService = CostService();
  LatLng? _startPoint;
  LatLng? _endPoint;
  List<LatLng> _routePoints = [];
  bool _loading = true;

  double? _distance;
  double? _duration;
  List<dynamic> _steps = [];

  late TabController _tabController;
  late String _startText;
  late String _endText;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
        final mode = [
          TravelMode.walking,
          TravelMode.bicycle,
          TravelMode.motorcycle,
          TravelMode.car,
          TravelMode.bus,
          TravelMode.train,
          TravelMode.ferry,
        ][_tabController.index];
        _getRouteForMode(mode);
      }
    });

    _startText = widget.start;
    _endText = widget.end;

    _initializeRoute();
  }


  Future<void> _initializeRoute() async {
    final startPos = await _searchLocation(_startText);
    final endPos = await _searchLocation(_endText);

    if (startPos != null && endPos != null) {
      setState(() {
        _startPoint = startPos;
        _endPoint = endPos;
      });
      await _getRouteForMode(widget.mode);
    } else {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to locate start or end point")),
      );
    }
  }

  Future<LatLng?> _searchLocation(String query) async {
    final url =
        "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1";
    final response = await http.get(Uri.parse(url), headers: {
      'User-Agent': 'RoutePlannerApp (example@example.com)',
    });

    if (response.statusCode == 200) {
      final results = json.decode(response.body);
      if (results.isNotEmpty) {
        return LatLng(
          double.parse(results[0]['lat']),
          double.parse(results[0]['lon']),
        );
      }
    }
    return null;
  }

  String _getOsrmProfile(TravelMode mode) {
    switch (mode) {
      case TravelMode.walking:
        return "walking";
      case TravelMode.bicycle:
        return "cycling";
      case TravelMode.motorcycle:
        return "driving";
      case TravelMode.car:
        return "driving";
      case TravelMode.bus:
        return "driving";
      case TravelMode.train:
        return "driving";
      case TravelMode.ferry:
        return "driving";
    }
  }

  Future<void> _getRouteForMode(TravelMode mode) async {
    if (_startPoint == null || _endPoint == null) return;

    setState(() => _loading = true);

    final profile = _getOsrmProfile(mode);

    final url =
        "https://router.project-osrm.org/route/v1/$profile/"
        "${_startPoint!.longitude},${_startPoint!.latitude};"
        "${_endPoint!.longitude},${_endPoint!.latitude}"
        "?overview=full&geometries=geojson&steps=true";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if ((data['routes'] as List).isEmpty) {
        await _getMultiModalRoute(mode);
        return;
      }

      final route = data['routes'][0];
      final coords = route['geometry']['coordinates'] as List;
      final points =
      coords.map((c) => LatLng(c[1].toDouble(), c[0].toDouble())).toList();

      final legs = route['legs'] as List;
      final steps = legs.expand((leg) => leg['steps']).toList();

      setState(() {
        _routePoints = points;
        _distance = route['distance']?.toDouble();
        final km = route['distance'].toDouble() / 1000;
        final timeHours = _costService.calculateTimeHoursForSegment(km, mode);
        _duration = timeHours * 3600;
        _steps = steps;
        _loading = false;
      });

      if (points.isNotEmpty) {
        _mapController.move(points.first, 13);
      }
    } else {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch route")),
      );
    }
  }

  Future<void> _getMultiModalRoute(TravelMode mode) async {
    await _getRouteForMode(TravelMode.walking);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
          Text("No full route by ${mode.name}. Using walking fallback.")),
    );
  }

  Icon _getIcon(TravelMode mode) {
    switch (mode) {
      case TravelMode.walking:
        return const Icon(Icons.directions_walk, color: Colors.grey, size: 24);
      case TravelMode.bicycle:
        return const Icon(Icons.directions_bike, color: Colors.orange, size: 24);
      case TravelMode.motorcycle:
        return const Icon(Icons.electric_bike, color: Colors.blue, size: 24);
      case TravelMode.car:
        return const Icon(Icons.directions_car, color: Colors.blueGrey, size: 24);
      case TravelMode.bus:
        return const Icon(Icons.directions_bus, color: Colors.blue, size: 24);
      case TravelMode.train:
        return const Icon(Icons.train, color: Colors.green, size: 24);
      case TravelMode.ferry:
        return const Icon(Icons.directions_boat, color: Colors.teal, size: 24);
    }
  }


  String _formatDistance(double meters) {
    if (meters >= 1000) {
      return "${(meters / 1000).toStringAsFixed(1)} km";
    } else {
      return "${meters.toStringAsFixed(0)} m";
    }
  }

  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).round();
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return "${hours}h ${mins}m";
    } else {
      return "$minutes min";
    }
  }

  double _estimateCost(TravelMode mode) {
    if (_distance == null) return 0;
    final km = _distance! / 1000;

    final timeHours = _costService.calculateTimeHoursForSegment(km, mode);

    final route = RouteModel(
      startLocation: _startText,
      endLocation: _endText,
      distanceKm: km,
      durationMinutes: (timeHours * 60).round(),
      segments: [
        RouteSegment(
          mode: mode,
          line: "",
          distanceKm: km,
          durationMinutes: (timeHours * 60).round(),
        ),
      ],
    );

    return _costService.calculateCost(route);
  }

  double _estimateStepCost(TravelMode mode, double stepDistanceMeters, double stepDurationSeconds) {
    final km = stepDistanceMeters / 1000;
    final stepRoute = RouteModel(
      startLocation: "",
      endLocation: "",
      distanceKm: km,
      durationMinutes: (stepDurationSeconds / 60).round(),
      segments: [
        RouteSegment(
          mode: mode,
          line: "",
          distanceKm: km,
          durationMinutes: (stepDurationSeconds / 60).round(),
        ),
      ],
    );

    return _costService.calculateCost(stepRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _loading
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _startPoint ?? LatLng(23.8103, 90.4125),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.example.trekwise",
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    strokeWidth: 4,
                    color: Colors.blue,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  if (_startPoint != null)
                    Marker(
                      point: _startPoint!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on,
                          color: Colors.green, size: 40),
                    ),
                  if (_endPoint != null)
                    Marker(
                      point: _endPoint!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.flag,
                          color: Colors.red, size: 40),
                    ),
                ],
              ),
            ],
          ),
          if (!_loading && _routePoints.isNotEmpty)
            Positioned(
              top: 20, // lifted higher
              left: 12,
              right: 12,
              child: Column(
                children: [
                  // Row for Back button + Title
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.blue.shade700),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        "Destination",
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.my_location, color: Colors.blueAccent, size: 20),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'From: $_startText',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const VerticalDivider(width: 16, thickness: 1),
                        const Icon(Icons.location_on, color: Colors.blueAccent, size: 20),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'To: $_endText',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Swap button in orange circle
                        InkWell(
                          onTap: () {
                            setState(() {
                              final temp = _startText;
                              _startText = _endText;
                              _endText = temp;
                            });
                            _initializeRoute();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.swap_vert, color: Colors.white, size: 18),
                          ),
                        ),
                        const SizedBox(width: 6),

                        // Search button in blue circle
                        InkWell(
                          onTap: _initializeRoute,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.search, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.25,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 5,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        tabAlignment: TabAlignment.center,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        indicator: const BoxDecoration(),
                        tabs: [
                          _buildModeTab(Icons.directions_walk, "Walk", 0),
                          _buildModeTab(Icons.directions_bike, "Bicycle", 1),
                          _buildModeTab(Icons.electric_bike, "Motorcycle", 2),
                          _buildModeTab(Icons.directions_car, "Car", 3),
                          _buildModeTab(Icons.directions_bus, "Bus", 4),
                          _buildModeTab(Icons.train, "Train", 5),
                          _buildModeTab(Icons.directions_boat, "Ferry", 6),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildModeInfo(TravelMode.walking, scrollController),
                          _buildModeInfo(TravelMode.bicycle, scrollController),
                          _buildModeInfo(TravelMode.motorcycle, scrollController),
                          _buildModeInfo(TravelMode.car, scrollController),
                          _buildModeInfo(TravelMode.bus, scrollController),
                          _buildModeInfo(TravelMode.train, scrollController),
                          _buildModeInfo(TravelMode.ferry, scrollController),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab(IconData icon, String text, int index) {
    final isSelected = _tabController.index == index;

    return Tab(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isSelected)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF044BA3), Color(0xFF49A4F3)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.blueGrey,
                size: 26,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.blue.shade700 : Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeInfo(TravelMode mode, ScrollController scrollController) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(12),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: _getIcon(mode),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _duration != null
                          ? "Estimated Time: ${_formatDuration(_duration!)}"
                          : "Time unavailable",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        shadows: const [
                          Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black26)
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _distance != null
                          ? "Total Distance: ${_formatDistance(_distance!)}"
                          : "Distance unavailable",
                      style: TextStyle(
                        color: Colors.blueGrey[700],
                        fontSize: 13,
                        shadows: const [
                          Shadow(offset: Offset(0, 0.5), blurRadius: 1, color: Colors.black12)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "৳${_estimateCost(mode).round()}",
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  shadows: const [
                    Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black26)
                  ],
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
          child: Text(
            "Step-by-Step Route",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
              shadows: const [
                Shadow(offset: Offset(0, 1), blurRadius: 2, color: Colors.black26)
              ],
            ),
          ),
        ),

        ..._steps.map((step) {
          final stepDuration = (step['duration'] as num).toDouble();
          final stepDistance = (step['distance'] as num).toDouble();
          final stepName = (step['name'] as String?)?.isNotEmpty == true
              ? step['name'] as String
              : "Unnamed road";

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 14,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: _getIcon(mode),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stepName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.black26,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Distance
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Distance: ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _formatDistance(stepDistance),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // align left edges
                        children: [
                          // Travel Time
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Travel Time: ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                TextSpan(
                                  text: _formatDuration(stepDuration),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Cost
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Cost            : ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                TextSpan(
                                  text: "৳${_estimateStepCost(mode, stepDistance, stepDuration).round()}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
