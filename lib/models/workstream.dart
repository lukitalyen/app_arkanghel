import 'package:app_arkanghel/models/chapter.dart';

class Workstream {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<Chapter> chapters;
  final bool isPublished;

  Workstream({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.chapters,
    required this.isPublished,
  });
}
