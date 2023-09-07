import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_pattern/app/model/infra/firebase_provider.dart';
import 'package:mvvm_pattern/app/model/post/post.dart';

// generaterを使ったほうがもっと楽に書ける
final postStateAsyncProvider =  AsyncNotifierProvider<PostAsyncNotifier, void>(PostAsyncNotifier.new);
// 非同期のデータを扱うので、AutoDisposeAsyncNotifierを使う
class PostAsyncNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // 返り値が無ければ何もしない
  }

  Future<void> addPost(Post post) async {
    final postRef = ref.read(postReferenceWithConverter);
    state = const AsyncLoading();// 通信中の状態をセット
    state = await AsyncValue.guard(() async {// 通信結果をセット
      await postRef.add(post);
    });
  }

  Future<void> updatePost(Post post) async {
    final postRef = ref.read(postReferenceWithConverter);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await postRef.doc(post.id).update(post.toJson());
    });
  }

  Future<void> deletePost(Post post) async {
    final postRef = ref.read(postReferenceWithConverter);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await postRef.doc(post.id).delete();
    });
  }
}
