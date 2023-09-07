import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// FirebaseAuthを利用するためのProvider
final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

// 認証状態を監視するためのProvider
final authStateChangesProvider = StreamProvider((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// uidを取得するためのProvider
final uidProvider = Provider((ref) {
  return ref.watch(authStateChangesProvider).valueOrNull?.uid;
});
