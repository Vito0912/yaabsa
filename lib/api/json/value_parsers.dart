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

bool? jsonBoolFromDynamic(Object? value) {
  if (value == null) {
    return null;
  }

  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) {
      return null;
    }

    if (normalized == 'true' || normalized == '1' || normalized == 'yes' || normalized == 'on') {
      return true;
    }

    if (normalized == 'false' || normalized == '0' || normalized == 'no' || normalized == 'off') {
      return false;
    }
  }

  return null;
}

bool jsonBoolRequiredFromDynamic(Object? value) {
  return jsonBoolFromDynamic(value) ?? false;
}
