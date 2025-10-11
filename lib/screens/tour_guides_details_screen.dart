import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/tour_guide_model.dart';

class TourGuideDetailScreen extends StatelessWidget {
  final TourGuideModel guide;

  const TourGuideDetailScreen({super.key, required this.guide});

  void _callNumber(BuildContext context, String number) async {
    final Uri url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch call')),
      );
    }
  }

  void _sendMessage(BuildContext context, String number) async {
    final Uri url = Uri.parse('sms:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch message')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF044BA3),
        title: Text(guide.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * 0.4,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(guide.imageAsset),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guide.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    guide.experience,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    guide.bio,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: guide.specialties
                        .map((s) => Chip(
                      label: Text(s, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.blue.shade50,
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('${guide.rating} (${guide.reviewCount} reviews)'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (guide.phone != null)
                    Text('Phone: ${guide.phone}', style: const TextStyle(fontSize: 14)),
                  if (guide.email != null)
                    Text('Email: ${guide.email}', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('Price/Day: \$${guide.pricePerDay}', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Text('Languages: ${guide.languages.join(', ')}', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 12),
                  if (guide.phone != null)
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _callNumber(context, guide.phone!),
                          icon: const Icon(Icons.call),
                          label: const Text("Call Now"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _sendMessage(context, guide.phone!),
                          icon: const Icon(Icons.message),
                          label: const Text("Message"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
