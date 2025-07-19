import 'package:app_arkanghel/models/chapter.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChapterDetailScreen extends StatelessWidget {
  final Chapter chapter;

  const ChapterDetailScreen({super.key, required this.chapter});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser!;
    final isCompleted = user.completedChapterIds.contains(chapter.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(chapter.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chapter.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(chapter.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            if (chapter.videoUrl != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('Watch Video'),
                onPressed: () => _launchURL(chapter.videoUrl!),
              ),
            const SizedBox(height: 12),
            if (chapter.pdfUrl != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('View PDF'),
                onPressed: () => _launchURL(chapter.pdfUrl!),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.green : Theme.of(context).primaryColor,
                ),
                onPressed: isCompleted
                    ? null
                    : () {
                        authService.markChapterAsComplete(chapter.id);
                      },
                child: Text(isCompleted ? 'Completed' : 'Mark as Complete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
