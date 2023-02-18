import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goly/services/auth_service.dart';
import 'package:goly/widgets/auth/forgot_password.dart';
import 'package:goly/widgets/dialogs/loading_dialog.dart';
import 'package:goly/widgets/buttons/main_button.dart';
import 'package:goly/main.dart';
import 'package:goly/utils/utils.dart';
import 'package:goly/widgets/form/text_field_input.dart';

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

  Future logIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    loadingDialog(context);
    var error = await AuthService.logInUser(
        email: _emailController.text, password: _passwordController.text);
    Utils.showSnackbBar(error);
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFieldInput(
                hintText: "Email",
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(height: 10.0),
              TextFieldInput(
                hintText: "Password",
                isPass: true,
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
              ),
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
      ],
    );
  }
}
