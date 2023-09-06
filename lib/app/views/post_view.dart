import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_pattern/app/model/post.dart';
import 'package:mvvm_pattern/app/view_model/post_state.dart';
import 'package:mvvm_pattern/infra/firebase_provider.dart';
import 'package:mvvm_pattern/utils/appbar_widget.dart';

class PostView extends ConsumerStatefulWidget {
  const PostView({super.key});

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
      setState(() {
      });
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
      appBar: WidgetUtils.createAppBar('追加ページ'),
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
                      );
                      await ref
                          .read(postStateAsyncProvider.notifier)
                          .addPost(post);
                      _postController.clear();
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
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final postId = posts[index]!.id;
                            var post = Post().copyWith(id: postId);
                            await ref
                                .read(postStateAsyncProvider.notifier)
                                .deletePost(post);
                          },
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
}
