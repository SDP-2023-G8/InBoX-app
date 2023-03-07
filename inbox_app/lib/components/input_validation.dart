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

bool isPasswordValid(String? value) {
  if (value!.isEmpty) {
    return false;
  }

  bool isCorrect = true;
  if (value.length < 8) isCorrect = false;

  if (!value.contains(RegExp(r'[a-z]'))) isCorrect = false;

  if (!value.contains(RegExp(r'[A-Z]'))) isCorrect = false;

  if (!value.contains(RegExp(r'[0-9]'))) isCorrect = false;

  return isCorrect;
}

bool isEmailValid(String? value) {
  if (value!.isEmpty) {
    return false;
  }

  if (value.contains(RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$'))) {
    return true;
  } else {
    return false;
  }
}
