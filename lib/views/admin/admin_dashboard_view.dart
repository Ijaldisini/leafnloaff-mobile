import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  final PageController _pageController = PageController();
  final _supabase = Supabase.instance.client;

  int _currentPage = 0;
  bool _isLoading = true;

  String _todayRevenue = "Rp. 0";
  String _todayOrdersCount = "0 Orders";
  String _newCustomersCount = "0 Users";
  String _bestSellerItem = "-";

  List<Map<String, dynamic>> _dashboardStats = [];
  List<Map<String, dynamic>> _recentOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() => _isLoading = true);

    final now = DateTime.now();
    final startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    ).toUtc().toIso8601String();
    final endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    ).toUtc().toIso8601String();
    final startOfWeek = now
        .subtract(Duration(days: now.weekday - 1))
        .toUtc()
        .toIso8601String();

    double revenue = 0;
    int totalOrdersToday = 0;
    int newUsersCount = 0;
    String bestSellerName = "Belum ada order";
    int maxQty = 0;
    List<Map<String, dynamic>> fetchedRecentOrders = [];

    try {
      final ordersToday = await _supabase
          .from('orders')
          .select('id, total_price, status, created_at')
          .gte('created_at', startOfDay)
          .lte('created_at', endOfDay);

      totalOrdersToday = ordersToday.length;
      for (var order in ordersToday) {
        if (order['status'].toString().toLowerCase() != 'cancelled' &&
            order['status'].toString().toLowerCase() != 'dibatalkan') {
          revenue += (order['total_price'] as num).toDouble();
        }
      }
    } catch (e) {
      debugPrint("Error Fetching Orders Today: $e");
    }

    try {
      final newUsers = await _supabase
          .from('profiles')
          .select('id')
          .eq('role', 'customer')
          .gte('created_at', startOfWeek);
      newUsersCount = newUsers.length;
    } catch (e) {
      debugPrint("Error Fetching Customers: $e");
    }

    try {
      final orderItemsToday = await _supabase
          .from('order_items')
          .select('menu_id, quantity, menus(name)')
          .gte('created_at', startOfDay)
          .lte('created_at', endOfDay);

      Map<String, int> itemCounts = {};
      for (var item in orderItemsToday) {
        final menuName = item['menus'] != null
            ? item['menus']['name']
            : 'Unknown';
        final qty = item['quantity'] as int;
        itemCounts[menuName] = (itemCounts[menuName] ?? 0) + qty;

        if (itemCounts[menuName]! > maxQty) {
          maxQty = itemCounts[menuName]!;
          bestSellerName = menuName;
        }
      }
    } catch (e) {
      debugPrint("Error Fetching Best Seller: $e");
    }

    try {
      final recentData = await _supabase
          .from('orders')
          .select('''
            id,
            status,
            created_at,
            total_price,
            notes,
            order_items (
              quantity,
              menus (name)
            )
          ''')
          .order('created_at', ascending: false)
          .limit(3);

      fetchedRecentOrders = List<Map<String, dynamic>>.from(recentData);
      debugPrint(
        "BERHASIL MENARIK ${fetchedRecentOrders.length} RECENT ORDERS",
      );
    } catch (e) {
      debugPrint("Error Fetching Recent Orders: $e");
    }

    if (mounted) {
      setState(() {
        _todayRevenue = NumberFormat.currency(
          locale: 'id_ID',
          symbol: 'Rp',
          decimalDigits: 0,
        ).format(revenue);
        _todayOrdersCount = "$totalOrdersToday Orders";
        _newCustomersCount = "$newUsersCount Users";
        _bestSellerItem = bestSellerName.replaceAll(' ', '\n');

        _recentOrders = fetchedRecentOrders;

        _dashboardStats = [
          {
            "title": "Today's Revenue",
            "value": _todayRevenue,
            "subtitle": "Updated just now",
            "percent": "0,0%",
          },
          {
            "title": "Today's Orders",
            "value": _todayOrdersCount,
            "subtitle": "Updated just now",
            "percent": "0,0%",
          },
          {
            "title": "New Customers",
            "value": _newCustomersCount,
            "subtitle": "New this week",
            "percent": "0,0%",
          },
          {
            "title": "Best Seller",
            "value": _bestSellerItem,
            "subtitle": "$maxQty sold today",
            "percent": "0,0%",
          },
        ];
        _isLoading = false;
      });
    }
  }

  String _getTimeAgo(String timestamp) {
    final date = DateTime.parse(timestamp);
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} Mins Ago";
    if (diff.inHours < 24) return "${diff.inHours} Hours Ago";
    return "${diff.inDays} Days Ago";
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todayDateStr = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD699AB)),
            )
          : Stack(
              children: [
                Positioned(
                  left: -17,
                  top: -30,
                  child: Container(
                    width: 422,
                    height: 289,
                    decoration: const BoxDecoration(color: Color(0xFFD699AB)),
                  ),
                ),
                Positioned(
                  left: -17,
                  top: 147,
                  child: Container(
                    width: 422,
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
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Today’s Overview',
                              style: TextStyle(
                                color: Color(0xFFFDFDFD),
                                fontSize: 19.17,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                height: 1.10,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Opacity(
                              opacity: 0.70,
                              child: Text(
                                todayDateStr,
                                style: const TextStyle(
                                  color: Color(0xFFFDFDFD),
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  height: 1.10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 145,
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const BouncingScrollPhysics(),
                          scrollBehavior: const MaterialScrollBehavior()
                              .copyWith(
                                dragDevices: {
                                  PointerDeviceKind.mouse,
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.trackpad,
                                },
                              ),
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: _dashboardStats.length,
                          itemBuilder: (context, index) {
                            final stat = _dashboardStats[index];
                            return _buildTopCard(
                              title: stat["title"],
                              value: stat["value"],
                              subtitle: stat["subtitle"],
                              percent: stat["percent"],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _dashboardStats.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? const Color(0xFF1C3628)
                                  : const Color(
                                      0xFFEED5DB,
                                    ).withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                title: 'Create a new\ncatalog',
                                showIcon: true,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildActionButton(
                                title: 'See all\nreviews',
                                showIcon: false,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Recent Order',
                              style: TextStyle(
                                color: Color(0xFFFDFDFD),
                                fontSize: 19.17,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Opacity(
                              opacity: 0.70,
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  color: Color(0xFFFDFDFD),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      if (_recentOrders.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            "Belum ada order hari ini.",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        )
                      else
                        ..._recentOrders.map((order) {
                          final items =
                              order['order_items'] as List<dynamic>? ?? [];
                          String productName = "Unknown Item";
                          int qty = 0;

                          if (items.isNotEmpty) {
                            qty = items[0]['quantity'] ?? 0;
                            productName =
                                items[0]['menus']?['name'] ?? "Unknown Item";
                            if (items.length > 1) {
                              productName += " +${items.length - 1} lainnya";
                            }
                          }

                          final priceFormatted = NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp. ',
                            decimalDigits: 0,
                          ).format(order['total_price'] ?? 0);

                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 25,
                              right: 25,
                              bottom: 15,
                            ),
                            child: _buildResponsiveOrderCard(
                              orderId: order['id']
                                  .toString()
                                  .substring(0, 8)
                                  .toUpperCase(),
                              status: _capitalize(order['status'] ?? 'Unknown'),
                              price: priceFormatted,
                              productName: productName,
                              qty: qty.toString(),
                              timeAgo: _getTimeAgo(order['created_at']),
                              notes: order['notes']?.toString() ?? '',
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Widget _buildTopCard({
    required String title,
    required String value,
    required String subtitle,
    required String percent,
  }) {
    bool isLongText = value.contains('\n');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, 0.00),
          end: Alignment(0.89, 1.32),
          colors: [Color(0xFFFDFDFD), Color(0xFF73986F)],
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF51725F)),
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: const [BoxShadow(color: Color(0xFF51725F), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF51725F),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF2D4839),
              fontSize: isLongText ? 23 : 35,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF848383),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: ShapeDecoration(
                  color: const Color(0xFFFDFDFD),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 0.80,
                      color: Color(0xFF2D4839),
                    ),
                    borderRadius: BorderRadius.circular(29.21),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      size: 8,
                      color: Color(0xFF51725F),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      percent,
                      style: const TextStyle(
                        color: Color(0xFF51725F),
                        fontSize: 6,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String title, required bool showIcon}) {
    return Container(
      height: 79,
      padding: const EdgeInsets.all(12),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(1.00, 1.00),
          end: Alignment(0.00, 0.00),
          colors: [Color(0xFFD699AB), Color(0xFFFDFDFD)],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2D4839),
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          if (showIcon)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 20,
                height: 20,
                decoration: const ShapeDecoration(
                  shape: OvalBorder(
                    side: BorderSide(width: 2.5, color: Color(0xFF2D4839)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResponsiveOrderCard({
    required String orderId,
    required String status,
    required String price,
    required String productName,
    required String qty,
    required String timeAgo,
    required String notes,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: ShapeDecoration(
        color: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.69),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID: $orderId',
                style: const TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                timeAgo,
                style: const TextStyle(
                  color: Color(0xFF51725F),
                  fontSize: 8,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Product: ',
                  style: TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: productName,
                  style: const TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Notes: ',
                  style: TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: notes.isEmpty || notes == 'null'
                      ? 'Tidak ada catatan.'
                      : ' $notes',
                  style: const TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Qty: ',
                          style: TextStyle(
                            color: Color(0xFF51725F),
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: qty,
                          style: const TextStyle(
                            color: Color(0xFF51725F),
                            fontSize: 10,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFF2D4839),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0xFFEED5DB),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 0.80,
                      color: Color(0xFFCA748D),
                    ),
                    borderRadius: BorderRadius.circular(19.92),
                  ),
                ),
                child: Text(
                  status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFCA748D),
                    fontSize: 9.60,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
