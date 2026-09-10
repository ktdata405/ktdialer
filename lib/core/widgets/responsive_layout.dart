import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget web;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.web,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return web;
        } else if (constraints.maxWidth >= 650) {
          return tablet ?? web;
        } else {
          return mobile;
        }
      },
    );
  }
}
