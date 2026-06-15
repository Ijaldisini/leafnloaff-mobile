import 'package:flutter/material.dart';
import '../../viewmodels/cust/notification_viewmodel.dart';
import '../../models/notification_model.dart';
import 'detail_order_view.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final NotificationViewModel _viewModel = NotificationViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.initListener();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadNotifications();
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: Stack(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 20.0, bottom: 20.0),
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                      color: Color(0xFFFDFDFD),
                      fontSize: 25,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
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
                Expanded(
                  child: ListenableBuilder(
                    listenable: _viewModel,
                    builder: (context, _) {
                      if (_viewModel.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }

                      if (_viewModel.errorMessage != null &&
                          _viewModel.groupedNotifications.isEmpty) {
                        return Center(
                          child: Text(
                            _viewModel.errorMessage!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      if (_viewModel.groupedNotifications.isEmpty) {
                        return const Center(
                          child: Text(
                            "Belum ada notifikasi",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          bottom: 100,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: _viewModel.groupedNotifications.length,
                        itemBuilder: (context, index) {
                          final group = _viewModel.groupedNotifications[index];
                          final dateLabel = group['date'] as String;
                          final items =
                              group['items'] as List<NotificationModel>;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                ),
                                child: Text(
                                  dateLabel,
                                  style: const TextStyle(
                                    color: Color(0xFFFDFDFD),
                                    fontSize: 17,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800,
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
                              ...items.map(
                                (item) => _buildNotificationCard(item),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: -12,
            bottom: -2,
            child: IgnorePointer(
              child: Container(
                width: screenWidth + 24,
                height: 130,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFF3D5A4A), Color(0x003E5A4A)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel item) {
    final isUnread = !item.isRead;

    return GestureDetector(
      onTap: () {
        if (item.orderId != null && item.orderId!.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailOrderView(orderId: item.orderId!),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notifikasi ini tidak memiliki tautan pesanan.'),
              backgroundColor: Color(0xFFC23437),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFDFD),
          borderRadius: BorderRadius.circular(16.69),
          border: isUnread
              ? Border.all(color: const Color(0xFFCA748D), width: 0.5)
              : null,
          boxShadow: isUnread
              ? const [
                  BoxShadow(
                    color: Color(0xFFCA748D),
                    blurRadius: 5,
                    offset: Offset(0, 0),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 1.10,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              item.message,
              style: const TextStyle(
                color: Color(0xFF51725F),
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
