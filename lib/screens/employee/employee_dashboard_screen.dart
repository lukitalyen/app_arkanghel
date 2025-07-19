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
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            user.fullName.split(' ').map((n) => n[0]).take(2).join(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                user.fullName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${assignedWorkstreams.length} Workstreams Assigned',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KPI Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildKPICard(
                            'Completed',
                            assignedWorkstreams.where((ws) => contentService.getWorkstreamProgress(user, ws) >= 1.0).length.toString(),
                            const Color(0xFF059669),
                            const Color(0xFFD1FAE5),
                            Icons.check_circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildKPICard(
                            'Pending',
                            assignedWorkstreams.where((ws) => contentService.getWorkstreamProgress(user, ws) < 1.0).length.toString(),
                            const Color(0xFFF59E0B),
                            const Color(0xFFFEF3C7),
                            Icons.hourglass_bottom,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Your Learning Path',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (assignedWorkstreams.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
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
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No Workstreams Assigned',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Contact your administrator to get started with learning modules.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...assignedWorkstreams.map((workstream) {
                        final progress = contentService.getWorkstreamProgress(user, workstream);
                        final isComplete = progress >= 1.0;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isComplete ? const Color(0xFF059669) : const Color(0xFF3B82F6),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Workstream Image
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: isComplete 
                                        ? [const Color(0xFF059669), const Color(0xFF10B981)]
                                        : [const Color(0xFF1E40AF), const Color(0xFF3B82F6)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.asset(
                                          'assets/${workstream.id.toUpperCase()}.${workstream.id == 'ws1' || workstream.id == 'ws4' || workstream.id == 'ws6' || workstream.id == 'ws7' ? 'jpg' : 'png'}',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: isComplete 
                                                ? const Color(0xFF059669)
                                                : const Color(0xFF1E40AF),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.white,
                                                  size: 32,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: isComplete ? const Color(0xFF059669) : const Color(0xFFF59E0B),
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Content
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: isComplete ? const Color(0xFFD1FAE5) : const Color(0xFFDBEAFE),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            isComplete ? Icons.check_circle : Icons.play_circle_outline,
                                            color: isComplete ? const Color(0xFF059669) : const Color(0xFF1E40AF),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            workstream.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E293B),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      workstream.description,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Progress',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          '${(progress * 100).toStringAsFixed(0)}%',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isComplete ? const Color(0xFF059669) : const Color(0xFF1E40AF),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 8,
                                      backgroundColor: const Color(0xFFF1F5F9),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        isComplete ? const Color(0xFF059669) : const Color(0xFF1E40AF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKPICard(String title, String value, Color iconColor, Color backgroundColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
