
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';
import 'post.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(User user) {
    return _db.collection('users').doc(user.uid).set({
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'phoneNumber': user.phoneNumber,
      'location': user.location,
    });
  }

  Future<void> updateUser(User user) {
    return _db.collection('users').doc(user.uid).update({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'phoneNumber': user.phoneNumber,
      'location': user.location,
    });
  }

  Future<void> addPost(Post post) {
    return _db.collection('posts').add({
      'foodName': post.foodName,
      'description': post.description,
      'quantity': post.quantity,
      'location': post.location,
      'availability': post.availability,
      'userId': post.userId,
      'claimedBy': null,
    });
  }

  Stream<List<Post>> getPosts() {
    return _db.collection('posts').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Post.fromFirestore(doc))
        .toList());
  }

  Future<void> claimPost(String postId, String userId) {
    return _db.collection('posts').doc(postId).update({
      'claimedBy': userId,
    });
  }

  Future<User> getUser(String uid) {
    return _db.collection('users').doc(uid).get().then((doc) {
      if (doc.exists) {
        return User(
          uid: uid,
          email: doc.data()!['email'],
          firstName: doc.data()!['firstName'],
          lastName: doc.data()!['lastName'],
          phoneNumber: doc.data()!['phoneNumber'],
          location: doc.data()!['location'],
        );
      } else {
        throw Exception("User not found!");
      }
    });
  }

  Stream<List<Post>> getClaimedPosts(String userId) {
    return _db
        .collection('posts')
        .where('claimedBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList());
  }
}
