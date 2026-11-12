import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/main_shell.dart';

class DominosApp extends StatelessWidget {
  const DominosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Domino's Pizza",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MainShell(),
    );
  }
}
