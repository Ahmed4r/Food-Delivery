import 'package:flutter/material.dart';

class AddressModel {
  final String label;
  final String address;
  final String iconName; // Use icon name as string
  final Color iconColor;

  AddressModel({
    required this.label,
    required this.address,
    required this.iconName,
    required this.iconColor,
  });

  IconData get icon => _iconFromName(iconName);

  Map<String, dynamic> toJson() => {
        'label': label,
        'address': address,
        'iconName': iconName,
        'iconColor': iconColor.value,
      };

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        label: json['label'],
        address: json['address'],
        iconName: json['iconName'],
        iconColor: Color(json['iconColor']),
      );

  static IconData _iconFromName(String name) {
    switch (name) {
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'location_on':
        return Icons.location_on;
      default:
        return Icons.place;
    }
  }
}
