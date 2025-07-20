import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/services/content_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_arkanghel/screens/employee/workstream_detail_screen.dart';

class EmployeeModulesScreen extends StatefulWidget {
  const EmployeeModulesScreen({super.key});

  @override
  State<EmployeeModulesScreen> createState() => _EmployeeModulesScreenState();
}

class _EmployeeModulesScreenState extends State<EmployeeModulesScreen> {
  int _selectedFilter = 0; // 0 = All, 1 = Ongoing, 2 = Completed

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final contentService = Provider.of<ContentService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Center(child: Text('Error: No user logged in.'));
    }

    final assignedWorkstreams = contentService.getWorkstreamsForUser(user);

    // Filtering logic
    List filteredWorkstreams;
    if (_selectedFilter == 1) {
      filteredWorkstreams = assignedWorkstreams.where((ws) => contentService.getWorkstreamProgress(user, ws) < 1.0).toList();
    } else if (_selectedFilter == 2) {
      filteredWorkstreams = assignedWorkstreams.where((ws) => contentService.getWorkstreamProgress(user, ws) >= 1.0).toList();
    } else {
      filteredWorkstreams = assignedWorkstreams;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildFilterChip(
                      icon: Icons.apps,
                      label: 'All',
                      selected: _selectedFilter == 0,
                      color: const Color(0xFF38BDF8),
                      onTap: () => setState(() => _selectedFilter = 0),
                    ),
                    const SizedBox(width: 16),
                    _buildFilterChip(
                      icon: Icons.local_fire_department,
                      label: 'Ongoing',
                      selected: _selectedFilter == 1,
                      color: const Color(0xFFF59E0B),
                      onTap: () => setState(() => _selectedFilter = 1),
                    ),
                    const SizedBox(width: 16),
                    _buildFilterChip(
                      icon: Icons.check_box_outlined,
                      label: 'Completed',
                      selected: _selectedFilter == 2,
                      color: const Color(0xFF6366F1),
                      onTap: () => setState(() => _selectedFilter = 2),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: filteredWorkstreams.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.library_books_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Modules Available',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Contact your administrator to get assigned to workstreams.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: filteredWorkstreams.length,
                      itemBuilder: (context, index) {
                        final workstream = filteredWorkstreams[index];
                        final progress = contentService.getWorkstreamProgress(
                          user,
                          workstream,
                        );
                        final isComplete = progress >= 1.0;
                        final chapterCount = workstream.chapters.length;

                        // Get workstream image path
                        String getWorkstreamImagePath(int workstreamIndex) {
                          final imageExtensions = ['jpg', 'png', 'jpg', 'jpg', 'png', 'jpg', 'jpg'];
                          final wsNumber = (workstreamIndex % 7) + 1;
                          return 'assets/WS$wsNumber.${imageExtensions[wsNumber - 1]}';
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isComplete
                                  ? const Color(0xFF059669)
                                  : const Color(0xFF3B82F6),
                              width: isComplete ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WorkstreamDetailScreen(
                                          workstream: workstream,
                                        ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image header
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      image: DecorationImage(
                                        image: AssetImage(getWorkstreamImagePath(index)),
                                        fit: BoxFit.cover,
                                        onError: (exception, stackTrace) {
                                          // Fallback to gradient if image fails to load
                                        },
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.3),
                                          ],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isComplete
                                                    ? const Color(0xFF059669)
                                                    : const Color(0xFF1E40AF),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                isComplete ? 'Complete' : 'In Progress',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.9),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                isComplete
                                                    ? Icons.check_circle
                                                    : Icons.play_circle_outline,
                                                color: isComplete
                                                    ? const Color(0xFF059669)
                                                    : const Color(0xFF1E40AF),
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Content
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          workstream.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          workstream.description,
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
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Progress',
                                                        style: TextStyle(
                                                          color: Colors.grey[600],
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${(progress * 100).toInt()}%',
                                                        style: TextStyle(
                                                          color: isComplete
                                                              ? const Color(
                                                                  0xFF059669)
                                                              : const Color(
                                                                  0xFF1E40AF),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  LinearProgressIndicator(
                                                    value: progress,
                                                    minHeight: 6,
                                                    backgroundColor: const Color(0xFFF1F5F9),
                                                    valueColor: AlwaysStoppedAnimation<Color>(
                                                      isComplete
                                                          ? const Color(0xFF059669)
                                                          : const Color(0xFF1E40AF),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF1F5F9),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '$chapterCount chapters',
                                                style: const TextStyle(
                                                  color: Color(0xFF64748B),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.13),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: selected ? color : color.withOpacity(0.12),
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? color : Colors.grey[700],
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

