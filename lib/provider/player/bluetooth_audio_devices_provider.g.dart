// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluetooth_audio_devices_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bluetoothAudioDevices)
final bluetoothAudioDevicesProvider = BluetoothAudioDevicesProvider._();

final class BluetoothAudioDevicesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BluetoothAudioDevice>>,
          List<BluetoothAudioDevice>,
          FutureOr<List<BluetoothAudioDevice>>
        >
    with $FutureModifier<List<BluetoothAudioDevice>>, $FutureProvider<List<BluetoothAudioDevice>> {
  BluetoothAudioDevicesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bluetoothAudioDevicesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bluetoothAudioDevicesHash();

  @$internal
  @override
  $FutureProviderElement<List<BluetoothAudioDevice>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<BluetoothAudioDevice>> create(Ref ref) {
    return bluetoothAudioDevices(ref);
  }
}

String _$bluetoothAudioDevicesHash() => r'79544a93c394588669996df46b8dbf578b768f22';
