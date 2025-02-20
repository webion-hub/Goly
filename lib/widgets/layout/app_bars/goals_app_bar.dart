import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goly/screens/introductions/explanation_screen.dart';

class GoalsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GoalsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Goals'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => GoRouter.of(context).go(ExplanationScreen.routeName),
          icon: const Icon(Icons.question_mark_rounded),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
