import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/app_spacing.dart';
import 'custom_filter_chip.dart';

class ContactFilterDrawer extends StatelessWidget {
  final int? currentStatus;
  final int? currentRelationship;
  final Function(int?) onStatusChanged;
  final Function(int?) onRelationshipChanged;
  final VoidCallback onReset;

  const ContactFilterDrawer({
    super.key,
    required this.currentStatus,
    required this.currentRelationship,
    required this.onStatusChanged,
    required this.onRelationshipChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text('Bộ lọc danh sách', style: textTheme.headlineMedium),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  Text('Trạng thái:', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      CustomFilterChip(
                        label: 'Chưa gửi',
                        selected: currentStatus == 0,
                        onSelected: (s) => onStatusChanged(s ? 0 : null),
                      ),
                      CustomFilterChip(
                        label: 'Đã gọi',
                        selected: currentStatus == 1,
                        onSelected: (s) => onStatusChanged(s ? 1 : null),
                      ),
                      CustomFilterChip(
                        label: 'Đã nhắn',
                        selected: currentStatus == 2,
                        onSelected: (s) => onStatusChanged(s ? 2 : null),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text('Mối quan hệ:', style: textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      CustomFilterChip(
                        label: 'Gia đình',
                        selected: currentRelationship == 0,
                        onSelected: (s) => onRelationshipChanged(s ? 0 : null),
                      ),
                      CustomFilterChip(
                        label: 'Sếp',
                        selected: currentRelationship == 1,
                        onSelected: (s) => onRelationshipChanged(s ? 1 : null),
                      ),
                      CustomFilterChip(
                        label: 'Bạn bè',
                        selected: currentRelationship == 2,
                        onSelected: (s) => onRelationshipChanged(s ? 2 : null),
                      ),
                      CustomFilterChip(
                        label: 'Đồng nghiệp',
                        selected: currentRelationship == 3,
                        onSelected: (s) => onRelationshipChanged(s ? 3 : null),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  onReset();
                  Navigator.pop(context);
                },
                child: const Text('Xóa tất cả bộ lọc'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
