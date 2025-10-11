import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trekwise/screens/settings/settings_screen.dart';
import 'package:trekwise/screens/weather_screen.dart';
import '../data/dummy_packages.dart';
import '../models/tour_package_model.dart';
import 'tour_package_detail_screen.dart';
import 'route_planner_screen.dart';
import 'tour_guides_screen.dart';
import 'tour_packages_screen.dart';
import '../data/dummy_guides.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;


  late List<Widget> _screens = [
    const RoutePlannerListScreen(),
    TourGuidesScreen(guides: sampleTourGuides),
    const TourPackagesScreen(),
    const WeatherScreen(),
  ];

  Future<Map<String, dynamic>> _getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data()!;
  }

  void _showProfilePopup(Map<String, dynamic> userData) {
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
        child: Stack(
          children: [
            Positioned(
              width: 220,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: const Offset(-180, 40),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userData['name']} (${userData['nickname']})',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(userData['phone'] ?? ''),
                        const Divider(),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.settings),
                          title: const Text('Settings'),
                          onTap: () {
                            _overlayEntry?.remove();
                            _overlayEntry = null;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SettingsScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      const RoutePlannerListScreen(),
      TourGuidesScreen(guides: sampleTourGuides),
      const TourPackagesScreen(),
      const WeatherScreen(),
    ];
  }

  List<TourPackageModel> get topRatedPackages =>
      sampleTourPackages.where((pkg) => pkg.rating >= 4.8).toList();

  @override
  Widget build(BuildContext context) {
    final bottomNavHeight = 70.0;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF044BA3), Color(0xFF49A4F3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.route, size: 24),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w900),
                    children: [
                      TextSpan(
                          text: 'Trek',
                          style: GoogleFonts.nunito(
                              textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                          ),
                      ),
                      TextSpan(
                          text: 'Wise',
                          style: GoogleFonts.nunito(
                              textStyle: TextStyle(color: Colors.orange[700], fontWeight: FontWeight.w800),
                          ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          FutureBuilder<Map<String, dynamic>>(
            future: _getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (snapshot.hasData) {
                return CompositedTransformTarget(
                  link: _layerLink,
                  child: IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () => _showProfilePopup(snapshot.data!),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          _screens[_currentIndex],

          if (_currentIndex == 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomNavHeight + 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Top Rated Packages",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 8),

                    // Responsive horizontal list
                    SizedBox(
                      height: screenHeight * 0.25,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: topRatedPackages.length,
                        itemBuilder: (context, index) {
                          final pkg = topRatedPackages[index];

                          final cardWidth = screenWidth * 0.45;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TourPackageDetailScreen(package: pkg),
                                ),
                              );
                            },
                            child: Container(
                              width: cardWidth,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: AssetImage(pkg.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // gradient overlay
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.black54,
                                          Colors.transparent
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    right: 8,
                                    child: Text(
                                      pkg.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex,
                  onTap: (index) => setState(() => _currentIndex = index),
                  selectedItemColor: const Color(0xFF044BA3),
                  unselectedItemColor: const Color(0xFF49A4F3),
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.route), label: 'Planner'),
                    BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Guides'),
                    BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Packages'),
                    BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'Weather'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



