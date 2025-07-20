import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_arkanghel/screens/splash_screen.dart';
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
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => ContentService()),
        ChangeNotifierProvider(create: (context) => AssessmentService()),
        ChangeNotifierProxyProvider2<
          AuthService,
          ContentService,
          LeaderboardService
        >(
          create: (context) => LeaderboardService(
            Provider.of<AuthService>(context, listen: false),
            Provider.of<ContentService>(context, listen: false),
          ),
          update: (context, auth, content, leaderboard) =>
              LeaderboardService(auth, content),
        ),
      ],
      child: Consumer<AuthService>(
        builder: (context, auth, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            title: 'Project Arkanghel',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              dialogTheme: const DialogThemeData(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                elevation: 8,
                titleTextStyle: TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                contentTextStyle: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 16,
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            home: const SplashScreen(),
            routes: {'/login': (context) => const LoginScreen()},
          );
        },
      ),
    );
  }
}
