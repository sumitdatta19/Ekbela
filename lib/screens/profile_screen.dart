import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import '../firestore_service.dart';
import '../user.dart' as app_user;
import '../post.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final user = FirebaseAuth.instance.currentUser;

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

  void _showEditProfileDialog(app_user.User userProfile) {
    final firstNameController = TextEditingController(text: userProfile.firstName);
    final lastNameController = TextEditingController(text: userProfile.lastName);
    final phoneNumberController =
        TextEditingController(text: userProfile.phoneNumber);
    final locationController = TextEditingController(text: userProfile.location);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
              ),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: "Phone Number"),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: "Location"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              final updatedUser = app_user.User(
                uid: userProfile.uid,
                email: userProfile.email,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                phoneNumber: phoneNumberController.text,
                location: locationController.text,
              );
              try {
                await _firestoreService.updateUser(updatedUser);
                if (mounted) {
                  Navigator.pop(context);
                  setState(() {}); // Refresh the profile screen
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating profile: ${e.toString()}'),
                    ),
                  );
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: FutureBuilder<app_user.User>(
        future: _firestoreService.getUser(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text("User not found."));
          }

          final userProfile = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Profile avatar
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/3135/3135715.png"),
                ),
                const SizedBox(height: 16),
                Text(
                  '${userProfile.firstName} ${userProfile.lastName}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  userProfile.email,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  userProfile.phoneNumber,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  userProfile.location,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // Buttons
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text("Edit Profile"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _showEditProfileDialog(userProfile);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.fastfood, color: Colors.blue),
                  title: const Text("My Meals"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClaimedPostsScreen(userId: user!.uid),
                      ),
                    );
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
          );
        },
      ),
    );
  }
}

class ClaimedPostsScreen extends StatelessWidget {
  final String userId;

  const ClaimedPostsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Claimed Meals'),
      ),
      body: StreamBuilder<List<Post>>(
        stream: FirestoreService().getClaimedPosts(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('You have not claimed any meals yet.'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.foodName),
                subtitle: Text(post.location),
              );
            },
          );
        },
      ),
    );
  }
}