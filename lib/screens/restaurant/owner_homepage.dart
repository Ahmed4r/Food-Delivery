import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/restaurant/res_drawer.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:food_delivery/theme/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerHomepage extends StatefulWidget {
  static const String routeName = 'owner_homepage';
  const OwnerHomepage({super.key});

  @override
  State<OwnerHomepage> createState() => _OwnerHomepageState();
}

class _OwnerHomepageState extends State<OwnerHomepage> {
  Future<void> _getuserDate() async {
    var prefs = await SharedPreferences.getInstance();
    var name = prefs.getString('profile_name') ?? '';
    var email = prefs.getString('email');
    var phone = prefs.getString('phone');
    var addressJsonList = prefs.getStringList('addresses') ?? [];
    List<String> addressList = addressJsonList.map((jsonStr) {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return map['label'] as String;
    }).toList();
    setState(() {
      _userName = name;
      _Address = addressList;
      // Ensure _selectedAddress is valid
      if (_selectedAddress >= _Address.length) {
        _selectedAddress = 0;
      }
    });
  }

  int _selectedAddress = 0;
  int isSelectedIndex = 0;
  late final TextEditingController _searchController;
  String _userName = '';
  List<String> _Address = [];
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      drawer: const ResDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDark),
              const SizedBox(height: 30),
              _buildMetricsRow(isDark),
              const SizedBox(height: 30),
              _buildRevenueSection(isDark),
              const SizedBox(height: 30),
              _buildReviewsSection(isDark),
              const SizedBox(height: 30),
              _buildPopularItemsSection(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return PreferredSize(
      preferredSize: Size.fromHeight(90.h),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Menu Icon + Deliver Info
              Row(
                children: [
                  // Menu icon in circle
                  Builder(
                    builder: (context) {
                      return GestureDetector(
                        onTap: () => Scaffold.of(context).openDrawer(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F1F5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.menu, color: Colors.black),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  // Deliver to text and location
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'DELIVER TO',
                        style: GoogleFonts.sen(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            _Address.isEmpty
                                ? 'Add Address'
                                : _Address[_selectedAddress],
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 250.h,
                                      child: ListView.builder(
                                        itemCount: _Address.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(_Address[index]),
                                            onTap: () {
                                              setState(() {
                                                _selectedAddress = index;
                                              });
                                              Navigator.pop(context);
                                            },
                                            trailing: _selectedAddress == index
                                                ? const Icon(Icons.check,
                                                    color: Colors.orange)
                                                : null,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              icon:
                                  Icon(Icons.keyboard_arrow_down, size: 18.sp)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              CircleAvatar(
                backgroundImage:
                    const AssetImage('assets/images/profile_img.png'),
                radius: 30.r,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard('20', 'RUNNING ORDERS', isDark, 0),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildMetricCard('05', 'ORDER REQUEST', isDark, 1),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String value, String label, bool isDark, int index) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            if (index == 0) {
              // Running Orders
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: const RunningOrdersList(),
              );
            } else {
              // Order Requests
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: const OrderRequestsList(),
              );
            }
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: AppColors.dark_grey),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Placeholder for Running Orders

  Widget _buildRevenueSection(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Revenue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '\$2,241',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Daily',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'See Details',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),
            _buildRevenueChart(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(bool isDark) {
    return SizedBox(
      height: 180,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomPaint(
          painter: RevenueChartPainter(),
          child: Container(),
        ),
      ),
    );
  }

  Widget _buildReviewsSection(bool isDark) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.dark_grey),
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.star, color: Color(0xFFFF6B35), size: 20),
                    SizedBox(width: 6),
                    Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Total 20 Reviews',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              'See All Reviews',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF6B35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItemsSection(bool isDark) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.dark_grey),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Items This Weeks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9CAAB8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9CAAB8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RevenueChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF6B35)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFF6B35).withOpacity(0.3),
          const Color(0xFFFF6B35).withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Sample data points for the revenue chart
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.15, size.height * 0.6),
      Offset(size.width * 0.3, size.height * 0.4),
      Offset(size.width * 0.45, size.height * 0.2), // Peak at $500
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.75, size.height * 0.25),
      Offset(size.width * 1, size.height * 0.15),
    ];

    // Draw the main line
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      final cp1 = Offset(
        points[i - 1].dx + (points[i].dx - points[i - 1].dx) * 0.5,
        points[i - 1].dy,
      );
      final cp2 = Offset(
        points[i - 1].dx + (points[i].dx - points[i - 1].dx) * 0.5,
        points[i].dy,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
    }

    // Create fill path
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    // Draw fill
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    canvas.drawPath(path, paint);

    // Draw peak point with value
    final peakPoint = points[3];
    final circlePaint = Paint()
      ..color = const Color(0xFFFF6B35)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(peakPoint, 6, circlePaint);
    canvas.drawCircle(
        peakPoint,
        6,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
    canvas.drawCircle(peakPoint, 4, circlePaint);

    // Draw $500 label
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '\$500',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final labelRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(peakPoint.dx, peakPoint.dy - 25),
        width: textPainter.width + 16,
        height: textPainter.height + 8,
      ),
      const Radius.circular(15),
    );

    canvas.drawRRect(labelRect, Paint()..color = const Color(0xFF4A4A4A));
    textPainter.paint(
      canvas,
      Offset(
        peakPoint.dx - textPainter.width / 2,
        peakPoint.dy - 25 - textPainter.height / 2,
      ),
    );

    // Draw time labels
    final timeLabels = ['10AM', '11AM', '12PM', '01PM', '02PM', '03PM', '04PM'];
    for (int i = 0; i < timeLabels.length; i++) {
      final x = (size.width / (timeLabels.length - 1)) * i;
      final timePainter = TextPainter(
        text: TextSpan(
          text: timeLabels[i],
          style: const TextStyle(
            color: Colors.black38,
            fontSize: 11,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      timePainter.layout();
      timePainter.paint(
        canvas,
        Offset(x - timePainter.width / 2, size.height + 10),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FoodOrderCard extends StatelessWidget {
  final String category;
  final String title;
  final String id;
  final String price;
  final VoidCallback? onDone;
  final VoidCallback? onCancel;

  const FoodOrderCard({
    super.key,
    this.category = '#Breakfast',
    this.title = 'Chicken Thai Biriyani',
    this.id = 'ID: 32053',
    this.price = '\$60',
    this.onDone,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Food Image Placeholder
          Container(
            width: 110.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: Colors.blueGrey[300],
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(width: 16),

          // Food Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Text(
                  category,
                  style: const TextStyle(
                    color: Color(0xFFFF6B35),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    // color: Color(0xFF1F2937),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),

                // ID
                Text(
                  id,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 20),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 10.h,
                    ),
                    // Done Button
                    ElevatedButton(
                      onPressed: onDone,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: isDark == true ? Colors.black : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Cancel Button
                    OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF6B35),
                        side: const BorderSide(
                          color: Color(0xFFFF6B35),
                          width: 1.5,
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage in a screen
class FoodOrderScreen extends StatelessWidget {
  const FoodOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Food Orders'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: FoodOrderCard(
          onDone: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order marked as done!')),
            );
          },
          onCancel: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order cancelled!')),
            );
          },
        ),
      ),
    );
  }
}

// Main app

class RunningOrdersList extends StatelessWidget {
  const RunningOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        FoodOrderCard(title: 'Running Order 1'),
        FoodOrderCard(title: 'Running Order 2'),
      ],
    );
  }
}

// Placeholder for Order Requests
class OrderRequestsList extends StatelessWidget {
  const OrderRequestsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        FoodOrderCard(title: 'Order Request 1'),
        FoodOrderCard(title: 'Order Request 2'),
      ],
    );
  }
}
