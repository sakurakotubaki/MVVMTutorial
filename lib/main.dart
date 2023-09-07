import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvvm_pattern/common/my_color.dart';
import 'package:mvvm_pattern/common/router.dart';
import 'package:mvvm_pattern/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        title: 'Flutter Demo',
        theme: ThemeData(
          // テーマを使ってAppBar全体にスタイルを適用する.
          appBarTheme: const AppBarTheme(
            backgroundColor: MY_COLOR,// commonに好みの色を定数として定義しておく
            foregroundColor: Colors.white,
            centerTitle: true,// Androidの場合はAppBarのタイトルを中央に配置する
            elevation: 0,// AppBarの影を消す
          ),
        ));
  }
}
