import 'package:app_arkanghel/services/auth_service.dart';

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
                  Expanded(
                    child: SummaryCard(
                      title: 'Total Users',
                      value: userCount,
                      icon: Icons.people_outline,
                      color: Colors.blue,
                      percentage: '12.5%',
                      isPositive: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: SummaryCard(
                      title: 'Engagements',
                      value: '80.2k',
                      icon: Icons.show_chart,
                      color: Colors.teal,
                      percentage: '25.8%',
                      isPositive: true,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: SummaryCard(
                  title: 'Completed Assessments',
                  value: '1.2k',
                  icon: Icons.assignment_turned_in_outlined,
                  color: Colors.orange,
                  percentage: '15.2%',
                  isPositive: false,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: SummaryCard(
                  title: 'Completed Workstreams',
                  value: '25',
                  icon: Icons.check_circle_outline,
                  color: Colors.indigo,
                  percentage: '30.1%',
                  isPositive: true,
                ),
              ),
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
          ChartCard(
            title: 'Training Module Assessment Tracker',
            child: SizedBox(height: 200, child: AssessmentTrackerChart()),
          ),
          const SizedBox(height: 24),
          // Top User Completed Tracker
          const ChartCard(
            title: 'Top User Completed Tracker',
            child: TopUserList(),
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
  final String percentage;
  final bool isPositive;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.percentage,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  percentage,
                  style: TextStyle(color: isPositive ? Colors.green : Colors.red, fontWeight: FontWeight.w600),
                ),
              ],
            ),
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
