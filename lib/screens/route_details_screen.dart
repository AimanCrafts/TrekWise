import 'package:flutter/material.dart';
import 'route_planner_map_screen.dart';
import '../models/travel_mode.dart';

class RoutePlannerListScreen extends StatefulWidget {
  const RoutePlannerListScreen({super.key});

  @override
  State<RoutePlannerListScreen> createState() => _RoutePlannerListScreenState();
}

class _RoutePlannerListScreenState extends State<RoutePlannerListScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  TravelMode _selectedMode = TravelMode.bus;

  bool _loading = false;

  void _goToMap() {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both From and To locations")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoutePlannerMapScreen(
          start: _fromController.text,
          end: _toController.text,
          mode: _selectedMode,
        ),
      ),
    );
  }

  void _swapLocations() {
    setState(() {
      final temp = _fromController.text;
      _fromController.text = _toController.text;
      _toController.text = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(
              controller: _fromController,
              label: "From",
              icon: Icons.my_location,
            ),
            const SizedBox(height: 12),
            _buildSearchBar(
              controller: _toController,
              label: "To",
              icon: Icons.location_on,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _swapLocations,
                      icon: const Icon(Icons.swap_vert, color: Colors.white),
                      label: const Text(
                        "Swap",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: _goToMap,
                      icon: _loading
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Icon(Icons.alt_route),
                      label: const Text(
                        "Plan Route",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade700, size: 20),
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}
