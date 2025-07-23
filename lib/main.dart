import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main ()async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(

     EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/lang',
      fallbackLocale: Locale('en'),
      child: FoodDelivery()
 


  ));
}
class FoodDelivery extends StatelessWidget {
  const FoodDelivery({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}