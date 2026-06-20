import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_player/video_player.dart';
import '../../viewmodels/admin/admin_order_review_viewmodel.dart';
import '../../models/order_model.dart';

class AdminOrderReviewView extends StatefulWidget {
  final String orderId;

  const AdminOrderReviewView({super.key, required this.orderId});

  @override
  State<AdminOrderReviewView> createState() => _AdminOrderReviewViewState();
}

class _AdminOrderReviewViewState extends State<AdminOrderReviewView> {
  final AdminOrderReviewViewModel _viewModel = AdminOrderReviewViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchReviews(widget.orderId);
  }

  Future<void> _refreshReviews() async {
    await _viewModel.fetchReviews(widget.orderId);
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 220,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFD699AB),  
                    Color(0xFFD699AB),  
                    Color(0xFF3D5A4A),  
                  ],
                  stops: [0.0, 0.6, 1.0], 
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Order Review',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              widget.orderId.substring(0, 8).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                Expanded(
                  child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, child) {
                      if (_viewModel.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      if (_viewModel.errorMessage != null) {
                        return Center(
                          child: Text(
                            _viewModel.errorMessage!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      if (_viewModel.reviews.isEmpty) {
                        return const Center(
                          child: Text(
                            "Belum ada ulasan untuk order ini.",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: const Color(0xFFCA748D),
                        backgroundColor: const Color(0xFFD699AB),
                        onRefresh: _refreshReviews,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          itemCount: _viewModel.reviews.length,
                          itemBuilder: (context, index) {
                            final OrderReviewModel reviewData =
                                _viewModel.reviews[index];
                            return _buildReviewedCard(reviewData);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewedCard(OrderReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF426E55), width: 1.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    review.itemImageUrl ?? 'https://placehold.co/80x80',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.itemName,
                        style: const TextStyle(
                          color: Color(0xFF2D4839),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _viewModel.formatCurrency(review.price),
                        style: const TextStyle(
                          color: Color(0xFF2D4839),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Center(
            child: Text(
              'Rating',
              style: TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (starIndex) {
              return Icon(
                starIndex < review.rating ? Icons.star : Icons.star_border,
                color: const Color(0xFFF6D060),
                size: 35,
              );
            }),
          ),
          const SizedBox(height: 15),

          const Text(
            'Customer Review',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEED5DB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCA748D)),
            ),
            child: Text(
              review.reviewText,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 15),

          if (review.reviewImages.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: review.reviewImages.map((url) {
                bool isVideo =
                    url.toLowerCase().contains('.mp4') ||
                    url.toLowerCase().contains('.mov');

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenMediaPage(
                          mediaUrl: url,
                          isVideo: isVideo,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: isVideo
                          ? NetworkVideoThumbnailPreview(videoUrl: url)
                          : Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

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
          child: Icon(Icons.play_circle_outline, color: Colors.white, size: 24),
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
                  errorBuilder: (context, error, stackTrace) => const Text(
                    "Gagal memuat gambar",
                    style: TextStyle(color: Colors.white),
                  ),
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