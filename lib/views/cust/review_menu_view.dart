import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_player/video_player.dart';
import '../../viewmodels/cust/review_menu_viewmodel.dart';

class ReviewMenuView extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;
  final int price;
  final double rating;
  final int totalReviews;

  const ReviewMenuView({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.rating,
    required this.totalReviews,
  });

  @override
  State<ReviewMenuView> createState() => _ReviewMenuViewState();
}

class _ReviewMenuViewState extends State<ReviewMenuView>
    with SingleTickerProviderStateMixin {
  final ReviewMenuViewModel _viewModel = ReviewMenuViewModel();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _viewModel.fetchReviews(widget.productId);

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  String get _formattedPrice {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(widget.price);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: -17,
                top: -30,
                child: Container(
                  width: screenWidth + 34,
                  height: 289,
                  decoration: const BoxDecoration(color: Color(0xFFD699AB)),
                ),
              ),

              Positioned(
                left: -17,
                top: 147,
                child: Container(
                  width: screenWidth + 34,
                  height: 114,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x003D5A4A), Color(0xFF3D5A4A)],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.25,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    widget.productName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w800,
                                      height: 1.10,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 44),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 265,
                                    width: double.infinity,
                                    color: const Color(0xFF426E55),
                                    child: widget.productImage.isNotEmpty
                                        ? Image.network(
                                            widget.productImage,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.restaurant,
                                                          size: 64,
                                                          color: Colors.white54,
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          'Product Image',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.white54,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                          )
                                        : const Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.restaurant,
                                                  size: 64,
                                                  color: Colors.white54,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Product Image',
                                                  style: TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 14,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    height: 105,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0x00CA748D),
                                          Color(0xFFCA748D),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                          bottom: 14,
                                        ),
                                        child: Text(
                                          _formattedPrice,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w800,
                                            height: 1.10,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(1, 1),
                                                blurRadius: 3,
                                                color: Colors.black26,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          _viewModel.isLoading
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32),
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFCA748D),
                                    ),
                                  ),
                                )
                              : _viewModel.reviews.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 26,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(32),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.rate_review_outlined,
                                            size: 48,
                                            color: Colors.white54,
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            'Belum ada review untuk produk ini',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 26,
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: _viewModel.reviews.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final review = _viewModel.reviews[index];

                                      return _buildReviewCard(
                                        userName:
                                            review.userName ?? 'Anonymous',
                                        date: review.createdAt
                                            .toIso8601String(),
                                        rating: review.rating.toDouble(),
                                        comment: review.comment ?? '',
                                        imageUrl: review.imageUrl,
                                      );
                                    },
                                  ),
                                ),

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: double.infinity,
                  height: 98,
                  decoration: const ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: _viewModel.isAddingToCart ? null : _addToCart,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _viewModel.isAddingToCart ? 48 : 137,
                        height: 32,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF426E55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _viewModel.isAddingToCart
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'Add to Cart',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReviewCard({
    required String userName,
    required String date,
    required double rating,
    required String comment,
    required String? imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFEDED),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFFCA748D),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Color(0xFF2D4839),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(date),
                      style: TextStyle(
                        color: const Color(0xFF426E55).withValues(alpha: 0.6),
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < rating.round() ? Icons.star : Icons.star_border,
                    size: 14,
                    color: const Color(0xFFFFC107),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (comment.isNotEmpty)
            Text(
              comment,
              style: const TextStyle(
                color: Color(0xFF51725F),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),

          if (imageUrl != null && imageUrl.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: imageUrl.split(',').map((url) {
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
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: isVideo
                          ? NetworkVideoThumbnailPreview(videoUrl: url)
                          : Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
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
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _addToCart() async {
    try {
      final success = await _viewModel.addToCart(widget.productId);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Berhasil ditambahkan ke keranjang!',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF426E55),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: const Color(0xFFC23437),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          ),
        );
      }
    }
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
