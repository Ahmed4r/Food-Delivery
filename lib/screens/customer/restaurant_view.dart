import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/models/menu_item_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// MenuItem Model (add this to your models if you haven't already)

class RestaurantViewScreen extends StatefulWidget {
  static const String routeName = '/restaurant_view';

  const RestaurantViewScreen({super.key});

  @override
  State<RestaurantViewScreen> createState() => _RestaurantViewScreenState();
}

class _RestaurantViewScreenState extends State<RestaurantViewScreen> {
  String selectedCategory = 'الكل';
  List<String> categories = ['الكل'];
  Map<String, dynamic>? restaurantData;
  List<MenuItem> menuItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the restaurant data passed from homepage
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      restaurantData = args;
      _initializeCategories();
    }
  }

  void _initializeCategories() {
    if (restaurantData != null) {
      // For now, we'll create categories based on cuisine type
      // Later you can fetch actual menu items from Firebase
      String cuisine = restaurantData!['cuisine'] ?? '';
      categories = ['الكل', cuisine];
      selectedCategory = cuisine.isNotEmpty ? cuisine : 'الكل';

      // TODO: Fetch actual menu items from Firebase based on restaurant ID
      // For now, we'll show placeholder message
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (restaurantData == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'error while tryingh to fetch data',
            style: GoogleFonts.cairo(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.black, size: 16),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          restaurantData!['name'] ?? 'مطعم',
          style: GoogleFonts.cairo(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.more_horiz, color: Colors.black),
              onPressed: () {
                // Show options menu
                _showOptionsMenu();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant Image with Status
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: restaurantData!['image'] != null &&
                            restaurantData!['image'].isNotEmpty
                        ? Image.network(
                            restaurantData!['image'],
                            width: double.infinity,
                            height: 150.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: 150.h,
                                color: const Color(0xFF8FA0A8),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.utensils,
                                    size: 50.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            width: double.infinity,
                            height: 150.h,
                            color: const Color(0xFF8FA0A8),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.utensils,
                                size: 50.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                    top: 15.h,
                    right: 15.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: (restaurantData!['opened'] ?? false)
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Text(
                        (restaurantData!['opened'] ?? false)
                            ? 'opened'
                            : 'closed',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Restaurant Name and Cuisine
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      restaurantData!['name'] ?? '',
                      style: GoogleFonts.cairo(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      restaurantData!['cuisine'] ?? '',
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Location
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey[600], size: 18.sp),
                  SizedBox(width: 4.w),
                  Text(
                    restaurantData!['location'] ?? '',
                    style: GoogleFonts.cairo(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Rating, Delivery Info
              Row(
                children: [
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.star,
                          color: Colors.orange[700], size: 20.sp),
                      SizedBox(width: 4.w),
                      Text(
                        restaurantData!['rating'] ?? '0',
                        style: GoogleFonts.cairo(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 30.w),
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.truck,
                          color: Colors.orange[700], size: 20.sp),
                      SizedBox(width: 4.w),
                      Text(
                        (restaurantData!['deliveryFee'] ?? '0') == '0'
                            ? 'free'
                            : '${restaurantData!['deliveryFee']} egp',
                        style: GoogleFonts.cairo(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 30.w),
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.clock,
                          color: Colors.orange[700], size: 20.sp),
                      SizedBox(width: 4.w),
                      Text(
                        '${restaurantData!['deliveryTime'] ?? '0'} minutes',
                        style: GoogleFonts.cairo(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              // Category Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    bool isSelected = category == selectedCategory;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 15.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange[700]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.cairo(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 25.h),

              // Section Title
              Text(
                '$selectedCategory (${menuItems.length})',
                style: GoogleFonts.cairo(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              SizedBox(height: 20.h),

              // Menu Items or Placeholder
              menuItems.isNotEmpty
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 15.h,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        MenuItem item = menuItems[index];
                        return _buildMenuItem(item, isDark);
                      },
                    )
                  : _buildMenuPlaceholder(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuPlaceholder(bool isDark) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.utensils,
            size: 50.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'قائمة الطعام قريباً',
            style: GoogleFonts.cairo(
              fontSize: 18.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'سيتم إضافة العناصر قريباً',
            style: GoogleFonts.cairo(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.r),
              topRight: Radius.circular(15.r),
            ),
            child: item.imageUrl.isNotEmpty
                ? Image.network(
                    item.imageUrl,
                    height: 100.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100.h,
                        color: const Color(0xFF8FA0A8),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.burger,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    height: 100.h,
                    color: const Color(0xFF8FA0A8),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.burger,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                  ),
          ),

          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.description.isNotEmpty
                      ? item.description
                      : restaurantData!['name'] ?? '',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.price.toStringAsFixed(0)} ج.م',
                      style: GoogleFonts.cairo(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add to cart functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم إضافة ${item.name} إلى السلة',
                              style: GoogleFonts.cairo(),
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      child: Container(
                        width: 30.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: Colors.orange[700],
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18.sp,
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

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: Text('إضافة إلى المفضلة', style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  // Add to favorites functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: Text('مشاركة المطعم', style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  // Share restaurant functionality
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text('معلومات المطعم', style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  // Show restaurant info
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
