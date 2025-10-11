import 'package:flutter/material.dart';
import '../models/tour_guide_model.dart';

class GuideCard extends StatelessWidget {
  final TourGuideModel guide;
  const GuideCard({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(guide.imageAsset),
        ),
        title: Text(guide.name),
        subtitle: Text("Experience: ${guide.experience} years"),
      ),
    );
  }
}
