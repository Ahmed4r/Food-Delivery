import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery/models/restaurant_model.dart';
import 'package:food_delivery/screens/customer/restaurant_view.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:food_delivery/widgets/custom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  static const String routeName = '/customer_homepage';

  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedAddress = 0;
  int isSelectedIndex = 0;
  late final TextEditingController _searchController;
  String _userName = '';
  List<String> _Address = [];

  final List<Map<String, dynamic>> categories = [
    {
      "title": "All",
      "image": "https://img.icons8.com/color/96/000000/fire-element.png",
    },
    {
      "title": "Burger",
      "image": "https://img.icons8.com/color/96/000000/hamburger.png",
    },
    {
      "title": "Pizza",
      "image": "https://img.icons8.com/color/96/000000/pizza.png",
    },
    {
      "title": "Drinks",
      "image": "https://img.icons8.com/color/96/000000/cocktail.png",
    },
    {
      "title": "Desserts",
      "image": "https://img.icons8.com/color/96/000000/cake.png",
    },
  ];

  // Updated to return Restaurant objects
  Future<List<Restaurant>> fetchRestaurants() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('restaurants').get();
    return snapshot.docs
        .map((doc) => Restaurant.fromFirestore(doc.data()))
        .toList();
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1)); // أو نداء API مثلاً
    setState(() {
      // عدّل الداتا أو أعد تحميلها
    });
  }

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

      if (_selectedAddress >= _Address.length) {
        _selectedAddress = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _getuserDate();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FutureBuilder<List<Restaurant>>(
      future: fetchRestaurants(),
      builder: (context, snapshot) {
        final restaurants = snapshot.data ?? [];

        Widget buildSectionHeader(String title) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      // Convert Restaurant objects back to Maps for SeeAllRestaurantsScreen
                      final restaurantMaps =
                          restaurants.map((r) => r.toMap()).toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SeeAllRestaurantsScreen(
                            restaurants: restaurantMaps,
                            restaurantCardBuilder:
                                (Map<String, dynamic> restaurantMap) {
                              final restaurant =
                                  Restaurant.fromFirestore(restaurantMap);
                              return _buildRestaurantCard(restaurant, context);
                            },
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14.sp,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ],
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: isDark ? Colors.black : Colors.white,
            body: Center(
                child: CircularProgressIndicator(
              color: isDark ? Colors.white : Colors.black,
            )),
          );
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading restaurants'));
        }
        return Scaffold(
          appBar: PreferredSize(
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
                                child:
                                    const Icon(Icons.menu, color: Colors.black),
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
                                                trailing: _selectedAddress ==
                                                        index
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
                                  icon: Icon(Icons.keyboard_arrow_down,
                                      size: 18.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0C1224),
                            shape: BoxShape.circle,
                          ),
                          child: const FaIcon(
                            FontAwesomeIcons.cartShopping,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          drawer: const CustomDrawer(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hey $_userName, Welcome Back',
                    style: GoogleFonts.sen(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: isDark
                          ? Colors.black
                          : const Color.fromARGB(179, 241, 239, 239),
                      hintText: 'Search for food'.tr(),
                      hintStyle: GoogleFonts.sen(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                isDark ? Colors.black : AppColors.light_grey),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                isDark ? Colors.black : AppColors.light_grey),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                isDark ? Colors.black : AppColors.light_grey),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'All Categories'.tr(),
                        style: GoogleFonts.sen(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SeeAllCategoriesScreen(
                                    categories: categories,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'See All',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 80.h,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 10.w);
                      },
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return _buildCategoryChip(
                          categories[index]['title'],
                          categories[index]['image'],
                          index,
                        );
                      },
                      itemCount: 4,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  buildSectionHeader('opened Restaurants'.tr()),
                  SizedBox(height: 16.h),
                  RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.separated(
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16.h);
                      },
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        return _buildRestaurantCard(
                            restaurants[index], context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(String title, String image, int index) {
    bool isSelected = isSelectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orangeAccent : AppColors.light_grey,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.black : AppColors.light_grey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.network(
                  image ?? '',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image, color: Colors.grey[400]);
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black87 : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated to accept Restaurant object and pass data properly
  Widget _buildRestaurantCard(Restaurant restaurant, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        // Pass the restaurant data to RestaurantViewScreen
        Navigator.pushNamed(
          context,
          RestaurantViewScreen.routeName,
          arguments: restaurant.toMap(), // Pass restaurant data as arguments
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.dark_grey : AppColors.secondary_white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Image
            Stack(
              children: [
                Container(
                  height: 160.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                    child: Image.network(
                      restaurant.image.isNotEmpty ? restaurant.image : "",
                      width: double.infinity,
                      height: 160.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160.h,
                          width: double.infinity,
                          color: Colors.grey[400],
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.utensils,
                              size: 50.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Popular Badge
                if (restaurant.isPopular ?? false)
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Popular',
                        style: GoogleFonts.sen(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                // Open/Closed Status Badge
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: restaurant.opened ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      restaurant.opened ? 'مفتوح' : 'مغلق',
                      style: GoogleFonts.sen(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Restaurant Details
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name ?? 'null',
                          style: GoogleFonts.sen(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        restaurant.location ?? 'null',
                        style: GoogleFonts.sen(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    restaurant.cuisine ?? 'null',
                    style: GoogleFonts.sen(
                      fontSize: 15.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Rating, Delivery, and Time Row
                  Row(
                    children: [
                      // Rating
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.star,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            restaurant.rating ?? 'null',
                            style: GoogleFonts.sen(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 24.w),

                      // Delivery
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.truck,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            restaurant.deliveryFee == '0'
                                ? 'مجاني'
                                : '${restaurant.deliveryFee} ج.م' ?? 'null',
                            style: GoogleFonts.sen(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 24.w),

                      // Time
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.clock,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${restaurant.deliveryTime} دقيقة' ?? 'null',
                            style: GoogleFonts.sen(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
