import 'package:flutter/material.dart';
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
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Bộ lọc danh sách',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const Text('Trạng thái:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
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
                  const SizedBox(height: 24),
                  const Text('Mối quan hệ:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      CustomFilterChip(label: 'Gia đình', selected: currentRelationship == 0, onSelected: (s) => onRelationshipChanged(s ? 0 : null)),
                      CustomFilterChip(label: 'Sếp', selected: currentRelationship == 1, onSelected: (s) => onRelationshipChanged(s ? 1 : null)),
                      CustomFilterChip(label: 'Bạn bè', selected: currentRelationship == 2, onSelected: (s) => onRelationshipChanged(s ? 2 : null)),
                      CustomFilterChip(label: 'Đồng nghiệp', selected: currentRelationship == 3, onSelected: (s) => onRelationshipChanged(s ? 3 : null)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
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