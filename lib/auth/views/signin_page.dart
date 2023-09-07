import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mvvm_pattern/auth/repository/auth_service.dart';
import 'package:mvvm_pattern/auth/views/signup_page.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  static const String relativePath = '/signin_page';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height / 3), // 画面の高さの1/3
              SizedBox(
                width: 300,
                height: 50,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'メールアドレスを入力',
                    border: OutlineInputBorder(),
                  ),
                  controller: email,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                height: 50,
                child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'パスワードを入力',
                    border: OutlineInputBorder(),
                  ),
                  controller: password,
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () async {
                  try {
                    await ref.read(authServiceProvider).signIn(
                          email.text,
                          password.text,
                        );
                  } catch (e) {
                    _showErrorSnackbar(context, e.toString());
                  }
                },
                child: const Text('ログイン'),
              ),
              const SizedBox(height: 16),
              TextButton(
                  onPressed: () {
                    context.goNamed(SignUpPage.relativePath);
                  },
                  child: const Text('新規追加')),
              const SizedBox(height: 5),
              TextButton(
                  onPressed: () {
                    // context.goNamed(ForgetPassword.relativePath);
                  },
                  child: const Text('パスワードを忘れた')),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
