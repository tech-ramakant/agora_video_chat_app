import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_chat_demo/core/app_color.dart';
import 'package:video_chat_demo/core/app_constants.dart';
import 'package:video_chat_demo/core/app_string.dart';
import 'package:video_chat_demo/features/users/presentation/screens/user_list_screen.dart';
import 'package:video_chat_demo/features/video_call/presentation/screens/video_call_screen.dart';

import '../../../../core/di/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailCtrl = TextEditingController(text: AppConstants.TEST_USER_EMAIL);
  final passCtrl = TextEditingController(text: AppConstants.TEST_USER_PASSWORD);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = ref.read(authNotifierProvider).token;

      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserListScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (prev, next) {
      if (next.token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserListScreen()),
        );
      } else if (next.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.title_login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: AppString.label_email),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passCtrl,
              decoration: InputDecoration(labelText: AppString.label_password),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            state.loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      ref
                          .read(authNotifierProvider.notifier)
                          .login(emailCtrl.text.trim(), passCtrl.text.trim());
                    },
                    child: Text(AppString.label_login),
                  ),
          ],
        ),
      ),
    );
  }
}
