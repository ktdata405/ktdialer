import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/foundation.dart';

class ContactService {
  Future<List<Contact>> getContacts() async {
    if (kIsWeb) {
      // Return mock data for web as flutter_contacts has limited support
      return [
        Contact(
            name: Name(first: 'John', last: 'Doe'),
            phones: [Phone('1234567890')]),
        Contact(
            name: Name(first: 'Jane', last: 'Smith'),
            phones: [Phone('0987654321')]),
      ];
    }

    if (await FlutterContacts.requestPermission()) {
      return await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
    }
    return [];
  }

  Future<void> addContact(Contact contact) async {
    if (!kIsWeb) {
      await contact.insert();
    }
  }

  Future<void> updateContact(Contact contact) async {
    if (!kIsWeb) {
      await contact.update();
    }
  }

  Future<void> deleteContact(Contact contact) async {
    if (!kIsWeb) {
      await contact.delete();
    }
  }
}
