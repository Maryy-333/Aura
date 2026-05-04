import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
this database stores posts that users have published in the app.
it is stored in a collection 'Posts' in firebase

Each post contains
- a message
- email of the user
- timestamp

*/

class FirestoreDatabase {
  // curent logged in user
  User? user = FirebaseAuth.instance.currentUser;

  // get collection of posts from firebase
  final CollectionReference posts = FirebaseFirestore.instance.collection(
    'Posts',
  );

  // post a msg
  Future<void> addPost(String message) {
    return posts.add({
      'UserEmail': user!.email,
      'PostMessage': message,
      'Timestamp': Timestamp.now(),
      'Likes': [],
    });
  }

  // read posts from database
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('Timestamp', descending: true)
        .snapshots();

    return postsStream;
  }
}
