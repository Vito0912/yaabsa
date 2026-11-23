import 'dart:math';
import 'dart:typed_data';

Uint8List createPlaybackKeepAliveWave(Object? _) {
  const sampleRate = 48000;
  const sampleCount = sampleRate * 30;
  const dataSize = sampleCount * 2;
  final bytes = Uint8List(44 + dataSize);
  final data = ByteData.sublistView(bytes);

  bytes.setAll(0, 'RIFF'.codeUnits);
  data.setUint32(4, bytes.length - 8, Endian.little);
  bytes.setAll(8, 'WAVEfmt '.codeUnits);
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little);
  data.setUint16(22, 1, Endian.little);
  data.setUint32(24, sampleRate, Endian.little);
  data.setUint32(28, sampleRate * 2, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  bytes.setAll(36, 'data'.codeUnits);
  data.setUint32(40, dataSize, Endian.little);

  final random = Random(0x59414142);

  for (var index = 0; index < sampleCount; index++) {
    final sample = random.nextInt(65535) - 32767;

    data.setInt16(44 + index * 2, sample, Endian.little);
  }

  return bytes;
}
