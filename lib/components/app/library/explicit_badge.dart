import 'package:flutter/material.dart';

class ExplicitBadge extends StatelessWidget {
  const ExplicitBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Text("🅴", style: Theme.of(context).textTheme.labelLarge);
  }
}
