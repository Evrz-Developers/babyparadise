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
      userData?['userId'] = _auth.currentUser!.uid; // Include user ID in user data
      return userData;
    }
    // Return null if user is not logged in
    return null;
  } catch (e) {
    rethrow; // Return error if any
  }
}
