import 'package:flutter/material.dart';
import '../models/tour_package_model.dart';
import '../screens/tour_package_detail_screen.dart';

class DiscoverScreen extends StatelessWidget {
  final List<TourPackageModel> packages;

  const DiscoverScreen({super.key, required this.packages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover"),
        actions: const [
          CircleAvatar(backgroundImage: NetworkImage("https://i.pravatar.cc/150")),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            height: 220,
            child: PageView.builder(
              itemCount: packages.length,
              itemBuilder: (_, index) {
                final pkg = packages[index];
                return _buildBigCard(context, pkg);
              },
            ),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Recommended",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("View All",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurple)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: packages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (_, index) {
                final pkg = packages[index];
                return _buildSmallCard(context, pkg);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBigCard(BuildContext context, TourPackageModel pkg) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TourPackageDetailScreen(package: pkg)),
      ),
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              image: NetworkImage(pkg.imageUrl), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 12,
              left: 12,
              child: Text(pkg.title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(pkg.rating.toStringAsFixed(1),
                      style:
                      const TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard(BuildContext context, TourPackageModel pkg) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TourPackageDetailScreen(package: pkg)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
              image: NetworkImage(pkg.imageUrl), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 8,
              left: 8,
              child: Text(pkg.title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  Text(pkg.rating.toStringAsFixed(1),
                      style:
                      const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
