import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController nameController;
  late TextEditingController nicknameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool agree = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    nicknameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    nicknameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhone() async {
    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to Terms & Conditions")),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneController.text.trim(),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification failed: ${e.message}")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OTPScreen(
                verificationId: verificationId,
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
                name: nameController.text.trim(),
                nickname: nicknameController.text.trim(),
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
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
                            textStyle:TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800),
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
                    Center(
                      child: Text(
                        "Sign Up | Create Account",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: size.width * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            label: 'Name',
                            hintText: 'Enter Name',
                            controller: nameController,
                            icon: Icons.person,
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Expanded(
                          child: _buildInputField(
                            label: 'Nickname',
                            hintText: 'Enter Nickname',
                            controller: nicknameController,
                            icon: Icons.tag,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.025),

                    _buildInputField(
                      label: 'Phone Number',
                      hintText: 'Enter Phone Number (+880...)',
                      controller: phoneController,
                      icon: Icons.phone,
                    ),
                    SizedBox(height: size.height * 0.025),

                    _buildInputField(
                      label: 'E-mail',
                      hintText: 'Enter E-mail',
                      controller: emailController,
                      icon: Icons.email,
                    ),
                    SizedBox(height: size.height * 0.025),

                    _buildPasswordField(
                      label: 'Password',
                      controller: passwordController,
                      visible: passwordVisible,
                      onToggle: () =>
                          setState(() => passwordVisible = !passwordVisible),
                    ),
                    SizedBox(height: size.height * 0.025),

                    _buildPasswordField(
                      label: 'Confirm Password',
                      controller: confirmPasswordController,
                      visible: confirmPasswordVisible,
                      onToggle: () => setState(
                              () => confirmPasswordVisible = !confirmPasswordVisible),
                    ),
                    SizedBox(height: size.height * 0.02),

                    Row(
                      children: [
                        Checkbox(
                          value: agree,
                          onChanged: (v) => setState(() => agree = v ?? false),
                          activeColor: Colors.orangeAccent,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {

                            },
                            child: Text(
                              "I agree to the Terms & Conditions",
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),


                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _verifyPhone,
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          padding: EdgeInsets.zero,
                        ).copyWith(
                          backgroundColor: MaterialStateProperty.resolveWith(
                                  (_) => null),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.deepOrange, Colors.orangeAccent],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),


                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
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
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: icon != null ? Icon(icon) : null,
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
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: !visible,
          decoration: InputDecoration(
            hintText: "Enter $label",
            prefixIcon: const Icon(Icons.lock),
            filled: true,
            fillColor: Colors.grey[100],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
              const BorderSide(color: Colors.deepOrangeAccent, width: 2),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: IconButton(
              icon: Icon(
                visible ? Icons.visibility : Icons.visibility_off,
                color: Colors.black54,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}
