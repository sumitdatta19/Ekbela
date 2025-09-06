import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null 
                ? NetworkImage(user!.photoURL!) 
                : const NetworkImage("https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
            ),
            const SizedBox(height: 16),
            Text(
              user?.displayName ?? "User",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              user?.email ?? "",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Buttons
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text("Edit Profile"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                // Show a dialog to update display name
                final TextEditingController nameController = TextEditingController(text: user?.displayName);
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Edit Profile"),
                    content: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Display Name",
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await user?.updateDisplayName(nameController.text);
                            if (context.mounted) {
                              Navigator.pop(context);
                              // Refresh the screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const ProfileScreen()),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error updating profile: ${e.toString()}')),
                              );
                            }
                          }
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                );
                nameController.dispose();
              },
            ),
            ListTile(
              leading: const Icon(Icons.fastfood, color: Colors.blue),
              title: const Text("My Meals"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigate to user's meals - will be implemented when we add meal storage
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
    );
  }
}
