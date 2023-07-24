String? firstNameValidation(String? value) {
  int stringlength = 1;
  if (value!.isEmpty) {
    return "First name cannot be empty!";
  } else if (value.length < stringlength) {
    return "Invalid name length!";
  }
  return null;
}

String? lastNameValidation(String? value) {
  int stringlength = 1;
  if (value!.isEmpty) {
    return "Last name cannot be empty!";
  } else if (value.length < stringlength) {
    return "Invalid name length!";
  }
  return null;
}
