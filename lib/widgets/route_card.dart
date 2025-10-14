import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../models/travel_mode.dart';

class RouteCard extends StatelessWidget {
  final RouteModel route;

  const RouteCard({Key? key, required this.route}) : super(key: key);

  Icon _getIcon(TravelMode mode) {
    switch (mode) {
      case TravelMode.walking:
        return const Icon(Icons.directions_walk, color: Colors.grey, size: 20);
      case TravelMode.bicycle:
        return const Icon(Icons.directions_bike, color: Colors.orange, size: 20);
      case TravelMode.motorcycle:
        return const Icon(Icons.electric_bike, color: Colors.deepPurple, size: 20);
      case TravelMode.car:
        return const Icon(Icons.directions_car, color: Colors.blueGrey, size: 20);
      case TravelMode.bus:
        return const Icon(Icons.directions_bus, color: Colors.blue, size: 20);
      case TravelMode.train:
        return const Icon(Icons.train, color: Colors.green, size: 20);
      case TravelMode.ferry:
        return const Icon(Icons.directions_boat, color: Colors.teal, size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Timeline of segments
            Row(
              children: route.segments.map((s) {
                return Row(
                  children: [
                    _getIcon(s.mode),
                    const SizedBox(width: 4),
                    if (s.line != null && s.line!.isNotEmpty)
                      Text(
                        s.line!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    const SizedBox(width: 8),
                  ],
                );
              }).toList(),
            ),

            const Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "⏱ ${route.durationMinutes ?? 0} min",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                if (route.estimatedCost != null)
                  Text(
                    "৳${route.estimatedCost!.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
