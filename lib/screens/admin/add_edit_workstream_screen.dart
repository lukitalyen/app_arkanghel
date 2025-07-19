import 'dart:io';

import 'package:app_arkanghel/models/chapter.dart';
import 'package:app_arkanghel/models/workstream.dart';
import 'package:app_arkanghel/services/content_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditWorkstreamScreen extends StatefulWidget {
  final Workstream? workstream;

  const AddEditWorkstreamScreen({super.key, this.workstream});

  @override
  State<AddEditWorkstreamScreen> createState() =>
      _AddEditWorkstreamScreenState();
}

class _AddEditWorkstreamScreenState extends State<AddEditWorkstreamScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late bool _isPublished;
  late List<Chapter> _chapters;

  @override
  void initState() {
    super.initState();
    final workstream = widget.workstream;
    _title = workstream?.title ?? '';
    _description = workstream?.description ?? '';
    _isPublished = workstream?.isPublished ?? false;
    _chapters = List<Chapter>.from(workstream?.chapters ?? []);
  }

  void _saveWorkstream() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final contentService =
          Provider.of<ContentService>(context, listen: false);
      if (widget.workstream == null) {
        contentService.addWorkstream(
          Workstream(
            id: DateTime.now().toString(),
            title: _title,
            description: _description,
            isPublished: _isPublished,
            chapters: _chapters,
            imageUrl: '', // Add a placeholder or logic for image URL
          ),
        );
      } else {
        contentService.updateWorkstream(
          Workstream(
            id: widget.workstream!.id,
            title: _title,
            description: _description,
            isPublished: _isPublished,
            chapters: _chapters,
            imageUrl:
                widget.workstream!.imageUrl, // Preserve existing image URL
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }

  void _showChapterDialog({Chapter? chapter, int? index}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _ChapterDialog(
          chapter: chapter,
          onSave: (newChapter) {
            setState(() {
              if (index != null) {
                _chapters[index] = newChapter;
              } else {
                _chapters.add(newChapter);
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.workstream == null ? 'Create Workstream' : 'Edit Workstream',
          style: const TextStyle(
              color: Color(0xFF111827), fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              onPressed: _saveWorkstream,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: const Text('Save',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(
                  label: 'Title',
                  initialValue: _title,
                  onSaved: (v) => _title = v!),
              const SizedBox(height: 20),
              _buildTextField(
                  label: 'Description',
                  initialValue: _description,
                  onSaved: (v) => _description = v!,
                  maxLines: 4),
              const SizedBox(height: 20),
              _buildPublishedSwitch(),
              const SizedBox(height: 30),
              _buildChapterSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      required String initialValue,
      required Function(String?) onSaved,
      int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151))),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
            ),
          ),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Please enter a $label' : null,
          onSaved: onSaved,
        ),
      ],
    );
  }

  Widget _buildPublishedSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Published',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151))),
          Switch(
            value: _isPublished,
            onChanged: (value) => setState(() => _isPublished = value),
            activeColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Chapters',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827))),
            TextButton.icon(
              onPressed: () => _showChapterDialog(),
              icon: const Icon(Icons.add, color: Color(0xFF2563EB)),
              label: const Text('Add Chapter',
                  style: TextStyle(
                      color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _chapters.isEmpty
            ? _buildEmptyChapterState()
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _chapters.length,
                itemBuilder: (context, index) {
                  return _buildChapterCard(_chapters[index], index);
                },
              ),
      ],
    );
  }

  Widget _buildEmptyChapterState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.list_alt_outlined, size: 48, color: Color(0xFF9CA3AF)),
          SizedBox(height: 16),
          Text('No Chapters',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B5563))),
          SizedBox(height: 4),
          Text('Add chapters to build your workstream',
              style: TextStyle(color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildChapterCard(Chapter chapter, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.article_outlined, color: Color(0xFF4338CA)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chapter.title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151))),
                const SizedBox(height: 4),
                Text(chapter.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF6B7280))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (chapter.pdfUrl != null && chapter.pdfUrl!.isNotEmpty)
                      _buildFileChip(Icons.picture_as_pdf, 'PDF'),
                    if (chapter.pdfUrl != null &&
                        chapter.pdfUrl!.isNotEmpty &&
                        chapter.videoUrl != null &&
                        chapter.videoUrl!.isNotEmpty)
                      const SizedBox(width: 8),
                    if (chapter.videoUrl != null && chapter.videoUrl!.isNotEmpty)
                      _buildFileChip(Icons.videocam, 'Video'),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF6B7280)),
              onPressed: () =>
                  _showChapterDialog(chapter: chapter, index: index)),
          IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => setState(() => _chapters.removeAt(index))),
        ],
      ),
    );
  }

  Widget _buildFileChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF4B5563)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}

// Separate Dialog Widget for better state management
class _ChapterDialog extends StatefulWidget {
  final Chapter? chapter;
  final Function(Chapter) onSave;

  const _ChapterDialog({this.chapter, required this.onSave});

  @override
  __ChapterDialogState createState() => __ChapterDialogState();
}

