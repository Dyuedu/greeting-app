class CustomSticker {
  final int? id;
  final String localPath;
  final String name;
  final int createdAt;

  CustomSticker({
    this.id,
    required this.localPath,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'localPath': localPath,
      'name': name,
      'createdAt': createdAt,
    };
  }

  factory CustomSticker.fromMap(Map<String, dynamic> map) {
    return CustomSticker(
      id: map['id'] as int?,
      localPath: map['localPath'] as String,
      name: map['name'] as String,
      createdAt: map['createdAt'] as int,
    );
  }
}
