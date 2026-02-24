class CardSlot {
  final String id;
  final double top;
  final double left;
  String? selectedStickerPath; 

  CardSlot({
    required this.id,
    required this.top,
    required this.left,
    this.selectedStickerPath,
  });
}
