import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_pattern/auth/model/infra/firebase_provider.dart';

final authServiceProvider =
    Provider<AuthService>((ref) => AuthService(ref: ref));
/// [認証用のサービスクラス]
class AuthService {
  Ref ref;
  AuthService({required this.ref});

  Future<UserCredential> signUp(String email, String password) async {
    try {
      final result =
          await ref.read(firebaseAuthProvider).createUserWithEmailAndPassword(
                email: email,
                password: password,
              );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleError(e.code);
    } catch (e) {
      throw 'エラーが発生しました。';
    }
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      final result = await ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
            email: email,
            password: password,
          );
      return result;
    } on FirebaseAuthException catch (e) {
      throw _handleError(e.code);
    } catch (e) {
      throw 'エラーが発生しました。';
    }
  }

  // パスワードのリセット
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await ref.read(firebaseAuthProvider).sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleError(e.code);
    } catch (e) {
      throw 'エラーが発生しました。';
    }
  }

  Future<void> signOut() async {
    await ref.read(firebaseAuthProvider).signOut();
  }

  String _handleError(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'メールアドレスが無効。';
      case 'user-disabled':
        return 'このアカウントは無効になっています。';
      case 'user-not-found':
        return 'アカウントが見つかりません。';
      case 'wrong-password':
        return 'パスワードが一致しません。';
      default:
        return 'エラーが発生しました。';
    }
  }
}