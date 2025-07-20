import 'package:app_arkanghel/models/assessment.dart';
import 'package:flutter/material.dart';

class AddEditQuestionScreen extends StatefulWidget {
  final Question? question;

  const AddEditQuestionScreen({super.key, this.question});

  @override
  State<AddEditQuestionScreen> createState() => _AddEditQuestionScreenState();
}

class _AddEditQuestionScreenState extends State<AddEditQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _text;
  late QuestionType _type;
  late List<String> _options;
  late int _correctAnswerIndex;
  late String? _correctAnswer;

  @override
  void initState() {
    super.initState();
    _text = widget.question?.text ?? '';
    _type = widget.question?.type ?? QuestionType.multipleChoice;
    _options = List<String>.from(widget.question?.options ?? ['', '', '', '']);
    _correctAnswerIndex = widget.question?.correctAnswerIndex ?? 0;
    _correctAnswer = widget.question?.correctAnswer;
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Filter out empty options for non-multiple choice questions
      List<String> finalOptions = _options;
      if (_type == QuestionType.trueFalse) {
        finalOptions = ['True', 'False'];
      } else if (_type == QuestionType.shortAnswer) {
        finalOptions = [];
      } else {
        finalOptions = _options.where((option) => option.trim().isNotEmpty).toList();
      }

      final newQuestion = Question(
        id: widget.question?.id ?? DateTime.now().toString(),
        text: _text,
        type: _type,
        options: finalOptions,
        correctAnswerIndex: _correctAnswerIndex,
        correctAnswer: _correctAnswer,
      );
      Navigator.of(context).pop(newQuestion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.question != null;
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
                    isEdit ? 'Edit Question' : 'Add Question',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
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
                      // Question Text Section
                      _buildSectionHeader('Question Text'),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _text,
                        decoration: InputDecoration(
                          labelText: 'Question',
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
                        maxLines: 3,
                        validator: (v) => v!.isEmpty ? 'Please enter a question.' : null,
                        onSaved: (v) => _text = v!,
                      ),
                      const SizedBox(height: 24),

                      // Question Type Section
                      _buildSectionHeader('Question Type'),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: DropdownButtonFormField<QuestionType>(
                          value: _type,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          items: QuestionType.values.map((type) {
                            return DropdownMenuItem<QuestionType>(
                              value: type,
                              child: Text(_getTypeDisplayName(type)),
                            );
                          }).toList(),
                          onChanged: (v) => setState(() {
                            _type = v!;
                            if (_type == QuestionType.trueFalse) {
                              _options = ['True', 'False'];
                              _correctAnswerIndex = 0;
                            } else if (_type == QuestionType.shortAnswer) {
                              _options = [];
                              _correctAnswerIndex = 0;
                            } else {
                              _options = ['', '', '', ''];
                              _correctAnswerIndex = 0;
                            }
                          }),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Options Section (only for multiple choice)
                      if (_type == QuestionType.multipleChoice) ...[
                        _buildSectionHeader('Answer Options'),
                        const SizedBox(height: 16),
                        ..._buildOptionFields(),
                        const SizedBox(height: 24),
                        _buildSectionHeader('Correct Answer'),
                        const SizedBox(height: 16),
                        _buildCorrectAnswerSelector(),
                      ] else if (_type == QuestionType.trueFalse) ...[
                        _buildSectionHeader('Correct Answer'),
                        const SizedBox(height: 16),
                        _buildTrueFalseSelector(),
                      ] else if (_type == QuestionType.shortAnswer) ...[
                        _buildSectionHeader('Correct Answer'),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: _correctAnswer,
                          decoration: InputDecoration(
                            labelText: 'Correct Answer',
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
                          validator: (v) => v!.isEmpty ? 'Please enter the correct answer.' : null,
                          onSaved: (v) => _correctAnswer = v,
                        ),
                      ],
                      const SizedBox(height: 80), // Space for save button
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save_alt_rounded, color: Colors.white),
            label: const Text('Save Question', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            onPressed: _saveForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
    );
  }

  String _getTypeDisplayName(QuestionType type) {
    switch (type) {
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.trueFalse:
        return 'True/False';
      case QuestionType.shortAnswer:
        return 'Short Answer';
    }
  }

  List<Widget> _buildOptionFields() {
    return List.generate(4, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: TextFormField(
          initialValue: index < _options.length ? _options[index] : '',
          decoration: InputDecoration(
            labelText: 'Option ${index + 1}',
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
          validator: (v) => (index < 2 && (v == null || v.isEmpty)) ? 'Please enter option ${index + 1}.' : null,
          onSaved: (v) {
            if (index >= _options.length) {
              _options.add(v ?? '');
            } else {
              _options[index] = v ?? '';
            }
          },
        ),
      );
    });
  }

  Widget _buildCorrectAnswerSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: List.generate(4, (index) {
          return RadioListTile<int>(
            title: Text('Option ${index + 1}'),
            value: index,
            groupValue: _correctAnswerIndex,
            onChanged: (v) => setState(() => _correctAnswerIndex = v!),
          );
        }),
      ),
    );
  }

  Widget _buildTrueFalseSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          RadioListTile<int>(
            title: const Text('True'),
            value: 0,
            groupValue: _correctAnswerIndex,
            onChanged: (v) => setState(() => _correctAnswerIndex = v!),
          ),
          RadioListTile<int>(
            title: const Text('False'),
            value: 1,
            groupValue: _correctAnswerIndex,
            onChanged: (v) => setState(() => _correctAnswerIndex = v!),
          ),
        ],
      ),
    );
  }
}
