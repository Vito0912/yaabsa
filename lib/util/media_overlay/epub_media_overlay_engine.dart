import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

import 'package:yaabsa/util/media_overlay/epub_media_overlay_models.dart';

const String _smilNamespace = 'http://www.w3.org/ns/SMIL';
const String _opfNamespace = 'http://www.idpf.org/2007/opf';
const String _containerNamespace = 'urn:oasis:names:tc:opendocument:xmlns:container';

class EpubMediaOverlayEngine {
  final Archive _archive;

  late final String _opfDir;
  late final XmlDocument _opfDoc;

  late final Map<String, String> _manifestHrefById;

  late final Map<String, String?> _manifestOverlayIdById;

  late final List<String> _spineIdRefs;

  final Map<int, MediaOverlaySection> _sectionCache = {};

  EpubMediaOverlayEngine._(this._archive) {
    final containerBytes = _readEntry('META-INF/container.xml');
    if (containerBytes == null) {
      throw StateError('Not a valid EPUB: missing META-INF/container.xml');
    }
    final containerDoc = XmlDocument.parse(utf8.decode(containerBytes));
    final rootfile = containerDoc
        .findAllElements('rootfile', namespaceUri: _containerNamespace)
        .firstOrNull;
    final opfPath = rootfile?.getAttribute('full-path');
    if (opfPath == null) {
      throw StateError('Not a valid EPUB: container.xml has no rootfile full-path');
    }

    final opfBytes = _readEntry(opfPath);
    if (opfBytes == null) {
      throw StateError('Not a valid EPUB: OPF file "$opfPath" missing from archive');
    }
    _opfDoc = XmlDocument.parse(utf8.decode(opfBytes));
    _opfDir = opfPath.contains('/') ? opfPath.substring(0, opfPath.lastIndexOf('/') + 1) : '';

    final manifest = _opfDoc.findAllElements('manifest', namespaceUri: _opfNamespace).firstOrNull;
    final hrefById = <String, String>{};
    final overlayIdById = <String, String?>{};
    if (manifest != null) {
      for (final item in manifest.findElements('item', namespaceUri: _opfNamespace)) {
        final id = item.getAttribute('id');
        final href = item.getAttribute('href');
        if (id == null || href == null) continue;
        hrefById[id] = _resolveRelative(_opfDir, href);
        overlayIdById[id] = item.getAttribute('media-overlay');
      }
    }
    _manifestHrefById = hrefById;
    _manifestOverlayIdById = overlayIdById;

    final spine = _opfDoc.findAllElements('spine', namespaceUri: _opfNamespace).firstOrNull;
    _spineIdRefs = spine == null
        ? const []
        : spine
              .findElements('itemref', namespaceUri: _opfNamespace)
              .map((e) => e.getAttribute('idref'))
              .whereType<String>()
              .toList(growable: false);
  }

