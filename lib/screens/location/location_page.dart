import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/services/location_service.dart';
import 'package:food_delivery/widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';


class LocationAccessPage extends StatefulWidget {
  static const String routeName = '/location-access';

  const LocationAccessPage({super.key});
  @override

  _LocationAccessPageState createState() => _LocationAccessPageState();
}

class _LocationAccessPageState extends State<LocationAccessPage> {
  bool _locationServiceEnabled = false;
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationService();
  }

  Future<void> _checkLocationService() async {
    await LocationService.checkLocationService();
    setState(() {
      _locationServiceEnabled = true;
    });
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    await LocationService.requestLocationPermission();
    setState(() {
      _locationPermissionGranted = true;
      // Navigator.pushNamed(context, Homepage.routeName);
    });
  }


  @override
  Widget build(BuildContext context) {
     final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('location access'.tr(),style: GoogleFonts.sen(color:isDark?Colors.black: Colors.white),),

      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
          
              radius: 100.r,
              backgroundImage: const AssetImage('assets/images/location.jpg'),
            ),
            SizedBox(height: 30.h,),

            customButtom(title:  _locationPermissionGranted ? 'LOCATION IS ENABLED'.tr() : 'ACCESS LOCATION'.tr()),
            SizedBox(height: 20.h,),
            Text(_locationPermissionGranted ? 'LOCATION IS ENABLED FOR THIS APP'.tr() : 'this app will access your location\n only while using the app'.tr(),style: GoogleFonts.sen(color:isDark?Colors.white: Colors.black),)


          ]
        ),
      ),
    );
  }
}