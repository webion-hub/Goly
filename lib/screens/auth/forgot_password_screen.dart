import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goly/widgets/form/buttons/main_button.dart';
import 'package:goly/widgets/dialogs/loading_dialog.dart';
import 'package:goly/utils/constants.dart';
import 'package:goly/utils/utils.dart';
import 'package:goly/widgets/form/input/text_field_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forgot-password';
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  final _emailController = TextEditingController(text: '');
  Future resetPassword() async {
    loadingDialog(context);
    try {
      var nav = Navigator.of(context);

      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      Utils.showSnackbBar('Password Reset Email Sent');

      nav.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackbBar(e.message);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: Constants.pagePadding,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Insert your email to reset your password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                  Form(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      TextFieldInput(label: 'Email', textEditingController: _emailController, hintText: 'Email', textInputType: TextInputType.emailAddress),
                      const SizedBox(height: 30),
                      MainButton(
                        onPressed: resetPassword,
                        text: 'Reset password',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
