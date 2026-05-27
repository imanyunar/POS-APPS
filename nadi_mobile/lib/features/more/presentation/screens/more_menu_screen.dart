import 'package:flutter/material.dart';
import 'package:serve_app/core/constants/colors.dart';

class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ServeColors.bgBase,
      appBar: AppBar(title: const Text('Lainnya')),
      body: const Center(child: Text('More Menu', style: TextStyle(color: ServeColors.textSecondary))),
    );
  }
}
