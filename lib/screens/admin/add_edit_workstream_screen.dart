import 'package:app_arkanghel/models/workstream.dart';
import 'package:flutter/material.dart';

class AddEditWorkstreamScreen extends StatefulWidget {
  final Workstream? workstream;

  const AddEditWorkstreamScreen({super.key, this.workstream});

  @override
  State<AddEditWorkstreamScreen> createState() => _AddEditWorkstreamScreenState();
}

class _AddEditWorkstreamScreenState extends State<AddEditWorkstreamScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = widget.workstream?.title ?? '';
    _description = widget.workstream?.description ?? '';
  }

    void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newWorkstream = Workstream(
        id: widget.workstream?.id ?? DateTime.now().toString(),
        title: _title,
        description: _description,
        chapters: widget.workstream?.chapters ?? [],
        // Default values for other properties
        imageUrl: widget.workstream?.imageUrl ?? '',
        isPublished: widget.workstream?.isPublished ?? false,
      );
      Navigator.of(context).pop(newWorkstream);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workstream == null ? 'Add Workstream' : 'Edit Workstream'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
