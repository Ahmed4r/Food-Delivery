import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationAccessPage extends StatefulWidget {
  static const String routeName ='/location-access';
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
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    setState(() {
      _locationServiceEnabled = true;
    });
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error('Location permissions are denied');
    }
    setState(() {
      _locationPermissionGranted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Access'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Location Access',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'This app needs access to your location to function properly.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _locationServiceEnabled && _locationPermissionGranted
                  ? null
                  : _checkLocationService,
              child: Text(
                'Enable Location Access',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _locationServiceEnabled
                  ? 'Location service is enabled.'
                  : 'Location service is not enabled.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              _locationPermissionGranted
                  ? 'Location permission is granted.'
                  : 'Location permission is not granted.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}