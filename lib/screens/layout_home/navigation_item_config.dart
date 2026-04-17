import 'package:flutter/material.dart';

class NavigationItemConfig {
  final IconData icon;
  final String label;
  final Widget page;

  const NavigationItemConfig({required this.icon, required this.label, required this.page});
}
