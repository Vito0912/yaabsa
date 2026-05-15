int? jsonIntFromDynamic(Object? value) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value is String) {
    final parsedInt = int.tryParse(value);
    if (parsedInt != null) {
      return parsedInt;
    }

    final parsedDouble = double.tryParse(value);
    if (parsedDouble != null) {
      return parsedDouble.toInt();
    }
  }

  return null;
}

double? jsonDoubleFromDynamic(Object? value) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toDouble();
  }

  if (value is String) {
    final parsedDouble = double.tryParse(value);
    if (parsedDouble != null) {
      return parsedDouble;
    }

    final parsedInt = int.tryParse(value);
    if (parsedInt != null) {
      return parsedInt.toDouble();
    }
  }

  return null;
}

int jsonIntRequiredFromDynamic(Object? value) {
  return jsonIntFromDynamic(value) ?? 0;
}

double jsonDoubleRequiredFromDynamic(Object? value) {
  return jsonDoubleFromDynamic(value) ?? 0;
}
