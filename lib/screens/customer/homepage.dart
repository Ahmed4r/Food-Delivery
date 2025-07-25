import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery/theme/app_colors.dart';
import 'package:food_delivery/widgets/custom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  static const String routeName = '/customer_homepage';

  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int isSelectedIndex=0;
  final List<Map<String, dynamic>> categories = [

    {"title": "All", "icon": FontAwesomeIcons.fire},
    {"title": "Burger", "icon": Icons.fastfood},
    {"title": "Pizza", "icon": Icons.local_pizza},
    {"title": "Drinks", "icon": Icons.local_drink},
    {"title": "Desserts", "icon": Icons.cake},
    {"title": "Sushi", "icon": Icons.rice_bowl},
  ];
  final List<Map<String, dynamic>> restaurants = [
    {
      "name": "Rose Garden Restaurant",
      "cuisine": "Burger - Chicken - Riche - Wings",
      "rating": 4.7,
      "deliveryFee": "Free",
      "deliveryTime": "20 min",
      "image": "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400",
      "opened": true,
    },
    {
      "name": "Mario's Italian Kitchen",
      "cuisine": "Pizza - Pasta - Italian",
      "rating": 4.5,
      "deliveryFee": "\$2.99",
      "deliveryTime": "25 min",
      "image": "https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400",
      "opened": true,

    },
    {
      "name": "Spice Corner",
      "cuisine": "Indian - Curry - Biryani",
      "rating": 4.3,
      "deliveryFee": "Free",
      "deliveryTime": "30 min",
      "image": "https://images.unsplash.com/photo-1552566626-52f8b828add9?w=400",
      "opened": false,
    },
    {
      "name": "Sushi Master",
      "cuisine": "Japanese - Sushi - Ramen",
      "rating": 4.8,
      "deliveryFee": "\$3.99",
      "deliveryTime": "35 min",
      "image": "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400",
      "opened": true,
    },
    {
      "name": "Taco Fiesta",
      "cuisine": "Mexican - Tacos - Burritos",
      "rating": 4.4,
      "deliveryFee": "Free",
      "deliveryTime": "18 min",
      "image": "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400",
      "opened": false,
    },
    {
      "name": "The Breakfast Club",
      "cuisine": "Breakfast - Coffee - Pancakes",
      "rating": 4.6,
      "deliveryFee": "\$1.99",
      "deliveryTime": "22 min",
      "image": "https://images.unsplash.com/photo-1551218808-94e220e084d2?w=400",
      "opened": true,
    },
    {
      "name": "BBQ Paradise",
      "cuisine": "BBQ - Grilled - Steaks",
      "rating": 4.5,
      "deliveryFee": "\$2.49",
      "deliveryTime": "28 min",
      "image": "https://images.unsplash.com/photo-1544025162-d76694265947?w=400",
      "opened": false,
    },
    {
      "name": "Veggie Delight",
      "cuisine": "Vegetarian - Salads - Healthy",
      "rating": 4.2,
      "deliveryFee": "Free",
      "deliveryTime": "15 min",
      "image": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400",
      "opened": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.h), // ارتفاع مخصص
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFF1F1F5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.menu, color: Colors.black),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 12),
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
                              'Halal Lab office',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFF0C1224),
                        shape: BoxShape.circle,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.cartShopping,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
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
      drawer: CustomDrawer(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey Ahmed, Welcome Back',
                style: GoogleFonts.sen(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10.h),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for food'.tr(),
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.light_grey),

                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.light_grey),

                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.dark_grey),

                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
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
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
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
                    return _buildCategoryChip(categories[index]['title'], categories[index]['icon'],index);
                  },
                  itemCount: categories.length,
                ),
              ),
               SizedBox(height: 16.h),
           
              _buildSectionHeader('opened Restaurants'.tr()),
              SizedBox(height: 16.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return SizedBox(height: 16.h);
                },
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  return _buildRestaurantCard(restaurants[index]);
                },
              ),
              
         
              // _buildRestaurantCard(restaurants[6]),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Row(
          children: [
            Text(
              'See All',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[600]),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String title,IconData icon, int index) {
    bool isSelected = isSelectedIndex == index;
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
                color:AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Center(child: FaIcon(icon, color: Colors.red,))
            ),
            const SizedBox(width: 8),
            Text(
            title,
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
}

 Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                    restaurant['image'],
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
              if (restaurant['isPopular']==true)
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
              // Favorite Icon
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.heart,
                    size: 18.sp,
                    color: Colors.grey[700],
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
                Text(
                  restaurant['name'],
                  style: GoogleFonts.sen(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  restaurant['cuisine'],
                  style: GoogleFonts.sen(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
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
                          color: Colors.orange,
                          size: 18.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          restaurant['rating'].toString(),
                          style: GoogleFonts.sen(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
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
                          color: Colors.orange,
                          size: 18.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          restaurant['deliveryFee'],
                          style: GoogleFonts.sen(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
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
                          color: Colors.orange,
                          size: 18.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          restaurant['deliveryTime'],
                          style: GoogleFonts.sen(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
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
    );
  }
