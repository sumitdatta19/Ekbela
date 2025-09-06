import 'package:flutter/material.dart';
import 'upload_screen.dart';
import 'meal_detail_screen.dart';
import 'profile_screen.dart';

// ✅ Food data
const List<Map<String, String>> foods = [
  {
    "title": "pasta",
    "location": "Chrn ago, IL",
    "time": "1 hr ago",
    "image": "https://images.unsplash.com/photo-1562967914-608f82629710",
  },
  {
    "title": "Salad",
    "location": "Chrn ago, IL",
    "time": "1 hr ago",
    "image": "https://images.unsplash.com/photo-1562967914-608f82629710",
  },
  {
    "title": "chicken",
    "location": "Chrn ago, IL",
    "time": "1 hr ago",
    "image": "https://images.unsplash.com/photo-1562967914-608f82629710",
  },
  {
    "title": "Salad",
    "location": "Chrn ago, IL",
    "time": "1 hr ago",
    "image": "https://images.unsplash.com/photo-1562967914-608f82629710",
  },
  {
    "title": "biryani",
    "location": "Chrn ago, IL",
    "time": "1 hr ago",
    "image": "https://images.unsplash.com/photo-1562967914-608f82629710",
  },
  {
    "title": "Salad",
    "location": "Chrn ago, IL",
    "time": "1 hr ago",
    "image": "https://images.unsplash.com/photo-1562967914-608f82629710",
  },
  {
    "title": "Salad",
    "location": "Chrn ago, IL",
    "time": "1 hr ago",
    "image": "https://images.unsplash.com/photo-1562967914-608f82629710",
  },
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // ✅ const constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: const Icon(Icons.menu, color: Colors.white),
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ✅ Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          // ✅ Food list
          Expanded(
            child: ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      width: double.infinity, // ✅ Make card stretch full width
                      child: Padding(
                        padding: const EdgeInsets.all(
                          8.0,
                        ), // ✅ Add spacing inside
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Food image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                food["image"]!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Food details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food["title"]!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    food["location"]!,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    food["time"]!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Claim button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MealDetailScreen(
                                      title: food["title"]!,
                                      location: food["location"]!,
                                      time: food["time"]!,
                                      imageUrl: food["image"]!,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text("Claim"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 1) {
            // middle button
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadScreen()),
            );
          } else if (index == 2) {
            // third button (profile)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}
