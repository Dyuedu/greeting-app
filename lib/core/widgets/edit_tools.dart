import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:greeting_app/data/domain/sticker_item.dart';
import 'package:greeting_app/viewmodels/greeting_card/greeting_card_view_model.dart';

class EditorTools extends StatelessWidget {
  final GreetingCardViewModel vm;
  final Function(BuildContext, GreetingCardViewModel) onAddSticker;

  const EditorTools({
    super.key,
    required this.vm,
    required this.onAddSticker,
  });

  @override
  Widget build(BuildContext context) {
    final selectedSticker = vm.selectedStickerId != null
        ? vm.stickers.cast<StickerItem?>().firstWhere(
            (s) => s?.id == vm.selectedStickerId,
            orElse: () => null,
          )
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (image != null) vm.setBackgroundImage(File(image.path));
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Ảnh nền"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => onAddSticker(context, vm),
                  icon: const Icon(Icons.add_reaction),
                  label: const Text("Thêm Sticker"),
                ),
              ),
            ],
          ),

          if (selectedSticker != null) ...[
            const SizedBox(height: 15),
            _buildScaleSlider(selectedSticker),
            const SizedBox(height: 10),
            _buildRotationSlider(selectedSticker),
          ],

          const SizedBox(height: 15),
          TextField(
            decoration: InputDecoration(
              labelText: "Nội dung lời chúc",
              prefixIcon: const Icon(Icons.edit_note),
              border: const OutlineInputBorder(),
              suffixIcon: _buildSuggestionMenu(),
            ),
            onChanged: (val) => vm.updateMessage(val),
          ),

          const SizedBox(height: 20),
          const Text("Màu sắc lời chúc:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildColorPicker(),
        ],
      ),
    );
  }

  Widget _buildScaleSlider(StickerItem sticker) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.zoom_in, size: 22, color: Colors.blue),
          Expanded(
            child: Slider(
              value: sticker.scale,
              min: 0.5, max: 3.0, divisions: 25,
              onChanged: (val) => vm.updateStickerScale(val),
            ),
          ),
          IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => vm.selectSticker(null)),
        ],
      ),
    );
  }

  Widget _buildRotationSlider(StickerItem sticker) {
    final int degree = (sticker.rotation * 180 / math.pi).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.deepOrange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepOrange.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.rotate_right, size: 22, color: Colors.deepOrange),
          Expanded(
            child: Slider(
              value: sticker.rotation,
              min: -math.pi,
              max: math.pi,
              divisions: 72,
              onChanged: (val) => vm.updateStickerRotation(val),
            ),
          ),
          SizedBox(
            width: 46,
            child: Text(
              '$degree°',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.auto_awesome, color: Colors.orange),
      onSelected: (val) => vm.updateMessage(val),
      itemBuilder: (context) => vm.suggestions.map((s) => PopupMenuItem(value: s, child: Text(s))).toList(),
    );
  }

  Widget _buildColorPicker() {
    final colors = [Colors.red, Colors.yellow, Colors.orange, Colors.pink, Colors.white, Colors.black, Colors.greenAccent, Colors.purpleAccent];
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          final isSelected = vm.textColor == color;
          return GestureDetector(
            onTap: () => vm.setTextColor(color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 14),
              width: isSelected ? 42 : 35,
              decoration: BoxDecoration(
                color: color, shape: BoxShape.circle,
                border: Border.all(color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3), width: isSelected ? 3 : 1),
              ),
              child: isSelected ? Icon(Icons.check, color: color == Colors.white ? Colors.black : Colors.white, size: 20) : null,
            ),
          );
        },
      ),
    );
  }
}