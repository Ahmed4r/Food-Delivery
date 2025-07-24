import 'package:flutter/material.dart';
import 'package:food_delivery/widgets/custom_drawer.dart';


class Homepage extends StatelessWidget {
  static const String routeName = '/customer_homepage';

  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      drawer: CustomDrawer(),
    );
  }
}
