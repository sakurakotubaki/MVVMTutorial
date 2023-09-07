import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mvvm_pattern/app/views/person_view.dart';
import 'package:mvvm_pattern/app/views/post_view.dart';
import 'package:mvvm_pattern/auth/model/infra/firebase_provider.dart';
import 'package:mvvm_pattern/auth/views/signin_page.dart';
import 'package:mvvm_pattern/auth/views/signup_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return GoRouter(
      initialLocation: SignInPage.relativePath,
      redirect: (BuildContext context, GoRouterState state) async {
        // ログインしていない場合は、ログインページにリダイレクトする
        if (authState.isLoading || authState.hasError) return null;

        // ログインしていなければ、ログインページにリダイレクトする
        // ignore: unrelated_type_equality_checks
        final isStart = state.matchedLocation == SignInPage.relativePath;

        // ログインしているかどうかを判定する
        // valueOrNullは、値がnullの場合はnullを返す
        final isAuth = authState.valueOrNull != null;

        // ログインしていない場合は、リダイレクトせずボタンを押すと次のページは画面遷移する
        if (isStart && !isAuth) {
          return null;
        }

        if (!isStart) {
          return null;
        }

        // ユーザーがログインしていれば、ログイン後のページへリダイレクトする
        if (isAuth) {
          return PostView.relativePath;
        }
      },
      routes: [
        GoRoute(
            path: SignInPage.relativePath,
            name: SignInPage.relativePath,
            builder: (context, state) {
              return const SignInPage();
            },
            routes: [
              GoRoute(
                path: SignUpPage.relativePath,
                name: SignUpPage.relativePath,
                builder: (context, state) {
                  return const SignUpPage();
                },
              ),
            ]),
        GoRoute(
            path: PostView.relativePath,
            name: PostView.relativePath,
            builder: (context, state) {
              return const PostView();
            },
            routes: [
              GoRoute(
                path: UserView.relativePath,
                name: UserView.relativePath,
                builder: (context, state) {
                  return const UserView();
                },
              )
            ]),
      ]);
});
