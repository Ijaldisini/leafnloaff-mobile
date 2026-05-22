import 'package:flutter/material.dart';

class AdminOrderManagementView extends StatefulWidget {
  const AdminOrderManagementView({super.key});

  @override
  State<AdminOrderManagementView> createState() =>
      _AdminOrderManagementViewState();
}

class _AdminOrderManagementViewState extends State<AdminOrderManagementView> {
  final List<Map<String, dynamic>> _todayOrders = [
    {
      "time": "1 Minutes Ago",
      "price": "Rp. 14000",
      "product": "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
      "qty": 2,
      "status": 0,
      "isActive": true,
    },
    {
      "time": "1 Minutes Ago",
      "price": "Rp. 12000",
      "product": "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
      "qty": 1,
      "status": 1,
      "isActive": false,
    },
  ];

  final List<Map<String, dynamic>> _yesterdayOrders = [
    {
      "time": "Saturday, May 2, 2026",
      "price": "Rp. 12000",
      "product": "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
      "qty": 1,
      "status": 3,
      "isActive": false,
    },
    {
      "time": "Saturday, May 2, 2026",
      "price": "Rp. 12000",
      "product": "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
      "qty": 1,
      "status": 3,
      "isActive": false,
      "hasCancel": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
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
              padding: const EdgeInsets.fromLTRB(
                25,
                20,
                25,
                120, 
              ),
              physics: const BouncingScrollPhysics(),
              children: [
                Text(
                  'Order Management',
                  style: TextStyle(
                    color: const Color(0xFFFDFDFD),
                    fontSize: 25,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    shadows: [
                      Shadow(
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'Today',
                  style: TextStyle(
                    color: const Color(0xFFFDFDFD),
                    fontSize: 17,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    shadows: [
                      Shadow(
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ..._todayOrders.map((order) => _buildOrderCard(order)).toList(),

                const SizedBox(height: 10),

                Text(
                  'Yesterday',
                  style: TextStyle(
                    color: const Color(0xFFFDFDFD),
                    fontSize: 17,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    shadows: [
                      Shadow(
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ..._yesterdayOrders
                    .map((order) => _buildOrderCard(order))
                    .toList(),
              ],
            ),
          ),
        ],
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> data) {
    bool isActive = data['isActive'] ?? false;
    bool hasCancel = data['hasCancel'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(15),
      decoration: ShapeDecoration(
        color: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(
          side: isActive
              ? const BorderSide(width: 1, color: Color(0xFF73986F))
              : BorderSide.none,
          borderRadius: BorderRadius.circular(16.69),
        ),
        shadows: [
          if (isActive)
            const BoxShadow(color: Color(0xFF73986F), blurRadius: 7)
          else
            const BoxShadow(
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
                data['time'],
                style: const TextStyle(
                  color: Color(0xFF51725F),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'See Details',
                style: TextStyle(
                  color: Color(0xFF51725F),
                  fontSize: 10,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order’s ID',
                style: TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                data['price'],
                style: const TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Product: ',
                  style: TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: data['product'],
                  style: const TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Qty: ',
                      style: TextStyle(
                        color: Color(0xFF51725F),
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: '${data['qty']}',
                      style: const TextStyle(
                        color: Color(0xFF51725F),
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              if (hasCancel)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF26F71), Color(0xFFC23437)],
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(41),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 1.68,
                        offset: Offset(0, 1.68),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Cancel Order',
                    style: TextStyle(
                      color: Color(0xFFFBFBFB),
                      fontSize: 8,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),

          _buildStatusTracker(data['status']),
        ],
      ),
    );
  }

  Widget _buildStatusTracker(int statusIndex) {
    double barWidthFactor;
    switch (statusIndex) {
      case 0:
        barWidthFactor = 0.20;
        break;
      case 1:
        barWidthFactor = 0.45;
        break;
      case 2:
        barWidthFactor = 0.75;
        break;
      case 3:
        barWidthFactor = 1.0;
        break;
      default:
        barWidthFactor = 0.20;
    }

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 6,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF848484),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7500),
                    ),
                  ),
                ),
                Container(
                  width: constraints.maxWidth * barWidthFactor,
                  height: 6,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7500),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 6),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Waiting',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 11,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Preparing',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 11,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'On The Way',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 11,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Delivered',
              style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 11,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
