import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_pattern/app/model/infra/user_provider.dart';
import 'package:mvvm_pattern/app/model/user/user.dart';
import 'package:mvvm_pattern/auth/model/infra/firebase_provider.dart';

// generaterを使ったほうがもっと楽に書ける
final userStateAsyncProvider =
    AsyncNotifierProvider<UserAsyncNotifier, void>(UserAsyncNotifier.new);

// 非同期のデータを扱うので、AutoDisposeAsyncNotifierを使う
class UserAsyncNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // 返り値が無ければ何もしない
  }

  Future<void> addUser(User user) async {
    final uid = ref.read(uidProvider);
    final postRef = ref.read(userReferenceWithConverter);
    state = const AsyncLoading(); // 通信中の状態をセット
    state = await AsyncValue.guard(() async {
      // 通信結果をセット
      await postRef.doc(uid).set(user);
    });
  }

  Future<void> updateUser(User user) async {
    final uid = ref.read(uidProvider);
    final postRef = ref.read(userReferenceWithConverter);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await postRef.doc(uid).update(user.toJson());
    });
  }

  Future<void> deleteUser() async {
    final uid = ref.read(uidProvider);
    final postRef = ref.read(userReferenceWithConverter);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await postRef.doc(uid).delete();
    });
  }
}
