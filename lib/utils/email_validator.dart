String? emailValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email.';
  } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
    return 'Please enter a valid email.';
  }
  return null;
}
