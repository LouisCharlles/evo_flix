import 'package:flutter/material.dart';

class WindowButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child; 
  final AnimationController? animationController;
  final IconData? icon;
  final String? label;

  const WindowButton({
    super.key,
    required this.onTap,
    required this.child,
    this.animationController,
    this.icon,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}

