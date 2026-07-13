import 'dart:convert';

import 'package:flutter/services.dart';

const autoResumeMethodChannel = MethodChannel('de.vito0912.yaabsa/autoresume');

class BluetoothAudioDevice {
  const BluetoothAudioDevice({required this.address, required this.name});

  final String address;
  final String name;

  static BluetoothAudioDevice? fromPlatformMap(Map<Object?, Object?> values) {
    final rawAddress = values['address'];
    if (rawAddress is! String) {
      return null;
    }

    final address = _normalizeBluetoothAddress(rawAddress);
    if (address == null) {
      return null;
    }

    final rawName = values['name'];
    final name = rawName is String && rawName.trim().isNotEmpty ? rawName.trim() : 'Unnamed audio device';

    return BluetoothAudioDevice(address: address, name: name);
  }
}

Set<String> decodeBluetoothDeviceAddresses(String? rawValue) {
  if (rawValue == null || rawValue.trim().isEmpty) {
    return <String>{};
  }

  try {
    final decoded = jsonDecode(rawValue);
    if (decoded is! List<Object?>) {
      return <String>{};
    }

    return {for (final value in decoded) ?_normalizeBluetoothAddressValue(value)};
  } on FormatException {
    return <String>{};
  }
}

String encodeBluetoothDeviceAddresses(Iterable<String> addresses) {
  final normalized = {for (final address in addresses) ?_normalizeBluetoothAddress(address)}.toList()..sort();

  return jsonEncode(normalized);
}

String? _normalizeBluetoothAddress(String value) {
  final normalized = value.trim().toUpperCase();
  return normalized.isEmpty ? null : normalized;
}

String? _normalizeBluetoothAddressValue(Object? value) {
  return value is String ? _normalizeBluetoothAddress(value) : null;
}
