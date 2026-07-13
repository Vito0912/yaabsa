import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/util/bluetooth_auto_resume.dart';

part 'bluetooth_audio_devices_provider.g.dart';

@riverpod
Future<List<BluetoothAudioDevice>> bluetoothAudioDevices(Ref ref) async {
  final rawDevices = await autoResumeMethodChannel.invokeListMethod<Map<Object?, Object?>>('getBondedAudioDevices');
  final addresses = <String>{};
  final devices = <BluetoothAudioDevice>[];

  for (final rawDevice in rawDevices ?? const <Map<Object?, Object?>>[]) {
    final device = BluetoothAudioDevice.fromPlatformMap(rawDevice);
    if (device != null && addresses.add(device.address)) {
      devices.add(device);
    }
  }

  devices.sort((first, second) {
    final byName = first.name.toLowerCase().compareTo(second.name.toLowerCase());
    return byName != 0 ? byName : first.address.compareTo(second.address);
  });
  return devices;
}
