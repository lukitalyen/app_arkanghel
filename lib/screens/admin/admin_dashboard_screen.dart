import 'package:app_arkanghel/services/auth_service.dart';
import 'package:app_arkanghel/widgets/critical_learning_areas.dart';
import 'package:app_arkanghel/widgets/top_user_list.dart';
import 'package:app_arkanghel/widgets/charts/assessment_tracker_chart.dart';
import 'package:app_arkanghel/widgets/charts/overview_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TimePeriod { week, month, year }

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  TimePeriod _selectedPeriod = TimePeriod.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Summary Cards
          Consumer<AuthService>(
            builder: (context, authService, child) {
              final userCount = authService.users.length.toString();
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SummaryCard(title: 'Total Users', value: userCount, icon: Icons.people, color: Colors.blue)),
                  const SizedBox(width: 16),
                  const Expanded(child: SummaryCard(title: 'Overall Score Assessment', value: '80%', icon: Icons.assessment, color: Colors.orange)),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: SummaryCard(title: 'Learning Module (Completed)', value: '5', icon: Icons.book, color: Colors.green)),
              SizedBox(width: 16),
              Expanded(child: SummaryCard(title: 'Module Assessment (Completed)', value: '4', icon: Icons.check_circle, color: Colors.red)),
            ],
          ),
          const SizedBox(height: 24),
          // Overview Chart
          ChartCard(
            title: 'User Engagements Overview',
            onViewAll: () {},
            child: SizedBox(height: 200, child: OverviewChart(period: _selectedPeriod)),
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (period) {
              if (period != null) {
                setState(() {
                  _selectedPeriod = period;
                });
              }
            },
          ),
          const SizedBox(height: 24),
          // Training Module Assessment Tracker
          const ChartCard(
            title: 'Training Module Assessment Tracker',
            child: SizedBox(height: 200, child: AssessmentTrackerChart()),
          ),
          const SizedBox(height: 24),
          // Top User Completed Tracker
          const ChartCard(
            title: 'Top User Completed Tracker',
            child: TopUserList(),
          ),
          const SizedBox(height: 24),
          // Critical Learning Areas
          const ChartCard(
            title: 'Critical Learning Areas',
            child: CriticalLearningAreas(),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({super.key, required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 100, // Enforce a consistent height
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ),
                Icon(icon, color: color),
              ],
            ),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onViewAll;
  final TimePeriod? selectedPeriod;
  final ValueChanged<TimePeriod?>? onPeriodChanged;

  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.onViewAll,
    this.selectedPeriod,
    this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (selectedPeriod != null && onPeriodChanged != null)
                  ToggleButtons(
                    isSelected: TimePeriod.values.map((e) => e == selectedPeriod).toList(),
                    onPressed: (index) {
                      onPeriodChanged!(TimePeriod.values[index]);
                    },
                    borderRadius: BorderRadius.circular(8),
                    selectedColor: Colors.white,
                    fillColor: Colors.blue,
                    constraints: const BoxConstraints(minHeight: 30, minWidth: 50),
                    children: const [
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Week')),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Month')),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Year')),
                    ],
                  )
                else if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
