import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String foodName;
  final String description;
  final int quantity;
  final String location;
  final String availability;
  final String userId;
  final String? claimedBy;

  Post({
    required this.id,
    required this.foodName,
    required this.description,
    required this.quantity,
    required this.location,
    required this.availability,
    required this.userId,
    this.claimedBy,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      foodName: data['foodName'] ?? '',
      description: data['description'] ?? '',
      quantity: data['quantity'] ?? 0,
      location: data['location'] ?? '',
      availability: data['availability'] ?? '',
      userId: data['userId'] ?? '',
      claimedBy: data['claimedBy'],
    );
  }
}