  static EpubMediaOverlayEngine fromBytes(Uint8List bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);
    return EpubMediaOverlayEngine._(archive);
  }

  bool get hasMediaOverlays => _manifestOverlayIdById.values.any((v) => v != null);

  int get sectionCount => _spineIdRefs.length;

  int? sectionIndexForHref(String href) {
    final hashIndex = href.indexOf('#');
    final rawPath = hashIndex == -1 ? href : href.substring(0, hashIndex);
    final target = rawPath.startsWith('/') ? rawPath.substring(1) : rawPath;
    if (target.isEmpty) return null;

    for (var i = 0; i < _spineIdRefs.length; i++) {
      final manifestHref = _manifestHrefById[_spineIdRefs[i]];
      if (manifestHref != null && manifestHref == target) return i;
    }
    for (var i = 0; i < _spineIdRefs.length; i++) {
      final manifestHref = _manifestHrefById[_spineIdRefs[i]];
      if (manifestHref == null) continue;
      if (manifestHref.endsWith('/$target') || target.endsWith('/$manifestHref')) return i;
    }
    return null;
  }

  Uint8List? readEntryBytes(String href) => _readEntry(href);

  List<MediaOverlayBookTrack> collectBookTracks() {
    final tracks = <MediaOverlayBookTrack>[];
    for (var i = 0; i < _spineIdRefs.length; i++) {
      final section = sectionAt(i);
      if (section == null) continue;
      for (final group in section.audioGroups) {
        tracks.add(MediaOverlayBookTrack(sectionIndex: i, group: group));
      }
    }
    return tracks;
  }

  int? nextOverlaySectionFrom(int fromSectionIndex) {
    for (var i = fromSectionIndex; i < _spineIdRefs.length; i++) {
      if (sectionAt(i) != null) return i;
    }
    return null;
  }

  MediaOverlaySection? sectionAt(int sectionIndex) {
    if (sectionIndex < 0 || sectionIndex >= _spineIdRefs.length) return null;
    final cached = _sectionCache[sectionIndex];
    if (cached != null) return cached;

    final idref = _spineIdRefs[sectionIndex];
    final overlayId = _manifestOverlayIdById[idref];
    if (overlayId == null) return null;
    final smilHref = _manifestHrefById[overlayId];
    if (smilHref == null) return null;

    final smilBytes = _readEntry(smilHref);
    if (smilBytes == null) return null;

    final section = _parseSmil(sectionIndex: sectionIndex, smilHref: smilHref, smilBytes: smilBytes);
    _sectionCache[sectionIndex] = section;
    return section;
  }

  MediaOverlaySection _parseSmil({required int sectionIndex, required String smilHref, required Uint8List smilBytes}) {
    final doc = XmlDocument.parse(utf8.decode(smilBytes));
    final smilDir = smilHref.contains('/') ? smilHref.substring(0, smilHref.lastIndexOf('/') + 1) : '';

    final groups = <MediaOverlayAudioGroup>[];
    String? currentAudioHref;
    var currentClips = <MediaOverlayClip>[];

    void flush() {
      if (currentAudioHref != null && currentClips.isNotEmpty) {
        groups.add(MediaOverlayAudioGroup(audioHref: currentAudioHref, clips: List.of(currentClips)));
      }
      currentClips = [];
    }

    for (final par in doc.findAllElements('par', namespaceUri: _smilNamespace)) {
      final textEl = par.findElements('text', namespaceUri: _smilNamespace).firstOrNull;
      final audioEl = par.findElements('audio', namespaceUri: _smilNamespace).firstOrNull;
      if (textEl == null || audioEl == null) continue;

      final textSrc = textEl.getAttribute('src');
      final audioSrc = audioEl.getAttribute('src');
      if (textSrc == null || audioSrc == null) continue;

      final resolvedText = _resolveRelative(smilDir, textSrc);
      final resolvedAudio = _resolveRelative(smilDir, audioSrc);
      final begin = _parseClock(audioEl.getAttribute('clipBegin')) ?? 0.0;
      final end = _parseClock(audioEl.getAttribute('clipEnd')) ?? begin;

      if (currentAudioHref != null && currentAudioHref != resolvedAudio) {
        flush();
      }
      currentAudioHref = resolvedAudio;
      currentClips.add(MediaOverlayClip(textHref: resolvedText, begin: begin, end: end));
    }
    flush();

    return MediaOverlaySection(sectionIndex: sectionIndex, smilHref: smilHref, audioGroups: groups);
  }

  Uint8List? _readEntry(String path) {
    final normalized = path.startsWith('/') ? path.substring(1) : path;
    final file = _archive.findFile(normalized) ?? _archive.findFile(path);
    if (file == null || file.isDirectory) return null;
    return file.content;
  }

  static String _resolveRelative(String baseDir, String href) {
    final hashIndex = href.indexOf('#');
    final path = hashIndex == -1 ? href : href.substring(0, hashIndex);
    final fragment = hashIndex == -1 ? '' : href.substring(hashIndex);

    if (path.isEmpty) {
      return '$baseDir$fragment'.replaceFirst(RegExp(r'/$'), '') + fragment;
    }

    final base = Uri.file('/$baseDir', windows: false);
    final resolved = base.resolve(path);
    var resolvedPath = resolved.path;
    if (resolvedPath.startsWith('/')) resolvedPath = resolvedPath.substring(1);
    return '$resolvedPath$fragment';
  }

  static double? _parseClock(String? raw) {
    if (raw == null) return null;
    final value = raw.trim();
    if (value.isEmpty) return null;

    if (value.contains(':')) {
      final parts = value.split(':');
      try {
        if (parts.length == 3) {
          final hours = double.parse(parts[0]);
          final minutes = double.parse(parts[1]);
          final seconds = double.parse(parts[2]);
          return hours * 3600 + minutes * 60 + seconds;
        } else if (parts.length == 2) {
          final minutes = double.parse(parts[0]);
          final seconds = double.parse(parts[1]);
          return minutes * 60 + seconds;
        }
      } on FormatException {
        return null;
      }
      return null;
    }

    final match = RegExp(r'^([\d.]+)\s*(h|min|ms|s)?$').firstMatch(value);
    if (match == null) return double.tryParse(value);
    final number = double.tryParse(match.group(1)!);
    if (number == null) return null;
    switch (match.group(2)) {
      case 'h':
        return number * 3600;
      case 'min':
        return number * 60;
      case 'ms':
        return number / 1000;
      default:
        return number;
    }
  }
}
