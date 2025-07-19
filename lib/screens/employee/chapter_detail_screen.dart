import 'package:app_arkanghel/models/chapter.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChapterDetailScreen extends StatefulWidget {
  final Chapter chapter;

  const ChapterDetailScreen({super.key, required this.chapter});

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isVideoLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    if (widget.chapter.videoUrl != null && widget.chapter.videoUrl!.isNotEmpty) {
      setState(() {
        _isVideoLoading = true;
      });
      
      try {
        // For demo purposes, we'll use a network video
        // In a real app, you'd handle local files differently
        _videoController = VideoPlayerController.networkUrl(
          Uri.parse(widget.chapter.videoUrl!),
        );
        
        await _videoController!.initialize();
        
        setState(() {
          _isVideoInitialized = true;
          _isVideoLoading = false;
        });
      } catch (e) {
        setState(() {
          _isVideoLoading = false;
        });
        // Handle error - video couldn't be loaded
        print('Error loading video: $e');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser!;
    final isCompleted = user.completedChapterIds.contains(widget.chapter.id);
    final hasVideo = widget.chapter.videoUrl != null && widget.chapter.videoUrl!.isNotEmpty;
    final hasPdf = widget.chapter.pdfUrl != null && widget.chapter.pdfUrl!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        title: Text(
          widget.chapter.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              isCompleted ? 'Complete' : 'Pending',
              style: TextStyle(
                color: isCompleted ? const Color(0xFF059669) : const Color(0xFF92400E),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              // Header section
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chapter.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (hasVideo) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.play_circle_outline,
                                  size: 16,
                                  color: Color(0xFF1E40AF),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Video Available',
                                  style: TextStyle(
                                    color: Color(0xFF1E40AF),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (hasPdf) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.picture_as_pdf_outlined,
                                  size: 16,
                                  color: Color(0xFFDC2626),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'PDF Available',
                                  style: TextStyle(
                                    color: Color(0xFFDC2626),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Content section
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasVideo || hasPdf) ...[
                      const Text(
                        'Learning Materials',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (hasVideo) ...[
                      // Embedded Video Player
                      Container(
                        width: double.infinity,
                        height: 200,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _isVideoLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : _videoController != null && _isVideoInitialized
                                  ? Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: _videoController!.value.aspectRatio,
                                          child: VideoPlayer(_videoController!),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: VideoProgressIndicator(
                                            _videoController!,
                                            allowScrubbing: true,
                                            colors: const VideoProgressColors(
                                              playedColor: Color(0xFF1E40AF),
                                              bufferedColor: Colors.grey,
                                              backgroundColor: Colors.black26,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: IconButton(
                                            iconSize: 64,
                                            icon: Icon(
                                              _videoController!.value.isPlaying
                                                  ? Icons.pause_circle_filled
                                                  : Icons.play_circle_filled,
                                              color: Colors.white.withOpacity(0.8),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _videoController!.value.isPlaying
                                                    ? _videoController!.pause()
                                                    : _videoController!.play();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xFF1E40AF),
                                            const Color(0xFF3B82F6),
                                          ],
                                        ),
                                      ),
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.video_library_outlined,
                                              size: 48,
                                              color: Colors.white,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Video content unavailable',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                        ),
                      ),
                    ],
                    if (hasPdf) ...[
                      // Embedded PDF Viewer
                      Container(
                        width: double.infinity,
                        height: 400,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: widget.chapter.pdfUrl != null && widget.chapter.pdfUrl!.isNotEmpty
                              ? WebViewWidget(
                                  controller: WebViewController()
                                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                                    ..loadRequest(
                                      Uri.parse(
                                        'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(widget.chapter.pdfUrl!)}',
                                      ),
                                    ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        const Color(0xFFDC2626),
                                        const Color(0xFFEF4444),
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.picture_as_pdf_outlined,
                                          size: 48,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'PDF content unavailable',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ]),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCompleted
                          ? const Color(0xFF059669)
                          : const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: isCompleted
                        ? null
                        : () {
                            authService.markChapterAsComplete(widget.chapter.id);
                          },
                    child: Text(
                      isCompleted ? 'Chapter Completed ✓' : 'Mark as Complete',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
