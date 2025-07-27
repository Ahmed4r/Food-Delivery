import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delivery/models/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:food_delivery/services/location_service.dart';
import 'package:food_delivery/theme/app_colors.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AddressListScreen extends StatefulWidget {
  static String routeName = 'address_list';

  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  List<AddressModel> addresses = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? addressJsonList = prefs.getStringList('addresses');
    if (addressJsonList != null) {
      setState(() {
        addresses = addressJsonList
            .map((jsonStr) => AddressModel.fromJson(
                Map<String, dynamic>.from(
                    jsonDecode(jsonStr) as Map)))
            .toList();
      });
    }
  }

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> addressJsonList =
        addresses.map((a) => jsonEncode(a.toJson())).toList();
    await prefs.setStringList('addresses', addressJsonList);
  }

  Future<void> _addNewAddress() async {
    final AddressModel? newAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressDetailsScreen(),
      ),
    );
    if (newAddress != null) {
      setState(() {
        addresses.add(newAddress);
      });
      await _saveAddresses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Address',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: address.iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        address.icon,
                        color: address.iconColor,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      address.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        address.address,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () {
                            setState(() {
                              addresses.removeAt(index);
                            });
                            _saveAddresses();
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // You can implement view/edit on tap if needed
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _addNewAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'ADD NEW ADDRESS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressDetailsScreen extends StatefulWidget {
  final AddressModel? address;

  const AddressDetailsScreen({super.key, this.address});

  @override
  _AddressDetailsScreenState createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  final MapController mapController = MapController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController postCodeController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();

  String selectedLabel = 'Home';
  final List<String> labels = ['Home', 'Work', 'Other'];

  LatLng selectedLocation = LatLng(40.7589, -73.9851); // Default to New York
  List<Marker> markers = [];
  String currentAddress = 'Loading address...';
  bool isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      streetController.text = 'Hason Nagar';
      postCodeController.text = '34567';
      apartmentController.text = '345';
      selectedLabel = widget.address!.label == 'HOME'
          ? 'Home'
          : widget.address!.label == 'WORK'
              ? 'Work'
              : 'Other';
    }

    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _getCurrentLocation();
    _updateMarker(selectedLocation);
    _updateAddress(selectedLocation);
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    try {
      Position? position = await LocationService.getCurrentLocation(context);
      if (position != null) {
        setState(() {
          selectedLocation = LatLng(position.latitude, position.longitude);
        });

        mapController.move(selectedLocation, 15.0);
        _updateMarker(selectedLocation);
        _updateAddress(selectedLocation);
      }
    } catch (e) {
      print('Error getting current location: $e');
      _updateAddress(selectedLocation);
    } finally {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  void _updateMarker(LatLng location) {
    setState(() {
      markers = [
        Marker(
          point: location,
          child: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40,
          ),
        ),
      ];
    });
  }

  Future<void> _updateAddress(LatLng location) async {
    try {
      String address = await LocationService.getAddressFromCoordinates(
        location.latitude,
        location.longitude,
      );
      setState(() {
        currentAddress = address;
      });

      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (place.street != null && place.street!.isNotEmpty) {
          streetController.text = place.street!;
        }
        if (place.postalCode != null && place.postalCode!.isNotEmpty) {
          postCodeController.text = place.postalCode!;
        }
      }
    } catch (e) {
      setState(() {
        currentAddress = 'Address not available';
      });
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng location) async {
    setState(() {
      selectedLocation = location;
    });
    _updateMarker(location);
    _updateAddress(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Map Section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Stack(
              children: [
                FlutterMap(

                  mapController: mapController,
                  options: MapOptions(
                 
                    initialCenter: selectedLocation,
                    initialZoom: 15.0,
                    onTap: _onMapTap,
                    minZoom: 3.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                   
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.address_manager',
                      maxNativeZoom: 19,
                      maxZoom: 19,
                      additionalOptions: {
                        'id': 'openstreetmap',
                      },
                    ),
                    MarkerLayer(

                      markers: markers,
                    ),
                  ],
                ),
                if (isLoadingLocation)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                Positioned(
                  top: 50,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 16,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.locationArrow,color: Colors.white,),
                          onPressed: _getCurrentLocation,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Tap to edit location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[600]),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            currentAddress,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Form Section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ADDRESS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            currentAddress,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STREET',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: streetController,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Enter street name',
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                ),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'POST CODE',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: postCodeController,
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Enter post code',
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                ),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'APARTMENT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: apartmentController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter apartment number',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'LABEL AS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: labels.map((label) {
                      final isSelected = selectedLabel == label;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedLabel = label;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: label != labels.last ? 8 : 0),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.grey[100],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? Colors.white : Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Return the new address to the previous screen
                        Navigator.pop(
                          context,
                          AddressModel(
                            label: selectedLabel.toUpperCase(),
                            address: currentAddress,
                            icon: selectedLabel == 'Home'
                                ? Icons.home
                                : selectedLabel == 'Work'
                                    ? Icons.work
                                    : Icons.location_on,
                            iconColor: selectedLabel == 'Home'
                                ? Colors.blue
                                : selectedLabel == 'Work'
                                    ? Colors.purple
                                    :AppColors.primary,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'SAVE LOCATION',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}