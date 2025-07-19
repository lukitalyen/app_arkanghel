import 'package:app_arkanghel/models/workstream.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_arkanghel/screens/employee/chapter_detail_screen.dart';

class WorkstreamDetailScreen extends StatelessWidget {
  final Workstream workstream;

  const WorkstreamDetailScreen({super.key, required this.workstream});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Error: No user logged in.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        title: Text(
          workstream.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          // Chapters list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workstream.chapters.length,
              itemBuilder: (context, index) {
                final chapter = workstream.chapters[index];
                final isCompleted = user.completedChapterIds.contains(
                  chapter.id,
                );
                final hasVideo =
                    chapter.videoUrl != null && chapter.videoUrl!.isNotEmpty;
                final hasPdf =
                    chapter.pdfUrl != null && chapter.pdfUrl!.isNotEmpty;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCompleted
                          ? const Color(0xFF059669)
                          : const Color(0xFFE5E7EB),
                      width: isCompleted ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ChapterDetailScreen(chapter: chapter),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? const Color(0xFFD1FAE5)
                                      : const Color(0xFFDBEAFE),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  isCompleted
                                      ? Icons.check_circle
                                      : Icons.play_circle_outline,
                                  color: isCompleted
                                      ? const Color(0xFF059669)
                                      : const Color(0xFF1E40AF),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chapter.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Chapter ${index + 1}',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? const Color(0xFFD1FAE5)
                                      : const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isCompleted ? 'Complete' : 'Pending',
                                  style: TextStyle(
                                    color: isCompleted
                                        ? const Color(0xFF059669)
                                        : const Color(0xFF92400E),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            chapter.description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              if (hasVideo) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.play_circle_outline,
                                        size: 16,
                                        color: Color(0xFF1E40AF),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Video',
                                        style: TextStyle(
                                          color: Color(0xFF1E40AF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              if (hasPdf) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.picture_as_pdf_outlined,
                                        size: 16,
                                        color: Color(0xFFDC2626),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'PDF',
                                        style: TextStyle(
                                          color: Color(0xFFDC2626),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFF64748B),
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
