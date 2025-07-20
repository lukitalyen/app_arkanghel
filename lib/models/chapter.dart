class Chapter {
  final String id;
  final String title;
  final String description;
  final String? videoUrl;
  final String? pdfUrl;
  final String? videoFileName;
  final String? pdfFileName;

  Chapter({
    required this.id,
    required this.title,
    required this.description,
    this.videoUrl,
    this.pdfUrl,
    this.videoFileName,
    this.pdfFileName,
  });
}
