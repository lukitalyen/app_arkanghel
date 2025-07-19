import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/screens/admin/main_admin_screen.dart';
import 'package:app_arkanghel/screens/employee/main_employee_screen.dart';
import 'package:app_arkanghel/screens/login_screen.dart';
import 'package:app_arkanghel/services/assessment_service.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/services/content_service.dart';
import 'package:app_arkanghel/services/leaderboard_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => AssessmentService()),
        ChangeNotifierProvider(create: (_) => LeaderboardService()),
        ChangeNotifierProvider(create: (_) => ContentService()),
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Project Arkanghel',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: auth.currentUser == null
                ? const LoginScreen()
                : auth.currentUser!.role == UserRole.admin
                    ? const MainAdminScreen()
                    : const MainEmployeeScreen(),
            routes: {
              '/login': (context) => const LoginScreen(),
            },
          );
        },
      ),
    );
  }
}
