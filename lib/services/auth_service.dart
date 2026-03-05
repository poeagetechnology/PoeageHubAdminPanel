import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<String?> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = cred.user!;

      UserModel newUser = UserModel(
        uid: user.uid,
        fullName: fullName,
        email: email,
        role: "admin",
        approvalStatus: "approved",
        createdAt: Timestamp.now(),
      );

      await _firestore.collection("users").doc(user.uid).set(newUser.toMap());

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // LOGIN
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot doc =
      await _firestore.collection("users").doc(cred.user!.uid).get();

      if (!doc.exists) {
        return "User data not found";
      }

      final data = doc.data() as Map<String, dynamic>;

      if (data['role'] != "admin") {
        await _auth.signOut();
        return "Access denied. Not an admin.";
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}