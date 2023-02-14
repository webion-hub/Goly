import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsSwitcher extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? subtitle;
  final Function onChanged;

  const SettingsSwitcher({
    super.key,
    required this.icon,
    required this.text,
    this.subtitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              //color: Theme.of(context).colorScheme.primary.withOpacity(0.2)
            ),
            child: Icon(icon),
          ),
          title: Text(
            text,
          ),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: CupertinoSwitch(
            onChanged: (value) => onChanged(value),
            value: false,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
