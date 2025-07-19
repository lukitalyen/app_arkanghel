import 'package:app_arkanghel/models/workstream.dart';
import 'package:flutter/material.dart';
import 'package:app_arkanghel/screens/employee/chapter_detail_screen.dart';

class WorkstreamDetailScreen extends StatelessWidget {
  final Workstream workstream;

  const WorkstreamDetailScreen({super.key, required this.workstream});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workstream.title),
      ),
      body: ListView.builder(
        itemCount: workstream.chapters.length,
        itemBuilder: (context, index) {
          final chapter = workstream.chapters[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.article_outlined),
              title: Text(chapter.title),
              subtitle: Text(chapter.description),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChapterDetailScreen(chapter: chapter),
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
