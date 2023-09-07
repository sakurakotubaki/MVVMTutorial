import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_pattern/app/model/post/post.dart';
import 'package:mvvm_pattern/app/view_model/post_state.dart';
import 'package:mvvm_pattern/utils/appbar_widget.dart';

class PostUpdate extends ConsumerStatefulWidget {
  const PostUpdate({super.key, required this.post});

  final Post post;

  static const String relativePath = '/post_update';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostUpdateState();
}

class _PostUpdateState extends ConsumerState<PostUpdate> {
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
    return Scaffold(
      appBar: WidgetUtils.createAppBar('編集ページ'),
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
                          .updatePost(post);
                      _postController.clear();
                    },
                    child: const Text('追加')),
          ],
        ),
      ),
    );
  }
}
