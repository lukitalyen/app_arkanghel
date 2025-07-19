import 'package:app_arkanghel/models/assessment.dart';
import 'package:app_arkanghel/screens/admin/add_edit_question_screen.dart';
import 'package:app_arkanghel/services/assessment_service.dart';
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
      final assessmentService =
          Provider.of<AssessmentService>(context, listen: false);
      final assessment = Assessment(
        id: widget.assessment?.id ?? DateTime.now().toString(),
        title: _title,
        workstreamId: _workstreamId!,
        chapterId: _chapterId,
        questions: _questions,
      );

      if (widget.assessment == null) {
        assessmentService.addAssessment(assessment);
      } else {
        assessmentService.updateAssessment(assessment);
      }
      Navigator.of(context).pop();
    }
  }

  void _deleteQuestion(int index) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 50),
              const SizedBox(height: 16),
              const Text(
                'Are you sure?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8),
              const Text(
                'Do you want to remove this question?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      child: const Text('No'),
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      child: const Text('Yes, Remove'),
                      onPressed: () {
                        setState(() => _questions.removeAt(index));
                        Navigator.of(ctx).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
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
    final isEdit = widget.assessment != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isEdit ? 'Edit Assessment' : 'Add Assessment',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Assessment Details Section
                      _buildSectionHeader('Assessment Details'),
                      const SizedBox(height: 16),
                      _buildTextFormField(initialValue: _title, label: 'Title', onSaved: (v) => _title = v!),
                      const SizedBox(height: 16),
                      _buildWorkstreamDropdown(),
                      const SizedBox(height: 16),
                      _buildTextFormField(initialValue: _chapterId, label: 'Chapter ID', onSaved: (v) => _chapterId = v!),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Questions Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionHeader('Questions (${_questions.length})'),
                          FilledButton.icon(
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add Question'),
                            onPressed: () => _navigateToAddEditQuestion(),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildQuestionsList(),
                      const SizedBox(height: 24), // Bottom padding
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
    );
  }

  Widget _buildTextFormField({required String initialValue, required String label, required FormFieldSetter<String> onSaved}) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      validator: (v) => v!.isEmpty ? 'Please enter a $label.' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildWorkstreamDropdown() {
    return Consumer<ContentService>(
      builder: (context, contentService, child) {
        return DropdownButtonFormField<String>(
          value: _workstreamId,
          hint: const Text('Select Workstream'),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
          items: contentService.workstreams.map((w) {
            return DropdownMenuItem<String>(value: w.id, child: Text(w.title));
          }).toList(),
          onChanged: (v) => setState(() => _workstreamId = v),
          validator: (v) => v == null ? 'Please select a workstream.' : null,
        );
      },
    );
  }

  Widget _buildQuestionsList() {
    if (_questions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Text('No questions added yet.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        final question = _questions[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFFDBEAFE),
              child: Text('${index + 1}', style: const TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.bold)),
            ),
            title: Text(question.text, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('Type: ${question.type.name}', style: const TextStyle(color: Colors.black54)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit_rounded, color: Color(0xFF3B82F6)), onPressed: () => _navigateToAddEditQuestion(question)),
                IconButton(icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)), onPressed: () => _deleteQuestion(index)),
              ],
            ),
          ),
        );
      },
    );
  }
}
