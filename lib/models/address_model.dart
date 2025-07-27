
import 'package:flutter/material.dart';

class AddressModel {
  final String label;
  final String address;
  final IconData icon;
  final Color iconColor;

  AddressModel({
    required this.label,
    required this.address,
    required this.icon,
    required this.iconColor,
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'address': address,
        'icon': icon.codePoint,
        'iconFontFamily': icon.fontFamily,
        'iconFontPackage': icon.fontPackage,
        'iconMatchTextDirection': icon.matchTextDirection,
        'iconColor': iconColor.value,
      };

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        label: json['label'],
        address: json['address'],
        icon: IconData(
          json['icon'],
          fontFamily: json['iconFontFamily'],
          fontPackage: json['iconFontPackage'],
          matchTextDirection: json['iconMatchTextDirection'] ?? false,
        ),
        iconColor: Color(json['iconColor']),
      );
}