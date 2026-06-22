import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../viewmodels/cust/review_order_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/review_model.dart';
import '../../models/order_model.dart';
import '../../utils/image_picker_util.dart';

class WriteReviewView extends StatefulWidget {
  final String orderId;
  final List<OrderItemModel> orderItems;

  const WriteReviewView({
    super.key,
    required this.orderId,
    required this.orderItems,
  });

  @override
  State<WriteReviewView> createState() => _WriteReviewViewState();
}

class _WriteReviewViewState extends State<WriteReviewView> {
  final ReviewOrderViewModel _viewModel = ReviewOrderViewModel();
  final ImagePickerUtil _imagePicker = ImagePickerUtil();

  Map<int, int> ratings = {};
  Map<int, TextEditingController> reviewControllers = {};
  Map<int, List<File>> selectedMedia = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.orderItems.length; i++) {
      ratings[i] = 0;
      reviewControllers[i] = TextEditingController();
      selectedMedia[i] = [];
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    for (var controller in reviewControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _isVideo(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv'].contains(ext);
  }

  void _submitReview() async {
    List<ReviewSubmitModel> reviewsData = [];
    for (int i = 0; i < widget.orderItems.length; i++) {
      final item = widget.orderItems[i];
      final menuId = item.menuId;

      reviewsData.add(
        ReviewSubmitModel(
          menuId: menuId,
          rating: ratings[i] ?? 0,
          comment: reviewControllers[i]?.text ?? '',
          mediaFiles: selectedMedia[i] ?? [],
        ),
      );
    }

    final isSuccess = await _viewModel.submitAllReviews(
      widget.orderId,
      reviewsData,
    );

    if (!mounted) return;

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terima kasih, ulasan berhasil dikirim!'),
          backgroundColor: Color(0xFF426E55),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage ?? 'Terjadi kesalahan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  
  return Scaffold(
    backgroundColor: const Color(0xFF3D5A4A),
    resizeToAvoidBottomInset: false,
    body: ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              left: -17,
              top: -30,
              child: Container(
                width: screenWidth + 34,  
                height: 289,  
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 214, 153, 171), 
                ),
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 20.0,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              'assets/images/back.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Write Review',
                            textAlign: TextAlign.center,
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
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      color: const Color(0xFFCA748D),
                      backgroundColor: Colors.white,
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 10,
                          bottom: 120, 
                        ),
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: widget.orderItems.length,
                        itemBuilder: (context, index) {
                          final item = widget.orderItems[index];
                          return _buildReviewCard(index, item);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30), 
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x003D5A4A),
                      Color(0xFF3D5A4A),
                    ],
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD699AB),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _viewModel.isLoading ? null : _submitReview,
                    child: _viewModel.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Submit All Reviews',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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

  Widget _buildReviewCard(int index, OrderItemModel item) {
    final mediaList = selectedMedia[index] ?? [];

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
              border: Border.all(color: const Color(0xFFD699AB), width: 1.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    item.menuImageUrl ?? 'https://via.placeholder.com/80',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
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
                        item.menuName,
                        style: const TextStyle(
                          color: Color(0xFF2D4839),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Notes: ${item.notes ?? '-'} \nQty: ${item.quantity}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp. ${item.priceAtTime}',
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
              'How was your meal?',
              style: TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (starIndex) {
              return IconButton(
                icon: Icon(
                  starIndex < (ratings[index] ?? 0)
                      ? Icons.star
                      : Icons.star_border,
                  color: const Color(0xFFF6D060),
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    ratings[index] = starIndex + 1;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 15),
          const Text(
            'Write your review',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEED5DB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCA748D)),
            ),
            child: TextField(
              controller: reviewControllers[index],
              maxLines: 4,
              style: const TextStyle(
                color: Color(0xFF2D4839), 
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
                hintText: 'Tulis ulasanmu di sini...',
                hintStyle: TextStyle(
                  fontSize: 12, 
                  fontFamily: 'Poppins',
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Add Photos / Videos (Max 3)',
            style: TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ...mediaList.asMap().entries.map((entry) {
                int mediaIndex = entry.key;
                File file = entry.value;
                bool isVideo = _isVideo(file);

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 70,
                          height: 70,
                          child: isVideo
                              ? VideoThumbnailPreview(videoFile: file)
                              : Image.file(file, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMedia[index]!.removeAt(mediaIndex);
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              if (mediaList.length < 3)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPhotoBtn('assets/images/Camera.svg', () {
                      _showCameraOptions(index);
                    }),
                    const SizedBox(width: 10),
                    _buildPhotoBtn('assets/images/Galeri.svg', () async {
                      final files = await _imagePicker.pickMultipleMedia();
                      if (files.isNotEmpty) {
                        setState(() {
                          int availableSlots = 3 - selectedMedia[index]!.length;
                          selectedMedia[index]!.addAll(
                            files.take(availableSlots),
                          );
                        });
                      }
                    }),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoBtn(String iconPath, VoidCallback onTap) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFEED5DB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          iconPath,
          width: 30,
          height: 30,
          colorFilter: const ColorFilter.mode(
            Color(0xFFCA748D),
            BlendMode.srcIn,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }

  void _showCameraOptions(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto'),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await _imagePicker.pickFromCamera();
                  if (file != null) {
                    setState(() => selectedMedia[index]!.add(file));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Ambil Video'),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await _imagePicker.pickVideoFromCamera();
                  if (file != null) {
                    setState(() => selectedMedia[index]!.add(file));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class VideoThumbnailPreview extends StatefulWidget {
  final File videoFile;

  const VideoThumbnailPreview({super.key, required this.videoFile});

  @override
  State<VideoThumbnailPreview> createState() => _VideoThumbnailPreviewState();
}

class _VideoThumbnailPreviewState extends State<VideoThumbnailPreview> {
  Uint8List? _thumbnailData;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: widget.videoFile.path,
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
      debugPrint("Gagal load thumbnail: $e");
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