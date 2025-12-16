import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await cred.user?.updateDisplayName(displayName);

    await _firestore.collection('users').doc(cred.user!.uid).set({
      'email': email,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return cred;
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();
}
