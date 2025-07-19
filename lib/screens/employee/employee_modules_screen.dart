import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/services/content_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_arkanghel/screens/employee/workstream_detail_screen.dart';

class EmployeeModulesScreen extends StatelessWidget {
  const EmployeeModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final contentService = Provider.of<ContentService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Center(child: Text('Error: No user logged in.'));
    }

    final assignedWorkstreams = contentService.getWorkstreamsForUser(user);

    return Scaffold(
      body: ListView.builder(
        itemCount: assignedWorkstreams.length,
        itemBuilder: (context, index) {
          final workstream = assignedWorkstreams[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(workstream.title),
              subtitle: Text(workstream.description),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WorkstreamDetailScreen(workstream: workstream),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
