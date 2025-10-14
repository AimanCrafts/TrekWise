import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/animated_route_icon.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF044BA3), Color(0xFF49A4F3)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedRouteIcon(size: 150),
              const SizedBox(height: 25),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                  children: [
                    TextSpan(text: 'Trek',
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w800),
                      ),
                    ),
                    TextSpan(text: 'Wise',
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(color: Colors.orange[700], fontSize: 50, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Let the Path Find You',
                style: TextStyle(fontSize: 20, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
