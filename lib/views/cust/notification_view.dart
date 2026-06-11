import 'package:flutter/material.dart';
import '../../viewmodels/cust/notification_viewmodel.dart';
import '../../models/notification_model.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: Stack(
        children: [
          Positioned(
            left: -17,
            top: -30,
            child: Container(
              width: MediaQuery.of(context).size.width + 34,
              height: 289,
              decoration: const BoxDecoration(color: Color(0xFFD699AB)),
            ),
          ),
          Positioned(
            left: -17,
            top: 147,
            child: Container(
              width: MediaQuery.of(context).size.width + 34,
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
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    top: 10.0,
                    bottom: 20.0,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      const Text(
                        'Messages',
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        );
                      }

                      if (_viewModel.groupedNotifications.isEmpty) {
                        return const Center(
                          child: Text(
                            'Belum ada pesan.',
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
                                  group['date'],
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

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 30),
              width: 340,
              height: 42,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                ),
                borderRadius: BorderRadius.circular(120),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: Container(alignment: Alignment.center)),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEED5DB),
                        borderRadius: BorderRadius.circular(97.66),
                      ),
                      child: const Text(
                        'Notification',
                        style: TextStyle(
                          color: Color(0xFFCA748D),
                          fontSize:
                              14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: -12,
            bottom: -2,
            child: IgnorePointer(
              child: Container(
                width: MediaQuery.of(context).size.width + 24,
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

    return Container(
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
              height: 1.10,
            ),
          ),
        ],
      ),
    );
  }
}
