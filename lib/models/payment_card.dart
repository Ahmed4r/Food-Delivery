class PaymentCard {
  final String id;
  final String type;
  final String last4;
  final String cardholderName;

  PaymentCard({
    required this.id,
    required this.type,
    required this.last4,
    required this.cardholderName,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'last4': last4,
    'cardholderName': cardholderName,
  };

  factory PaymentCard.fromJson(Map<String, dynamic> json) => PaymentCard(
    id: json['id'],
    type: json['type'],
    last4: json['last4'],
    cardholderName: json['cardholderName'],
  );
}