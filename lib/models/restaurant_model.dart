// import 'package:cloud_firestore/cloud_firestore.dart';


class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final String image;
  final String location;
  final String rating;
  final String deliveryFee;
  final String deliveryTime;
  final bool opened;
  final bool isPopular;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.image,
    required this.location,
    required this.rating,
    required this.deliveryFee,
    required this.deliveryTime,
    required this.opened,
    this.isPopular = false,
  });

  factory Restaurant.fromFirestore(Map<String, dynamic> map) {
    // Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Restaurant(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      cuisine: map['cuisine'] ?? '',
      image: map['image'] ?? '',
      location: map['location'] ?? '',
      rating: map['rating'] ?? '0',
      deliveryFee: map['deliveryFee'] ?? '0',
      deliveryTime: map['deliveryTime'] ?? '0',
      opened: map['opened'] ?? false,
      isPopular: map['isPopular'] ?? false,
    );
  }

  // Convert to Map for passing as arguments
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cuisine': cuisine,
      'image': image,
      'location': location,
      'rating': rating,
      'deliveryFee': deliveryFee,
      'deliveryTime': deliveryTime,
      'opened': opened,
      'isPopular': isPopular,
    };
  }
}
