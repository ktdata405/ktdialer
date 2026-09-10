import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/url_launcher_helper.dart';
import '../providers/contact_provider.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: contactProvider.search,
            decoration: InputDecoration(
              hintText: AppStrings.searchContacts,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
        ),
        Expanded(
          child: contactProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : contactProvider.contacts.isEmpty
                  ? const Center(child: Text(AppStrings.noContacts))
                  : ListView.builder(
                      itemCount: contactProvider.contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contactProvider.contacts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(contact.displayName.isNotEmpty
                                ? contact.displayName[0].toUpperCase()
                                : '?'),
                          ),
                          title: Text(contact.displayName),
                          subtitle: Text(contact.phones.isNotEmpty
                              ? contact.phones.first.number
                              : ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.call, color: Colors.green),
                                onPressed: () {
                                  if (contact.phones.isNotEmpty) {
                                    UrlLauncherHelper.makeCall(
                                        contact.phones.first.number);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.message, color: Colors.blue),
                                onPressed: () {
                                  if (contact.phones.isNotEmpty) {
                                    UrlLauncherHelper.sendSMS(
                                        contact.phones.first.number);
                                  }
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // Navigate to Contact Detail Screen
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
