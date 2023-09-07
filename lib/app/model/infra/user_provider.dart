// user用のwithConverter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_pattern/app/model/infra/firebase_provider.dart';
import 'package:mvvm_pattern/app/model/user/user.dart';
import 'package:mvvm_pattern/auth/model/infra/firebase_provider.dart';

// 別のページに書かないと、fromJsonとtoJsonの箇所がエラーになる
final userReferenceWithConverter = Provider.autoDispose((ref) {
  return ref.watch(firebaseProvider).collection('user').withConverter(
        fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );
});

// 単一のドキュメント取得するuser用のwithConverterを使用したFutureProvider
// async awaitで書く
final userRefFuture = FutureProvider.autoDispose<DocumentSnapshot>((ref) async {
  final uid = ref.read(uidProvider);
  final user = await ref.watch(userReferenceWithConverter).doc(uid).get();
  return user;
});
