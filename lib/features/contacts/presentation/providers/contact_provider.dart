import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../data/services/contact_service.dart';

class ContactProvider with ChangeNotifier {
  final ContactService _service = ContactService();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Contact> get contacts => _filteredContacts;
  bool get isLoading => _isLoading;

  Future<void> fetchContacts() async {
    _isLoading = true;
    notifyListeners();

    _contacts = await _service.getContacts();
    _filteredContacts = _contacts;
    
    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredContacts = _contacts;
    } else {
      _filteredContacts = _contacts.where((c) {
        final name = c.displayName.toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    await _service.addContact(contact);
    await fetchContacts();
  }

  Future<void> deleteContact(Contact contact) async {
    await _service.deleteContact(contact);
    await fetchContacts();
  }
}
