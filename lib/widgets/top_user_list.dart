import 'package:flutter/material.dart';

class TopUserList extends StatelessWidget {
  const TopUserList({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data - in a real app, this would come from a provider or service
    final topUsers = [
      {'name': 'John Doe', 'completed': 25, 'avatar': 'https://i.pravatar.cc/150?img=1'},
      {'name': 'Jane Smith', 'completed': 22, 'avatar': 'https://i.pravatar.cc/150?img=2'},
      {'name': 'Peter Jones', 'completed': 20, 'avatar': 'https://i.pravatar.cc/150?img=3'},
      {'name': 'Mary Williams', 'completed': 18, 'avatar': 'https://i.pravatar.cc/150?img=4'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // To prevent scrolling inside a ListView
      itemCount: topUsers.length,
      itemBuilder: (context, index) {
        final user = topUsers[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user['avatar'] as String),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  user['name'] as String,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 16),
              Text('${user['completed']} completed', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        );
      },
    );
  }
}
