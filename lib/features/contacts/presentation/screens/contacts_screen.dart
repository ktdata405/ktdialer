import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/call_service.dart';
import '../providers/contact_provider.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContactProvider>(context, listen: false).fetchContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Contacts', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search, size: 28), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, size: 28), onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              '${contactProvider.contacts.length} contacts',
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                _buildContactList(contactProvider),
                _buildAlphabetBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactList(ContactProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (provider.contacts.isEmpty) {
      return const Center(child: Text(AppStrings.noContacts, style: TextStyle(color: Colors.white60)));
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: provider.contacts.length + 2, // +2 for card and groups
      separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1, indent: 72),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildSpecialTile('K', 'My contact card', Colors.brown.shade400);
        }
        if (index == 1) {
          return _buildSpecialTile(null, 'My groups', Colors.green.shade600, icon: Icons.group);
        }
        
        final contact = provider.contacts[index - 2];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: _buildAvatar(contact),
          title: Text(
            contact.displayName,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
          ),
          subtitle: contact.phones.isNotEmpty 
              ? Text(contact.phones.first.label.toString(), style: const TextStyle(color: Colors.white38, fontSize: 14))
              : null,
          onTap: () {
            if (contact.phones.isNotEmpty) {
              CallService.placeCall(contact.phones.first.number);
            }
          },
        );
      },
    );
  }

  Widget _buildAvatar(Contact contact) {
    final bool hasImage = contact.photo != null || contact.thumbnail != null;
    return CircleAvatar(
      radius: 24,
      backgroundColor: hasImage ? Colors.transparent : Colors.blue.shade700,
      backgroundImage: hasImage ? MemoryImage(contact.thumbnail ?? contact.photo!) : null,
      child: hasImage ? null : Text(
        contact.displayName.isNotEmpty ? contact.displayName[0].toUpperCase() : '?',
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  Widget _buildSpecialTile(String? initial, String title, Color color, {IconData? icon}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: color,
        child: icon != null 
            ? Icon(icon, color: Colors.white) 
            : Text(initial!, style: const TextStyle(color: Colors.white, fontSize: 20)),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildAlphabetBar() {
    final alphabets = List.generate(26, (index) => String.fromCharCode(65 + index)) + ['#'];
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 24,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, size: 12, color: Colors.amber),
            const SizedBox(height: 4),
            ...alphabets.map((char) => Expanded(
              child: Text(
                char,
                style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
