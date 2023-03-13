String? passwordValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password.';
  } else if (value.length < 6) {
    return 'Password at least 6 characters.';
  }
  return null;
}
