import 'package:app_arkanghel/api/dummy_data.dart';
import 'package:app_arkanghel/models/workstream.dart';
import 'package:app_arkanghel/screens/admin/add_edit_workstream_screen.dart';
import 'package:flutter/material.dart';

class WorkstreamManagementScreen extends StatefulWidget {
  const WorkstreamManagementScreen({super.key});

  @override
  State<WorkstreamManagementScreen> createState() => _WorkstreamManagementScreenState();
}

class _WorkstreamManagementScreenState extends State<WorkstreamManagementScreen> {
  late List<Workstream> _workstreams;

  @override
  void initState() {
    super.initState();
    _workstreams = dummyWorkstreams;
  }

      void _deleteWorkstream(String workstreamId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to remove this workstream?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              setState(() {
                _workstreams.removeWhere((ws) => ws.id == workstreamId);
              });
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _navigateToAddEditScreen([Workstream? workstream]) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditWorkstreamScreen(workstream: workstream),
      ),
    );

    if (result != null && result is Workstream) {
      setState(() {
        if (workstream != null) {
          // Editing an existing workstream
          final index = _workstreams.indexWhere((ws) => ws.id == result.id);
          if (index != -1) {
            _workstreams[index] = result;
          }
        } else {
          // Adding a new workstream
          _workstreams.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _workstreams.length,
        itemBuilder: (context, index) {
          final workstream = _workstreams[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(workstream.title),
              subtitle: Text('${workstream.chapters.length} chapters'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _navigateToAddEditScreen(workstream),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteWorkstream(workstream.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditScreen(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
