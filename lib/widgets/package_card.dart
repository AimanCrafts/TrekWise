import 'package:flutter/material.dart';
import '../models/tour_package_model.dart';
import '../utils/helpers.dart';

class PackageCard extends StatelessWidget {
  final TourPackageModel package;
  const PackageCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(package.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Duration: ${package.duration} days\nPrice: \$${package.price}"),
        trailing: Text(formatDate(package.startDate)),
      ),
    );
  }
}
