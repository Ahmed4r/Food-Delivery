import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/homepage.dart';
import 'package:food_delivery/services/location_service.dart';
import 'package:food_delivery/widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';


class LocationAccessPage extends StatefulWidget {
  static const String routeName = '/location-access';
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
      Navigator.pushNamed(context, Homepage.routeName);
    });
  }


  @override
  Widget build(BuildContext context) {
     final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            customButtom(title:  _locationPermissionGranted ? 'LOCATION IS ENABLED' : 'ACCESS LOCATION'),
            SizedBox(height: 20.h,),
            Text(_locationPermissionGranted ? 'LOCATION IS ENABLED FOR THIS APP' : 'this app will access your location\n only while using the app',style: GoogleFonts.sen(color:isDark?Colors.white: Colors.black),)


          ]
        ),
      ),
    );
  }
}