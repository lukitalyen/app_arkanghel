import 'package:app_arkanghel/api/dummy_data.dart';
import 'package:app_arkanghel/models/user.dart';
import 'package:app_arkanghel/models/workstream.dart';
import 'package:flutter/foundation.dart';

class ContentService with ChangeNotifier {
  final List<Workstream> _workstreams = dummyWorkstreams;

  List<Workstream> get workstreams => _workstreams;

  Workstream? getWorkstreamById(String id) {
    try {
      return _workstreams.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Workstream> getWorkstreamsForUser(User user) {
    return _workstreams
        .where((workstream) => user.assignedWorkstreamIds.contains(workstream.id))
        .toList();
  }

  double getWorkstreamProgress(User user, Workstream workstream) {
    final totalChapters = workstream.chapters.length;
    if (totalChapters == 0) {
      return 0.0;
    }
    final completedChapters = workstream.chapters
        .where((chapter) => user.completedChapterIds.contains(chapter.id))
        .length;
    return completedChapters / totalChapters;
  }
}
