import 'package:flutter/material.dart';

class ReaderNavigationButton extends StatelessWidget {
  const ReaderNavigationButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return SizedBox(
      height: 300,
      width: 40,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Center(
            child: Container(
              width: 34,
              height: 120,
              decoration: BoxDecoration(
                color: disabled ? Colors.black26 : Colors.black54,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              child: Icon(icon, color: disabled ? Colors.white38 : Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
