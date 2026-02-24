import 'package:flutter/material.dart';
import 'package:greeting_app/data/domain/contact.dart';

class ContactFooter extends StatelessWidget {
  final Contact contact;
  final VoidCallback onSave;
  final VoidCallback onCall;

  const ContactFooter({super.key, required this.contact, required this.onSave, required this.onCall});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Divider(),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            trailing: IconButton(
              icon: const Icon(Icons.phone_forwarded, color: Colors.green),
              onPressed: onCall,
              tooltip: "Gọi điện",
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onSave,
              child: const Text(
                "HOÀN THÀNH & LƯU THIỆP",
                style: TextStyle(
                  color: Colors.white,
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
