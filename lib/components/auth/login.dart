import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goly/components/auth/forgot_password.dart';
import 'package:goly/components/auth/rich_text_with_action.dart';
import 'package:goly/components/fields/email_field.dart';
import 'package:goly/components/fields/password_field.dart';
import 'package:goly/components/dialogs/loading_dialog.dart';
import 'package:goly/components/buttons/main_button.dart';
import 'package:goly/main.dart';
import 'package:goly/utils/utils.dart';

class LogIn extends StatefulWidget {
  final VoidCallback onClickedSignup;
  const LogIn({super.key, required this.onClickedSignup});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final formKey = GlobalKey<FormState>();
  final FocusNode buttonFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future logIn() async {
      final isValid = formKey.currentState!.validate();
      if (!isValid) return;
      loadingDialog(context);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        Utils.showSnackbBar(e.message);
      }
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }

    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              EmailField(
                controller: _emailController,
              ),
              const SizedBox(height: 10.0),
              PasswordField(
                controller: _passwordController,
                nextFocus: buttonFocusNode,
              )
            ],
          ),
        ),
        const ForgotPassword(),
        const SizedBox(height: 20.0),
        MainButton(
          text: "Log in",
          onPressed: logIn,
          focusNode: buttonFocusNode,
        ),
        const SizedBox(height: 20),
        RichTextWithAction(
            text: 'Don\'t have an account?',
            actionText: 'Sign up',
            action: widget.onClickedSignup)
      ],
    );
  }
}
