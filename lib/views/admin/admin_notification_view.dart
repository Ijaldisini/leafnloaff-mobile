import 'package:flutter/material.dart';
import '../../viewmodels/admin/admin_notification_viewmodel.dart';

class AdminNotificationView extends StatefulWidget {
  const AdminNotificationView({super.key});

  @override
  State<AdminNotificationView> createState() => _AdminNotificationViewState();
}

class _AdminNotificationViewState extends State<AdminNotificationView> {
  final AdminNotificationViewModel _viewModel = AdminNotificationViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchNotifications();
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 20,
                bottom: 120,
              ),
              physics: const BouncingScrollPhysics(),
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, child) {
                  if (_viewModel.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFDFDFD),
                        ),
                      ),
                    );
                  }

                  List<Widget> contentWidgets = [
                    const Text(
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
                            color: Color(0x3F000000),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ];

                  if (_viewModel.errorMessage != null) {
                    contentWidgets.add(
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            _viewModel.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFD699AB),
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  else if (_viewModel.groupedNotifications.isEmpty) {
                    contentWidgets.add(
                      const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "Belum ada notifikasi.",
                            style: TextStyle(
                              color: Color(0xFFFDFDFD),
                              fontFamily: 'Poppins',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    _viewModel.groupedNotifications.forEach((
                      dateGroup,
                      notifications,
                    ) {
                      contentWidgets.add(_buildDateHeader(dateGroup));
                      contentWidgets.add(const SizedBox(height: 15));

                      for (var notif in notifications) {
                        bool isUnread = notif['is_read'] == false;
                        contentWidgets.add(
                          GestureDetector(
                            onTap: () {
                              if (isUnread) {
                                _viewModel.markAsRead(notif['id'].toString());
                              }
                            },
                            child: _buildNotificationCard(
                              title: notif['title'] ?? 'Tanpa Judul',
                              description: notif['message'] ?? '-',
                              isUnread: isUnread,
                            ),
                          ),
                        );
                        contentWidgets.add(const SizedBox(height: 15));
                      }
                      contentWidgets.add(const SizedBox(height: 10));
                    });
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: contentWidgets,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFFDFDFD),
        fontSize: 17,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w800,
        shadows: [
          Shadow(offset: Offset(2, 2), blurRadius: 4, color: Color(0x3F000000)),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String description,
    required bool isUnread,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(16.69),
        border: isUnread
            ? Border.all(color: const Color(0xFF73986F), width: 1.0)
            : Border.all(color: Colors.transparent),
        boxShadow: isUnread
            ? const [
                BoxShadow(
                  color: Color(0xFF73986F),
                  blurRadius: 7,
                  offset: Offset(0, 0),
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xFF51725F),
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
