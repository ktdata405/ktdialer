import 'package:flutter/material.dart';
import '../../../core/constants/strings.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final List<Map<String, String>> contacts = [
      {'name': 'John Doe', 'number': '1234567890'},
      {'name': 'Jane Smith', 'number': '0987654321'},
      {'name': 'Alice Johnson', 'number': '5556667777'},
      {'name': 'Bob Brown', 'number': '1112223333'},
      {'name': 'Charlie Davis', 'number': '4445556666'},
    ];

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(contacts[index]['name']!),
          subtitle: Text(contacts[index]['number']!),
          trailing: IconButton(
            icon: const Icon(Icons.call, color: Colors.green),
            onPressed: () {
              // Action
            },
          ),
        );
      },
    );
  }
}
