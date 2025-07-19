import 'package:app_arkanghel/screens/admin/admin_dashboard_screen.dart';
import 'package:app_arkanghel/screens/admin/assessment_management_screen.dart';
import 'package:app_arkanghel/screens/admin/leaderboard_management_screen.dart';
import 'package:app_arkanghel/screens/admin/user_management_screen.dart';
import 'package:app_arkanghel/screens/admin/workstream_management_screen.dart';
import 'package:app_arkanghel/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class MainAdminScreen extends StatefulWidget {
  const MainAdminScreen({super.key});

  @override
  State<MainAdminScreen> createState() => _MainAdminScreenState();
}

class _MainAdminScreenState extends State<MainAdminScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    AdminDashboardScreen(),
    UserManagementScreen(),
    WorkstreamManagementScreen(),
    AssessmentManagementScreen(),
    LeaderboardManagementScreen(),
  ];

  static const List<String> _widgetTitles = <String>[
    'Admin Dashboard',
    'User Management',
    'Workstream Management',
    'Assessment Management',
    'Leaderboard Management',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_widgetTitles[_selectedIndex]),
      ),
      drawer: AppDrawer(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
