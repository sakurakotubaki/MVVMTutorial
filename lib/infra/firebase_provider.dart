import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_pattern/app/model/post.dart';

// Firebaseを利用するためのProvider
final firebaseProvider = Provider((ref) => FirebaseFirestore.instance);

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

// メソッドで使用するWithConverter
final postReferenceWithConverter = Provider.autoDispose((ref) {
  return ref.watch(firebaseProvider).collection('post').withConverter(
        fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
        toFirestore: (post, _) => post.toJson(),
      );
});

// Streamで使用するWithConverter
final poseRefStreamProvider = Provider.autoDispose((ref) {
  return ref.watch(firebaseProvider).collection('post').withConverter<Post?>(// Post? とすることでデータがない場合はnullを返す
      fromFirestore: (ds, _) {
        final data = ds.data();// sanpshot.data()! と同じ
        final id = ds.id;// sanpshot.id と同じ

        if (data == null) {// データがない場合はnullを返す
          return null;
        }
        data['id'] = id;// idを追加
        return Post.fromJson(data);
      },
      toFirestore: (value, _) {
        return value?.toJson() ?? {};// valueがnullの場合は空のMapを返す
      });
});

// 作成した順に取得するためのStreamProvider
final postRefStream = StreamProvider.autoDispose((ref) {
  return ref.watch(poseRefStreamProvider).orderBy('createdAt').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => doc.data()).toList();
  });
});

// Streamで使用するWithConverter
// final postRefrenceWithConverterStream = StreamProvider.autoDispose((ref) {
//   return ref.watch(postRefrenceWithConverter).snapshots().map((snapshot) {
//     return snapshot.docs.map((doc) => doc.data()).toList();
//   });
// });
