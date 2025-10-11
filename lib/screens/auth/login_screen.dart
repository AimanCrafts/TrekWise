import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trekwise/screens/home_screen.dart';
import 'signup_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool passwordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = credential.user;
      if (user != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful")),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";
      if (e.code == 'user-not-found') message = "No user found with this email.";
      if (e.code == 'wrong-password') message = "Wrong password.";

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: size.height * 0.28,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF044BA3), Color(0xFF49A4F3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                      children: [
                        TextSpan(text: 'Trek',
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.w800),
                          ),
                        ),
                        TextSpan(text: 'Wise',
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(color: Colors.orange[700], fontSize: 40, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Let the Path Find You",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _buildInputField(
                      label: "E-mail",
                      hintText: "Enter E-mail",
                      controller: emailController,
                      obscureText: false,
                    ),
                    SizedBox(height: size.height * 0.025),


                    _buildInputField(
                      label: "Password",
                      hintText: "Enter Password",
                      controller: passwordController,
                      obscureText: !passwordVisible,
                      isPassword: true,
                    ),
                    SizedBox(height: size.height * 0.04),


                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          padding: EdgeInsets.zero,
                        ).copyWith(
                          backgroundColor: WidgetStateProperty.resolveWith(
                                (_) => null,
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.deepOrange, Colors.orangeAccent],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                color: Colors.white)
                                : const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              activeColor: Colors.orangeAccent,
                            ),
                            const Text(
                              "Remember me",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("No account? ",
                                style: TextStyle(color: Colors.black54)),
                            GestureDetector(
                              onTap: _navigateToSignUp,
                              child: const Text(
                                "Create one",
                                style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: const [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Login With",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _socialIconButton("assets/images/google.png", () {

                        }),
                        _socialIconButton("assets/images/facebook.png", () {

                        }),
                        _socialIconButton("assets/images/twitter.png", () {

                        }),
                        _socialIconButton("assets/images/windows.png", () {

                        }),
                      ],
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required bool obscureText,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(isPassword ? Icons.lock : Icons.email),
            filled: true,
            fillColor: Colors.grey[100],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                  color: Colors.deepOrangeAccent, width: 2),
            ),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.black54,
              ),
              onPressed: () {
                setState(() => passwordVisible = !passwordVisible);
              },
            )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _socialIconButton(String asset, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.grey[200], // flat neutral background
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Image.asset(asset, height: 32), // your 32px logos
      ),
    );
  }

}
