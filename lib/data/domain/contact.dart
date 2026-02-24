class Contact {
  final int? id;
  final String name;
  final String phone;
  final int relationshipType;
  final int greetingStatus;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.relationshipType,
    required this.greetingStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relationshipType': relationshipType,
      'greetingStatus': greetingStatus,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      relationshipType: map['relationshipType'],
      greetingStatus: map['greetingStatus'],
    );
  }
}
