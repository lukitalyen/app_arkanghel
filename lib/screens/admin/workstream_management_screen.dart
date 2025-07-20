import 'package:app_arkanghel/models/workstream.dart';
import 'package:app_arkanghel/screens/admin/add_edit_workstream_screen.dart';
import 'package:app_arkanghel/services/content_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkstreamManagementScreen extends StatelessWidget {
  const WorkstreamManagementScreen({super.key});

  void _navigateToAddEditScreen(
    BuildContext context, [
    Workstream? workstream,
  ]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditWorkstreamScreen(workstream: workstream),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Consumer<ContentService>(
        builder: (context, contentService, child) {
          final workstreams = contentService.workstreams;
          return workstreams.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: workstreams.length,
                  itemBuilder: (context, index) {
                    final workstream = workstreams[index];
                    final contentService = Provider.of<ContentService>(context, listen: false);

                    return Dismissible(
                      key: ValueKey(workstream.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: Text(
                                'Are you sure you want to delete "${workstream.title}"? This cannot be undone.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.of(ctx).pop(false),
                              ),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  Navigator.of(ctx).pop(true);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        contentService.deleteWorkstream(workstream.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('"${workstream.title}" deleted.')),
                        );
                      },
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444), // Red
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerRight,
                        child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 30),
                      ),
                      child: _buildWorkstreamCard(context, workstream),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditScreen(context),
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7), // Amber 100
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.school_outlined,
              size: 60,
              color: Color(0xFFB45309), // Amber 700
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Workstreams Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first workstream to get started',
            style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddEditScreen(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Workstream'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkstreamCard(BuildContext context, Workstream workstream) {
    return GestureDetector(
      onTap: () => _navigateToAddEditScreen(context, workstream),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTag(
                  'Module',
                  const Color(0xFFDBEAFE),
                  const Color(0xFF1E40AF),
                ),
                const SizedBox(width: 8),
                _buildTag(
                  workstream.isPublished ? 'Published' : 'Draft',
                  const Color(0xFFFEF3C7),
                  const Color(0xFF92400E),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              workstream.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              workstream.description,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.chat_bubble_outline,
                      '${workstream.chapters.length}',
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      Icons.attachment_outlined,
                      '${_getAttachmentCount(workstream)}',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4B5563),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  int _getAttachmentCount(Workstream workstream) {
    int count = 0;
    for (var chapter in workstream.chapters) {
      if (chapter.pdfUrl != null && chapter.pdfUrl!.isNotEmpty) count++;
      if (chapter.videoUrl != null && chapter.videoUrl!.isNotEmpty) count++;
    }
    return count;
  }
}
