import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoThumbnailPreview extends StatefulWidget {
  final String videoUrl;

  const NetworkVideoThumbnailPreview({super.key, required this.videoUrl});

  @override
  State<NetworkVideoThumbnailPreview> createState() =>
      _NetworkVideoThumbnailPreviewState();
}

class _NetworkVideoThumbnailPreviewState
    extends State<NetworkVideoThumbnailPreview> {
  Uint8List? _thumbnailData;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: widget.videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 150,
        quality: 50,
      );

      if (mounted) {
        setState(() {
          _thumbnailData = uint8list;
        });
      }
    } catch (e) {
      debugPrint("Gagal load thumbnail video jaringan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbnailData == null) {
      return Container(
        color: Colors.grey[800],
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.memory(_thumbnailData!, fit: BoxFit.cover),
        Container(color: Colors.black26),
        const Center(
          child: Icon(Icons.play_circle_outline, color: Colors.white, size: 30),
        ),
      ],
    );
  }
}

class FullScreenMediaPage extends StatefulWidget {
  final String mediaUrl;
  final bool isVideo;

  const FullScreenMediaPage({
    super.key,
    required this.mediaUrl,
    required this.isVideo,
  });

  @override
  State<FullScreenMediaPage> createState() => _FullScreenMediaPageState();
}

class _FullScreenMediaPageState extends State<FullScreenMediaPage> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.mediaUrl))
            ..initialize()
                .then((_) {
                  if (mounted) {
                    setState(() {
                      _isVideoInitialized = true;
                    });
                    _videoController!.play();
                  }
                })
                .catchError((error) {
                  debugPrint("Video Player Error: $error");
                  if (mounted) {
                    setState(() {
                      _hasError = true;
                    });
                  }
                });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: widget.isVideo
            ? _buildVideoPlayer()
            : InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.network(
                  widget.mediaUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      "Gagal memuat gambar",
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_hasError) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 60),
          SizedBox(height: 16),
          Text(
            "Perangkat tidak mendukung format video ini.",
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          ),
        ],
      );
    }

    if (_isVideoInitialized && _videoController != null) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayer(_videoController!),
            VideoProgressIndicator(_videoController!, allowScrubbing: true),
            Center(
              child: IconButton(
                icon: Icon(
                  _videoController!.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 60,
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
        ),
      );
    }
    return const CircularProgressIndicator(color: Colors.white);
  }
}
