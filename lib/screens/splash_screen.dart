import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/screens/login_screen.dart';
import 'package:app_arkanghel/screens/admin/main_admin_screen.dart';
import 'package:app_arkanghel/screens/employee/main_employee_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), _navigateToNextScreen);
  }

  void _navigateToNextScreen() {
    if (!mounted) return;
    final auth = Provider.of<AuthService>(context, listen: false);
    
    Widget nextScreen;
    if (auth.currentUser == null) {
      nextScreen = const LoginScreen();
    } else {
      nextScreen = auth.currentUser!.role == UserRole.admin
          ? const MainAdminScreen()
          : const MainEmployeeScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/logo-only.png', width: 200),
      ),
    );
  }
}
