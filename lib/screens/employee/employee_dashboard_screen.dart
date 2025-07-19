import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/services/content_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeDashboardScreen extends StatelessWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final contentService = Provider.of<ContentService>(context);
    final User? user = authService.currentUser;

    if (user == null) {
      // This should not happen if the user is logged in
      return const Center(child: Text('Error: No user logged in.'));
    }

    final assignedWorkstreams = contentService.getWorkstreamsForUser(user);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Welcome, ${user.fullName}!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Text(
            'Your Workstreams',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (assignedWorkstreams.isEmpty)
            const Text('You have not been assigned any workstreams yet.')
          else
            ...assignedWorkstreams.map((workstream) {
              final progress = contentService.getWorkstreamProgress(user, workstream);
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(workstream.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(workstream.description, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      ),
                      const SizedBox(height: 8),
                      Text('${(progress * 100).toStringAsFixed(0)}% Complete'),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
