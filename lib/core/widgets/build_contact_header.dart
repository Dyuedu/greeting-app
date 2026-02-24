import 'package:flutter/material.dart';
import 'package:greeting_app/data/domain/contact.dart';
import 'package:greeting_app/core/theme/tet_colors.dart';

class ContactHeaderWidget extends StatelessWidget {
  final Contact contact;
  final VoidCallback onAskAiTap;

  const ContactHeaderWidget({
    super.key,
    required this.contact,
    required this.onAskAiTap,
  });

  @override
  Widget build(BuildContext context) {
    // Logic xác định nhãn mối quan hệ
    final relationship = switch (contact.relationshipType) {
      0 => 'Gia đình',
      1 => 'Cấp trên',
      2 => 'Bạn bè',
      3 => 'Đồng nghiệp',
      _ => 'Khác',
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar với chữ cái đầu của tên
              CircleAvatar(
                radius: 28,
                backgroundColor: TetColors.luckyRed.withOpacity(0.1),
                child: Text(
                  contact.name.isNotEmpty 
                      ? contact.name.substring(0, 1).toUpperCase() 
                      : '?',
                  style: const TextStyle(
                    color: TetColors.luckyRed,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Thông tin tên và số điện thoại
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${contact.phone} • $relationship',
                      style: TextStyle(
                        fontSize: 14, 
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Nút Ask AI tích hợp Gemini
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAskAiTap,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: TetColors.prosperityGold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(
                Icons.auto_awesome,
                color: TetColors.prosperityGold,
              ),
              label: const Text(
                'Gợi ý lời chúc bằng AI (Gemini)',
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}