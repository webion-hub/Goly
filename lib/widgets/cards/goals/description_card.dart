import 'package:flutter/material.dart';

class DescriptionCard extends StatelessWidget {
  final String? text;
  const DescriptionCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return text == null || text == ""
      ? const SizedBox()
      : SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 1,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description: ",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 20),
                  Text(text!),
                ],
              ),
            ),
          ),
        );
  }
}
