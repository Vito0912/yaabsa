import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show mapEquals;
import 'package:flutter/material.dart';
import 'package:yaabsa/components/common/cover_zoom_view.dart';

class CoverPalette {
  const CoverPalette({required this.primary, required this.secondary});

  final Color primary;
  final Color secondary;
}

typedef CoverPaletteWidgetBuilder = Widget Function(BuildContext context, CoverPalette? palette);

class CoverPaletteBuilder extends StatefulWidget {
  const CoverPaletteBuilder({super.key, required this.coverUri, required this.requestHeaders, required this.builder});

  final Uri? coverUri;
  final Map<String, String> requestHeaders;
  final CoverPaletteWidgetBuilder builder;

  @override
  State<CoverPaletteBuilder> createState() => _CoverPaletteBuilderState();
}

class _CoverPaletteBuilderState extends State<CoverPaletteBuilder> {
  static final Map<String, CoverPalette> _cache = <String, CoverPalette>{};

  ImageStream? _stream;
  ImageStreamListener? _listener;
  CoverPalette? _palette;
  int _generation = 0;
  bool _dependenciesReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesReady) {
      return;
    }
    _dependenciesReady = true;
    _resolvePalette();
  }

  @override
  void didUpdateWidget(CoverPaletteBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coverUri != widget.coverUri || !mapEquals(oldWidget.requestHeaders, widget.requestHeaders)) {
      _resolvePalette();
    }
  }

  @override
  void dispose() {
    _detachListener();
    super.dispose();
  }

  void _resolvePalette() {
    _detachListener();
    final generation = ++_generation;
    final coverUri = widget.coverUri;
    if (coverUri == null) {
      setStateIfMounted(null);
      return;
    }

    final key = coverUri.toString();
    final cached = _cache[key];
    if (cached != null) {
      setStateIfMounted(cached);
      return;
    }

    final provider = coverImageProviderFromUri(coverUri, requestHeaders: widget.requestHeaders);
    if (provider == null) {
      setStateIfMounted(null);
      return;
    }

    final resized = ResizeImage.resizeIfNeeded(56, 56, provider);
    final stream = resized.resolve(const ImageConfiguration(size: Size.square(56)));
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, synchronousCall) async {
        final palette = await _extractPalette(info.image);
        if (generation != _generation || palette == null) {
          return;
        }
        _cache[key] = palette;
        setStateIfMounted(palette);
        stream.removeListener(listener);
      },
      onError: (error, stackTrace) {
        if (generation == _generation) {
          setStateIfMounted(null);
        }
        stream.removeListener(listener);
      },
    );
    _stream = stream;
    _listener = listener;
    stream.addListener(listener);
  }

  void _detachListener() {
    final stream = _stream;
    final listener = _listener;
    if (stream != null && listener != null) {
      stream.removeListener(listener);
    }
    _stream = null;
    _listener = null;
  }

  void setStateIfMounted(CoverPalette? palette) {
    if (!mounted || _palette == palette) {
      return;
    }
    setState(() => _palette = palette);
  }

  Future<CoverPalette?> _extractPalette(ui.Image image) async {
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (bytes == null) {
      return null;
    }

    final bins = <int, _ColorBin>{};
    var fallbackRed = 0;
    var fallbackGreen = 0;
    var fallbackBlue = 0;
    var fallbackCount = 0;
    for (var offset = 0; offset + 3 < bytes.lengthInBytes; offset += 4) {
      final alpha = bytes.getUint8(offset + 3);
      if (alpha < 180) {
        continue;
      }
      final red = bytes.getUint8(offset);
      final green = bytes.getUint8(offset + 1);
      final blue = bytes.getUint8(offset + 2);
      final hsl = HSLColor.fromColor(Color.fromARGB(255, red, green, blue));
      if (hsl.lightness >= 0.06 && hsl.lightness <= 0.94) {
        fallbackRed += red;
        fallbackGreen += green;
        fallbackBlue += blue;
        fallbackCount += 1;
      }
      if (hsl.lightness < 0.09 || hsl.lightness > 0.93 || hsl.saturation < 0.1) {
        continue;
      }

      final key = ((red >> 5) << 6) | ((green >> 5) << 3) | (blue >> 5);
      final midtoneWeight = 1 - (hsl.lightness - 0.5).abs() * 0.65;
      final weight = (0.25 + hsl.saturation * 1.75) * midtoneWeight;
      bins.putIfAbsent(key, _ColorBin.new).add(red, green, blue, weight);
    }

    if (bins.isEmpty) {
      if (fallbackCount == 0) {
        return null;
      }
      final fallback = Color.fromARGB(
        255,
        fallbackRed ~/ fallbackCount,
        fallbackGreen ~/ fallbackCount,
        fallbackBlue ~/ fallbackCount,
      );
      return CoverPalette(primary: fallback, secondary: fallback);
    }

    final ranked = bins.values.toList(growable: false)..sort((a, b) => b.score.compareTo(a.score));
    final primary = ranked.first.color;
    var secondary = primary;
    final primaryHue = HSLColor.fromColor(primary).hue;
    for (final candidate in ranked.skip(1)) {
      final hue = HSLColor.fromColor(candidate.color).hue;
      final distance = (primaryHue - hue).abs();
      if (distance > 28 && distance < 332) {
        secondary = candidate.color;
        break;
      }
    }

    if (secondary == primary) {
      secondary = HSLColor.fromColor(primary)
          .withHue((primaryHue + 34) % 360)
          .withLightness((HSLColor.fromColor(primary).lightness + 0.08).clamp(0.0, 1.0))
          .toColor();
    }
    return CoverPalette(primary: primary, secondary: secondary);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _palette);
}

class _ColorBin {
  double weight = 0;
  double red = 0;
  double green = 0;
  double blue = 0;

  double get score => weight;

  Color get color => Color.fromARGB(
    255,
    (red / weight).round().clamp(0, 255),
    (green / weight).round().clamp(0, 255),
    (blue / weight).round().clamp(0, 255),
  );

  void add(int nextRed, int nextGreen, int nextBlue, double nextWeight) {
    weight += nextWeight;
    red += nextRed * nextWeight;
    green += nextGreen * nextWeight;
    blue += nextBlue * nextWeight;
  }
}
