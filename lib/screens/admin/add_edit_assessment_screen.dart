import 'package:app_arkanghel/models/assessment.dart';
import 'package:app_arkanghel/screens/admin/add_edit_question_screen.dart';
import 'package:app_arkanghel/services/content_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditAssessmentScreen extends StatefulWidget {
  final Assessment? assessment;

  const AddEditAssessmentScreen({super.key, this.assessment});

  @override
  State<AddEditAssessmentScreen> createState() => _AddEditAssessmentScreenState();
}

class _AddEditAssessmentScreenState extends State<AddEditAssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String? _workstreamId;
  late String _chapterId;
  late List<Question> _questions;

  @override
  void initState() {
    super.initState();
    _title = widget.assessment?.title ?? '';
    _workstreamId = widget.assessment?.workstreamId;
    _chapterId = widget.assessment?.chapterId ?? '';
    _questions = List<Question>.from(widget.assessment?.questions ?? []);
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newAssessment = Assessment(
        id: widget.assessment?.id ?? DateTime.now().toString(),
        title: _title,
        workstreamId: _workstreamId!,
        chapterId: _chapterId,
        questions: _questions,
      );
      Navigator.of(context).pop(newAssessment);
    }
  }

  void _deleteQuestion(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to remove this question?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              setState(() => _questions.removeAt(index));
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _navigateToAddEditQuestion([Question? question]) async {
    final result = await Navigator.of(context).push<Question>(
      MaterialPageRoute(
        builder: (context) => AddEditQuestionScreen(question: question),
      ),
    );

    if (result != null) {
      setState(() {
        if (question != null) {
          final index = _questions.indexWhere((q) => q.id == result.id);
          if (index != -1) _questions[index] = result;
        } else {
          _questions.add(result);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assessment == null ? 'Add Assessment' : 'Edit Assessment'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: Consumer<ContentService>(
        builder: (context, contentService, child) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _title,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (v) => v!.isEmpty ? 'Please enter a title.' : null,
                    onSaved: (v) => _title = v!,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _workstreamId,
                    hint: const Text('Select Workstream'),
                    items: contentService.workstreams.map((w) {
                      return DropdownMenuItem<String>(value: w.id, child: Text(w.title));
                    }).toList(),
                    onChanged: (v) => setState(() => _workstreamId = v),
                    validator: (v) => v == null ? 'Please select a workstream.' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _chapterId,
                    decoration: const InputDecoration(labelText: 'Chapter ID'),
                    validator: (v) => v!.isEmpty ? 'Please enter a chapter ID.' : null,
                    onSaved: (v) => _chapterId = v!,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Questions', style: Theme.of(context).textTheme.titleLarge),
                      TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                        onPressed: () => _navigateToAddEditQuestion(),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        final question = _questions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(question.text),
                            subtitle: Text('Type: ${question.type.name}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _navigateToAddEditQuestion(question),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteQuestion(index),
                                ),
                              ],
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
        },
      ),
    );
  }
}
