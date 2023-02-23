import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:goly/services/auth_service.dart';
import 'package:goly/widgets/form/buttons/main_button.dart';
import 'package:goly/main.dart';
import 'package:goly/screens/main/profile/handle_profile_screen.dart';
import 'package:goly/utils/utils.dart';
import 'package:goly/widgets/form/input/text_field_input.dart';
import 'package:goly/widgets/layout/indicators.dart';

class SignUp extends StatefulWidget {
  final VoidCallback onClickedSignup;
  const SignUp({super.key, required this.onClickedSignup});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    setState(() {
      isLoading = true;
    });
    try {
      await AuthService.signUpUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).then((value) =>
          GoRouter.of(context).pushReplacement(HandleProfileScreen.routeNameSetUp));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackbBar(e.message);
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(children: [
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
          ]),
        ),
        const SizedBox(height: 20.0),
        isLoading
            ? buffering()
            : MainButton(text: "Sign up", onPressed: signUp),
      ],
    );
  }
}
