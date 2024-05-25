import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<Map<String, dynamic>?> getUserDetails() async {
  try {
    // Fetch user data from Firestore
    if (_auth.currentUser != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

      // Return user data
      return userData;
    }
    // Return null if user is not logged in
    return null;
  } catch (e) {
    // Return error if any
    rethrow;
  }
}
