import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_pattern/app/model/infra/user_provider.dart';
import 'package:mvvm_pattern/app/model/user/user.dart';
import 'package:mvvm_pattern/app/view_model/user_async_notifier.dart';

class UserView extends ConsumerStatefulWidget {
  const UserView({super.key});

  static const String relativePath = 'user_view';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserViewState();
}

class _UserViewState extends ConsumerState<UserView> {
  final _nameController = TextEditingController();
  final _updateController = TextEditingController();
  // ゲッターで_nameControllerの値がnullかどうかを判定
  bool get _isUserControllerEmpty => _nameController.text.isEmpty;

  // _nameControllerの監視を開始
  @override
  void initState() {
    _nameController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  // _nameControllerの監視を終了
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userRefFuture);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザーページ'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Container(),
            SizedBox(
              width: 300,
              height: 50,
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'ユーザーを追加',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // _isUserControllerEmptyがtrueの場合はボタンを押せないようにする
            _isUserControllerEmpty
                ? const ElevatedButton(
                    onPressed: null, child: Text('値が入力されてません'))
                : ElevatedButton(
                    onPressed: () async {
                      var user = User(
                        name: _nameController.text,
                        createdAt: DateTime.timestamp(),
                        updatedAt: DateTime.timestamp(),
                      );
                      await ref
                          .read(userStateAsyncProvider.notifier)
                          .addUser(user);
                      _nameController.clear();
                      // ignore: unused_result
                      ref.refresh(userRefFuture);
                    },
                    child: const Text('追加')),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 50,
              child: TextFormField(
                controller: _updateController,
                decoration: const InputDecoration(
                  hintText: 'ユーザーを更新',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                  var user = User(
                    name: _updateController.text,
                    createdAt: DateTime.timestamp(),
                    updatedAt: DateTime.timestamp(),
                  );
                  await ref
                      .read(userStateAsyncProvider.notifier)
                      .updateUser(user);
                  _updateController.clear();
                  // ignore: unused_result
                  ref.refresh(userRefFuture);
                },
                child: const Text('更新')),
            const SizedBox(height: 20),
            userData.when(
              data: (db) {
                // DocumentSnapshot<Object?> db
                // existsでドキュメントが存在するかどうかを判定
                if (db.exists) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text('${db.get('name')}',
                            style: const TextStyle(fontSize: 30)),
                        const SizedBox(width: 16),
                        IconButton(
                            onPressed: () async {
                              await ref
                                  .read(userStateAsyncProvider.notifier)
                                  .deleteUser();
                              // ignore: unused_result
                              ref.refresh(userRefFuture);
                            },
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                  );
                } else {
                  return const Text('データが存在しません');
                }
              },
              error: (e, s) => Text('error: $e'),
              loading: () => const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
