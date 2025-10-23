class UserHelpers {
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  static String formatAddressCount(int count) {
    if (count == 0) return 'Sin direcciones';
    if (count == 1) return '1 dirección';
    return '$count direcciones';
  }

  static String formatBirthDate(DateTime birthDate) {
    return '${birthDate.day.toString().padLeft(2, '0')}/${birthDate.month.toString().padLeft(2, '0')}/${birthDate.year}';
  }

  static String getInitials(String fullName) {
    final words = fullName.trim().split(' ');
    if (words.isEmpty) return 'U';

    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }

    return '${words[0].substring(0, 1)}${words[1].substring(0, 1)}'
        .toUpperCase();
  }
}
