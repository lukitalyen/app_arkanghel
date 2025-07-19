import 'package:app_arkanghel/screens/employee/employee_assessments_screen.dart';
import 'package:app_arkanghel/screens/employee/employee_dashboard_screen.dart';
import 'package:app_arkanghel/screens/employee/employee_leaderboard_screen.dart';
import 'package:app_arkanghel/screens/employee/employee_modules_screen.dart';
import 'package:app_arkanghel/screens/employee/employee_results_screen.dart';
import 'package:app_arkanghel/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

// Placeholder screens





class MainEmployeeScreen extends StatefulWidget {
  const MainEmployeeScreen({super.key});

  @override
  State<MainEmployeeScreen> createState() => _MainEmployeeScreenState();
}

class _MainEmployeeScreenState extends State<MainEmployeeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    EmployeeDashboardScreen(),
    EmployeeModulesScreen(),
    EmployeeAssessmentsScreen(),
    EmployeeResultsScreen(),
    EmployeeLeaderboardScreen(),
  ];

  static const List<String> _widgetTitles = <String>[
    'Dashboard',
    'Modules',
    'Assessments',
    'My Results',
    'Leaderboard',
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
