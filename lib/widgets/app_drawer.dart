import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const AppDrawer({super.key, required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userRole = authService.currentUser?.role;

    return Drawer(
      child: Theme(
        data: Theme.of(context).copyWith(
          listTileTheme: ListTileThemeData(
            selectedTileColor: Colors.blue[100],
            selectedColor: Colors.blue[800],
            iconColor: Colors.grey[600],
          ),
        ),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Image.asset('assets/logo.png'),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: userRole == UserRole.admin
                    ? _buildAdminMenuItems(context, selectedIndex)
                    : _buildEmployeeMenuItems(context, selectedIndex),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.grey[600]),
              title: const Text('Logout'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        TextButton(
                          child: const Text('Logout'),
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop(); 
                            // Logout the user
                            Provider.of<AuthService>(context, listen: false).logout();
                            // Navigate to login screen and remove all previous routes
                            navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAdminMenuItems(BuildContext context, int selectedIndex) {
    return [
      _DrawerMenuItem(
        icon: Icons.dashboard,
        title: 'Dashboard',
        isSelected: selectedIndex == 0,
        onTap: () => onItemTapped(0),
      ),
      _DrawerMenuItem(
        icon: Icons.people,
        title: 'User Management',
        isSelected: selectedIndex == 1,
        onTap: () => onItemTapped(1),
      ),
      _DrawerMenuItem(
        icon: Icons.work,
        title: 'Workstream Management',
        isSelected: selectedIndex == 2,
        onTap: () => onItemTapped(2),
      ),
      _DrawerMenuItem(
        icon: Icons.assignment,
        title: 'Assessment Management',
        isSelected: selectedIndex == 3,
        onTap: () => onItemTapped(3),
      ),
      _DrawerMenuItem(
        icon: Icons.leaderboard,
        title: 'Leaderboard',
        isSelected: selectedIndex == 4,
        onTap: () => onItemTapped(4),
      ),
    ];
  }

  List<Widget> _buildEmployeeMenuItems(BuildContext context, int selectedIndex) {
    return [
      _DrawerMenuItem(
        icon: Icons.dashboard,
        title: 'Dashboard',
        isSelected: selectedIndex == 0,
        onTap: () => onItemTapped(0),
      ),
      _DrawerMenuItem(
        icon: Icons.book,
        title: 'Modules',
        isSelected: selectedIndex == 1,
        onTap: () => onItemTapped(1),
      ),
      _DrawerMenuItem(
        icon: Icons.assignment,
        title: 'Assessment Management',
        isSelected: selectedIndex == 2,
        onTap: () => onItemTapped(2),
      ),
      _DrawerMenuItem(
        icon: Icons.bar_chart,
        title: 'Results',
        isSelected: selectedIndex == 3,
        onTap: () => onItemTapped(3),
      ),
      _DrawerMenuItem(
        icon: Icons.leaderboard,
        title: 'Leaderboard',
        isSelected: selectedIndex == 4,
        onTap: () => onItemTapped(4),
      ),
    ];
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 40, 
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[800] : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  leading: Icon(
                    icon,
                    color: isSelected ? Colors.blue[800] : Colors.grey[600],
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.blue[800] : Colors.black87,
                    ),
                  ),
                  selected: isSelected,
                  onTap: onTap, // InkWell handles the tap, but this is good for semantics
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
