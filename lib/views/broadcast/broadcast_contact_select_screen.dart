import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/app_theme.dart';
import 'package:greeting_app/data/domain/contact.dart';
import 'package:greeting_app/data/repositories/contact_repository.dart';
import 'package:greeting_app/viewmodels/broadcast/broadcast_view_model.dart';
import 'package:greeting_app/views/broadcast/broadcast_preview_screen.dart';
import 'package:provider/provider.dart';

class BroadcastContactSelectScreen extends StatefulWidget {
  const BroadcastContactSelectScreen({super.key});

  @override
  State<BroadcastContactSelectScreen> createState() =>
      _BroadcastContactSelectScreenState();
}

class _BroadcastContactSelectScreenState
    extends State<BroadcastContactSelectScreen> {
  late Future<List<Contact>> _contactsFuture;

  @override
  void initState() {
    super.initState();
    _contactsFuture = context.read<ContactRepository>().getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<BroadcastViewModel>(
          builder: (_, vm, __) => Text('Đã chọn: ${vm.selectedContacts.length}'),
        ),
        flexibleSpace: AppTheme.tetAppBarBackground,
      ),
      body: FutureBuilder<List<Contact>>(
        future: _contactsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Không thể tải danh bạ: ${snapshot.error}'),
            );
          }

          final contacts = snapshot.data ?? [];
          if (contacts.isEmpty) {
            return const Center(
              child: Text('Chưa có liên hệ để gửi thiệp.'),
            );
          }

          return Consumer<BroadcastViewModel>(
            builder: (context, vm, _) => Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: contacts.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      final subtitle = _buildSubtitle(contact);

                      return CheckboxListTile(
                        value: vm.isSelected(contact),
                        title: Text(contact.name),
                        subtitle: subtitle.isEmpty ? null : Text(subtitle),
                        onChanged: (_) => vm.toggleContact(contact),
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: vm.selectedContacts.isEmpty
                            ? null
                            : () => _openPreview(),
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(
                          'Tiếp tục (${vm.selectedContacts.length})',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _buildSubtitle(Contact contact) {
    if (contact.phone.isEmpty) return '';
    return contact.phone;
  }

  Future<void> _openPreview() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const BroadcastPreviewScreen()),
    );

    if (!mounted) return;
    if (result == true) {
      Navigator.of(context).pop(true);
    }
  }
}
