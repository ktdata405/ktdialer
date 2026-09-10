class PhoneFormatter {
  static String format(String number) {
    // Remove all non-digit characters except +
    return number.replaceAll(RegExp(r'[^\d+]'), '');
  }

  static String displayFormat(String number) {
    // Simple display formatting: (XXX) XXX-XXXX
    String cleaned = format(number);
    if (cleaned.length == 10) {
      return '(${cleaned.substring(0, 3)}) ${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }
    return cleaned;
  }
}
