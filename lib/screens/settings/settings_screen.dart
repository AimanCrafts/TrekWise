import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trekwise/screens/settings/sub_settings_screen/edit_profile_screen.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm();
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 0, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildCardSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required Color iconColor,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          // Profile Section
          _sectionHeader("Profile"),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName ?? "Username",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? "user@email.com",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    bool updated = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                    );

                    if (updated) {
                      // Reload user from FirebaseAuth
                      await FirebaseAuth.instance.currentUser?.reload();
                      setState(() {
                        user = FirebaseAuth.instance.currentUser;
                      });
                    }
                  },
                ),
              ],
            ),
          ),


          _sectionHeader("Security"),
          _buildCardSection([
            _buildListTile(
              icon: Icons.lock,
              title: "Change Password",
              iconColor: Colors.redAccent,
              onTap: () {},
            ),
          ]),


          _sectionHeader("General"),
          _buildCardSection([
            _buildListTile(
              icon: Icons.directions_walk,
              title: "Step data source",
              iconColor: Colors.orange,
              onTap: () {},
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.language,
              title: "Language",
              iconColor: Colors.purple,
              onTap: () {},
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.privacy_tip,
              title: "Privacy",
              iconColor: Colors.teal,
              onTap: () {},
            ),
          ]),


          _sectionHeader("Premium"),
          _buildCardSection([
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE0F2FE),
                child: Icon(Icons.diamond, color: Colors.blue),
              ),
              title: const Text("Premium Status"),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("Inactive", style: TextStyle(color: Colors.orange)),
              ),
              onTap: () {},
            ),
          ]),


          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.group, color: Colors.white, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Refer a friend",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 4),
                      Text("Earn 50 points per referral",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ],
            ),
          ),


          _sectionHeader("App"),
          _buildCardSection([
            _buildListTile(
              icon: Icons.apps,
              title: "App Icon",
              iconColor: Colors.teal,
              onTap: () {},
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.widgets,
              title: "Widget",
              iconColor: Colors.indigo,
              onTap: () {},
            ),
          ]),


          _sectionHeader("Account"),
          _buildCardSection([
            _buildListTile(
              icon: Icons.logout,
              title: "Sign Out",
              iconColor: Colors.redAccent,
              trailing: null,
              onTap: () {
                _showConfirmationDialog(
                  context: context,
                  title: "Sign Out",
                  content: "Are you sure you want to log out?",
                  onConfirm: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                    );
                  },
                );
              },
            ),
            const Divider(height: 1),
            _buildListTile(
              icon: Icons.delete_forever,
              title: "Delete Account",
              iconColor: Colors.red,
              trailing: null,
              onTap: () {
                _showConfirmationDialog(
                  context: context,
                  title: "Delete Account",
                  content: "Are you sure you want to delete your account?",
                  onConfirm: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
                      await user.delete();
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                    );
                  },
                );
              },
            ),
          ]),
        ],
      ),
    );
  }
}
