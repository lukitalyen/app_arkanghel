import 'dart:io';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:app_arkanghel/models/chapter.dart';
import 'package:app_arkanghel/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';


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
        final videoUrl = widget.chapter.videoUrl!;
        final uri = Uri.parse(videoUrl);

        if (uri.isAbsolute && !uri.isScheme('file')) {
          _videoController = VideoPlayerController.networkUrl(uri);
        } else {
          _videoController = VideoPlayerController.file(File(videoUrl));
        }
        
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

  Widget _buildVideoPlayer() {
    return Container(
      width: double.infinity,
      height: 250, // Adjusted height for better fit
      color: Colors.black,
      child: _isVideoLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : _videoController != null && _isVideoInitialized
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                    // Play/Pause button
                    IconButton(
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
                  ],
                )
              : const Center(
                  child: Text(
                    'Video not available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
    );
  }

  Widget _buildPdfViewer() {
    final pdfUrl = widget.chapter.pdfUrl!;
    final uri = Uri.parse(pdfUrl);

    return Container(
      width: double.infinity,
      height: 500, // Adjusted height for PDFs
      color: Colors.grey[200],
      child: uri.isAbsolute && !uri.isScheme('file')
          ? WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadRequest(Uri.parse(
                    'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(pdfUrl)}')), 
            )
          : PDFView(
              filePath: pdfUrl,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: false,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
            ),
    );
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
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: SlidingUpPanel(
        minHeight: 220, 
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        parallaxEnabled: true,
        parallaxOffset: .5,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        panel: _buildPanel(isCompleted, authService),
        body: _buildPanelBody(hasVideo, hasPdf),
      ),
    );
  }

  Widget _buildPanel(bool isCompleted, AuthService authService) {
    return Column(
      children: [
        // Grabber
        Container(
          width: 40,
          height: 5,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chapter Info
                  Text(
                    widget.chapter.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Learning Module',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Chapter Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.chapter.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isCompleted
                          ? null
                          : () {
                              authService.markChapterAsComplete(widget.chapter.id);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCompleted
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFF1E40AF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isCompleted ? 'Completed' : 'Mark as Complete',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPanelBody(bool hasVideo, bool hasPdf) {
    if (hasVideo) {
      return _buildVideoPlayer();
    } else if (hasPdf) {
      return _buildPdfViewer();
    } else {
      return const Center(child: Text('No learning material available.'));
    }
  }
}
