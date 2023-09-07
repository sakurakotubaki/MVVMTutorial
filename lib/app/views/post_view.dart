import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mvvm_pattern/app/model/infra/user_provider.dart';
import 'package:mvvm_pattern/app/model/post/post.dart';
import 'package:mvvm_pattern/app/view_model/post_async_notifier.dart';
import 'package:mvvm_pattern/app/model/infra/firebase_provider.dart';
import 'package:mvvm_pattern/app/views/person_view.dart';
import 'package:mvvm_pattern/auth/repository/auth_service.dart';

class PostView extends ConsumerStatefulWidget {
  const PostView({super.key});

  static const String relativePath = '/post_view';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostViewState();
}

class _PostViewState extends ConsumerState<PostView> {
  final _postController = TextEditingController();
  // ゲッターで_postControllerの値がnullかどうかを判定
  bool get _isPostControllerEmpty => _postController.text.isEmpty;

  // _postControllerの監視を開始
  @override
  void initState() {
    _postController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  // _postControllerの監視を終了
  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postData = ref.watch(postRefStream);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
              onPressed: () {
                context.goNamed(UserView.relativePath);
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            SizedBox(
              width: 300,
              height: 50,
              child: TextFormField(
                controller: _postController,
                decoration: const InputDecoration(
                  hintText: '投稿内容',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // _isPostControllerEmptyがtrueの場合はボタンを押せないようにする
            _isPostControllerEmpty
                ? const ElevatedButton(
                    onPressed: null, child: Text('値が入力されてません'))
                : ElevatedButton(
                    onPressed: () async {
                      var post = Post(
                        body: _postController.text,
                        createdAt: DateTime.timestamp(),
                        updatedAt: DateTime.timestamp(),
                      );
                      await ref
                          .read(postStateAsyncProvider.notifier)
                          .addPost(post);
                      _postController.clear();
                      /// [強制的更新をかけてデータを取得]
                      // ignore: unused_result
                      ref.refresh(userRefFuture);
                    },
                    child: const Text('追加')),
            Expanded(
              child: postData.when(
                data: (posts) {
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(posts[index]!.body),
                        subtitle: Text(posts[index]!.createdAt.toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    // ダイアログを表示
                                    EditDialog(context, posts, index);
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final postId = posts[index]!.id;
                                  var post = Post().copyWith(id: postId);
                                  await ref
                                      .read(postStateAsyncProvider.notifier)
                                      .deletePost(post);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (_, __) => const Center(child: Text('エラーが発生しました')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> EditDialog(BuildContext context, List<Post?> posts, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('編集'),
          content: TextFormField(
            controller: _postController,
            decoration: const InputDecoration(
              hintText: '投稿内容',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final postId = posts[index]!.id;
                // referenceでデータをコピーする必要がある？。createdAtが上書きされる!
                var post = const Post().copyWith(
                    id: postId,
                    body: _postController.text,
                    updatedAt: DateTime.timestamp());
                await ref
                    .read(postStateAsyncProvider.notifier)
                    .updatePost(post);
                _postController.clear();
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('更新'),
            ),
          ],
        );
      },
    );
  }
}
