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

int jsonIntRequiredFromDynamic(Object? value, [int defaultValue = 0]) {
  return jsonIntFromDynamic(value) ?? defaultValue;
}

double jsonDoubleRequiredFromDynamic(Object? value, [double defaultValue = 0.0]) {
  return jsonDoubleFromDynamic(value) ?? defaultValue;
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

bool jsonBoolRequiredFromDynamic(Object? value, [bool defaultValue = false]) {
  return jsonBoolFromDynamic(value) ?? defaultValue;
}

String? jsonStringFromDynamic(Object? value) {
  if (value == null) {
    return null;
  }

  if (value is String) {
    return value;
  }

  return value.toString();
}

List<String> jsonStringListFromDynamic(Object? value) {
  if (value is! List) {
    return const <String>[];
  }

  return value.map((entry) => jsonStringFromDynamic(entry)).whereType<String>().toList(growable: false);
}
