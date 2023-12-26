import 'package:flutter/material.dart';

class AuthErrorView extends StatelessWidget {
  const AuthErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Um erro inesperado ocorreu durante o login'),
    );
  }
}
