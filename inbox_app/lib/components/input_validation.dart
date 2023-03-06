class CorrectPasswordInput {
  bool min8 = false;
  bool lowerCase = false;
  bool upperCase = false;
  bool number = false;
}

CorrectPasswordInput validatePassword(String? value) {
  CorrectPasswordInput correct = CorrectPasswordInput();

  if (value!.isEmpty) {
    return correct;
  }

  if (value.length >= 8) correct.min8 = true;

  if (value.contains(RegExp(r'[a-z]'))) correct.lowerCase = true;

  if (value.contains(RegExp(r'[A-Z]'))) correct.upperCase = true;

  if (value.contains(RegExp(r'[0-9]'))) correct.number = true;

  return correct;
}
