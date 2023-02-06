import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DiscoverAppBar extends StatelessWidget implements PreferredSizeWidget{

  const DiscoverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Discover'),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(100);
}