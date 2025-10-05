import 'package:flutter/material.dart';

class ButtonSection extends StatelessWidget {
  final EdgeInsetsGeometry buttonPadding;
  const ButtonSection({super.key, required this.buttonPadding});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Transaction'),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/stats');
          },
          icon: const Icon(Icons.bar_chart),
          label: const Text('View Stats'),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