class __ChapterDialogState extends State<_ChapterDialog> {
  final _chapterFormKey = GlobalKey<FormState>();
  late String _chapterTitle;
  late String _chapterDescription;
  File? _pickedPdf;
  String? _initialPdfUrl;
  File? _pickedVideo;
  String? _initialVideoUrl;

  @override
  void initState() {
    super.initState();
    _chapterTitle = widget.chapter?.title ?? '';
    _chapterDescription = widget.chapter?.description ?? '';
    _initialPdfUrl = widget.chapter?.pdfUrl;
    _initialVideoUrl = widget.chapter?.videoUrl;
  }

  Future<void> _pickFile(FileType type, {required Function(File) onFilePicked}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type,
      allowedExtensions: type == FileType.custom ? ['pdf'] : null,
    );

    if (result != null) {
      setState(() {
        onFilePicked(File(result.files.single.path!));
      });
    }
  }

  void _saveChapter() {
    if (_chapterFormKey.currentState!.validate()) {
      _chapterFormKey.currentState!.save();

      // Simulate file upload by creating a path. In a real app, you'd upload to a server.
      final pdfUrl = _pickedPdf != null
          ? 'uploads/pdfs/${DateTime.now().millisecondsSinceEpoch}.pdf'
          : _initialPdfUrl;
      final videoUrl = _pickedVideo != null
          ? 'uploads/videos/${DateTime.now().millisecondsSinceEpoch}.mp4'
          : _initialVideoUrl;

      final newChapter = Chapter(
        id: widget.chapter?.id ?? DateTime.now().toString(),
        title: _chapterTitle,
        description: _chapterDescription,
        pdfUrl: pdfUrl,
        videoUrl: videoUrl,
      );
      widget.onSave(newChapter);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.chapter != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top colored icon and accent bar
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(Icons.menu_book_rounded, color: Colors.white, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      isEdit ? 'Edit Chapter' : 'Add Chapter',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Form(
                  key: _chapterFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        initialValue: _chapterTitle,
                        decoration: InputDecoration(
                          labelText: 'Chapter Title',
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please enter a title'
                            : null,
                        onSaved: (value) => _chapterTitle = value!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _chapterDescription,
                        decoration: InputDecoration(
                          labelText: 'Chapter Description',
                          filled: true,
                          fillColor: const Color(0xFFF3F4F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLines: 2,
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Please enter a description'
                            : null,
                        onSaved: (value) => _chapterDescription = value!,
                      ),
                      const SizedBox(height: 20),
                      const Divider(height: 32, thickness: 1.2),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _pickFile(FileType.custom, onFilePicked: (file) => _pickedPdf = file),
                              icon: const Icon(Icons.picture_as_pdf, color: Color(0xFFB91C1C)),
                              label: Text(_pickedPdf != null
                                  ? 'PDF Selected'
                                  : (_initialPdfUrl != null && _initialPdfUrl!.isNotEmpty
                                      ? 'Change PDF'
                                      : 'Upload PDF')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _pickedPdf != null || (_initialPdfUrl != null && _initialPdfUrl!.isNotEmpty)
                                    ? const Color(0xFFDCFCE7)
                                    : const Color(0xFFF3F4F6),
                                foregroundColor: _pickedPdf != null || (_initialPdfUrl != null && _initialPdfUrl!.isNotEmpty)
                                    ? const Color(0xFF166534)
                                    : const Color(0xFF374151),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_pickedPdf != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text('File: ${_pickedPdf!.path.split('/').last}', style: const TextStyle(fontSize: 12, color: Color(0xFF166534))),
                        ),
                      if (_pickedPdf == null && _initialPdfUrl != null && _initialPdfUrl!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text('Current File: ${_initialPdfUrl!.split('/').last}', style: const TextStyle(fontSize: 12, color: Color(0xFF2563EB))),
                        ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _pickFile(FileType.video, onFilePicked: (file) => _pickedVideo = file),
                              icon: const Icon(Icons.videocam, color: Color(0xFF92400E)),
                              label: Text(_pickedVideo != null
                                  ? 'Video Selected'
                                  : (_initialVideoUrl != null && _initialVideoUrl!.isNotEmpty
                                      ? 'Change Video'
                                      : 'Upload Video')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _pickedVideo != null || (_initialVideoUrl != null && _initialVideoUrl!.isNotEmpty)
                                    ? const Color(0xFFFFFBEB)
                                    : const Color(0xFFF3F4F6),
                                foregroundColor: _pickedVideo != null || (_initialVideoUrl != null && _initialVideoUrl!.isNotEmpty)
                                    ? const Color(0xFF92400E)
                                    : const Color(0xFF374151),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_pickedVideo != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text('File: ${_pickedVideo!.path.split('/').last}', style: const TextStyle(fontSize: 12, color: Color(0xFF92400E))),
                        ),
                      if (_pickedVideo == null && _initialVideoUrl != null && _initialVideoUrl!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text('Current File: ${_initialVideoUrl!.split('/').last}', style: const TextStyle(fontSize: 12, color: Color(0xFF2563EB))),
                        ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF6B7280),
                                side: const BorderSide(color: Color(0xFFCBD5E1)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveChapter,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
