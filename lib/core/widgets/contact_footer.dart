import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/app_spacing.dart';
import 'package:greeting_app/core/theme/tet_colors.dart';
import 'package:greeting_app/data/domain/contact.dart';

class ContactFooter extends StatelessWidget {
  final Contact contact;
  final VoidCallback onSave;
  final VoidCallback onCall;

  const ContactFooter({
    super.key,
    required this.contact,
    required this.onSave,
    required this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          const Divider(),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(contact.name, style: textTheme.titleMedium),
            subtitle: Text(contact.phone, style: textTheme.bodySmall),
            trailing: IconButton(
              icon: const Icon(
                Icons.phone_forwarded,
                color: TetColors.statusCalled,
              ),
              onPressed: onCall,
              tooltip: "Gọi điện",
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TetColors.luckyRed,
                foregroundColor: TetColors.prosperityGoldLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onSave,
              child: const Text(
                "HOÀN THÀNH & LƯU THIỆP",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
