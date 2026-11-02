String capitalizeFirstLetter(String name) {
  // Trim the input to remove leading and trailing spaces
  name = name.trim();

  // Check if the name is empty
  if (name.isEmpty) {
    return 'UN';
  }

  List<String> nameParts = name.split(' ').where((part) => part.isNotEmpty).toList();

  // If the name has more than one part (e.g., first and last name or more)
  if (nameParts.length > 1) {
    return nameParts[0][0].toUpperCase() + nameParts.last[0].toUpperCase();
  } else {
    // If the name is a single word
    return nameParts[0][0].toUpperCase();
  }
}
