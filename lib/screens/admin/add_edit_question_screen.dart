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
  int? _correctAnswerIndex;
  List<TextEditingController> _optionControllers = [];

  @override
  void initState() {
    super.initState();
    _text = widget.question?.text ?? '';
    _type = widget.question?.type ?? QuestionType.multipleChoice;
    _correctAnswerIndex = widget.question?.correctAnswerIndex;

    if (widget.question?.options != null) {
      for (var option in widget.question!.options!) {
        _optionControllers.add(TextEditingController(text: option));
      }
    }

    if (_type == QuestionType.multipleChoice && _optionControllers.isEmpty) {
      _optionControllers.add(TextEditingController());
      _optionControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      if (_type == QuestionType.multipleChoice && _correctAnswerIndex == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a correct answer.')),
        );
        return;
      }

      _formKey.currentState!.save();
      
      List<String> options = _optionControllers.map((c) => c.text).toList();
      int correctIndex = _correctAnswerIndex ?? 0;

      // For non-multiple choice, the options list is based on the type
      if (_type == QuestionType.trueOrFalse) {
        options = ['True', 'False'];
      } else if (_type == QuestionType.identification) {
        // For identification, the single option is the correct answer itself.
        // The UI for this is simplified; we assume the first option is the answer.
        if (options.isNotEmpty) {
           correctIndex = 0; // The answer is the only option
        } else {
          // Handle case where no option is provided for identification
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please provide an answer for identification questions.')),
          );
          return;
        }
      }

      final newQuestion = Question(
        id: widget.question?.id ?? DateTime.now().toString(),
        text: _text,
        type: _type,
        options: options,
        correctAnswerIndex: correctIndex,
      );
      Navigator.of(context).pop(newQuestion);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question == null ? 'Add Question' : 'Edit Question'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _text,
                  decoration: const InputDecoration(labelText: 'Question Text'),
                  validator: (v) => v!.isEmpty ? 'Please enter text.' : null,
                  onSaved: (v) => _text = v!,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<QuestionType>(
                  value: _type,
                  decoration: const InputDecoration(labelText: 'Question Type'),
                  items: QuestionType.values.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type.name));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _type = value!;
                      _correctAnswerIndex = null;
                      _optionControllers.forEach((c) => c.dispose());
                      _optionControllers = [];
                      if (_type == QuestionType.multipleChoice || _type == QuestionType.identification) {
                         _optionControllers.add(TextEditingController());
                         if(_type == QuestionType.multipleChoice) _optionControllers.add(TextEditingController());
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (_type == QuestionType.multipleChoice)
                  const Text('Options', style: TextStyle(fontWeight: FontWeight.bold)),
                if (_type == QuestionType.multipleChoice)
                  ..._buildMultipleChoiceOptions(),
                if (_type == QuestionType.identification)
                  ..._buildIdentificationOption(),
                if (_type == QuestionType.trueOrFalse)
                  ..._buildTrueFalseOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMultipleChoiceOptions() {
    List<Widget> fields = [];
    for (int i = 0; i < _optionControllers.length; i++) {
      fields.add(
        Row(
          children: [
            Radio<int>(
              value: i,
              groupValue: _correctAnswerIndex,
              onChanged: (value) => setState(() => _correctAnswerIndex = value),
            ),
            Expanded(
              child: TextFormField(
                controller: _optionControllers[i],
                decoration: InputDecoration(labelText: 'Option ${i + 1}'),
                validator: (v) => v!.isEmpty ? 'Enter option text.' : null,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                setState(() {
                  if (_correctAnswerIndex == i) _correctAnswerIndex = null;
                  _optionControllers[i].dispose();
                  _optionControllers.removeAt(i);
                });
              },
            ),
          ],
        ),
      );
    }
    fields.add(
      Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          icon: const Icon(Icons.add), 
          label: const Text('Add Option'),
          onPressed: () => setState(() => _optionControllers.add(TextEditingController())),
        ),
      ),
    );
    return fields;
  }

  List<Widget> _buildIdentificationOption() {
    // For identification, we just need one text field for the correct answer.
    return [
      TextFormField(
        controller: _optionControllers.isNotEmpty ? _optionControllers[0] : TextEditingController(),
        decoration: const InputDecoration(labelText: 'Correct Answer'),
        validator: (v) => v!.isEmpty ? 'Please enter the answer.' : null,
        onChanged: (v) {
          if (_optionControllers.isEmpty) {
            _optionControllers.add(TextEditingController(text: v));
          } else {
            _optionControllers[0].text = v;
          }
        },
      ),
    ];
  }

  List<Widget> _buildTrueFalseOptions() {
    return [
      RadioListTile<int>(
        title: const Text('True'),
        value: 0,
        groupValue: _correctAnswerIndex,
        onChanged: (value) => setState(() => _correctAnswerIndex = value),
      ),
      RadioListTile<int>(
        title: const Text('False'),
        value: 1,
        groupValue: _correctAnswerIndex,
        onChanged: (value) => setState(() => _correctAnswerIndex = value),
      ),
    ];
  }
}
