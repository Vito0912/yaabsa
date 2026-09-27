import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/media_overlay/epub_media_overlay_engine.dart';

void _addTextFile(Archive archive, String name, String content) {
  final bytes = utf8.encode(content);
  archive.addFile(ArchiveFile.noCompress(name, bytes.length, bytes));
}

Uint8List _buildFixtureEpub() {
  final archive = Archive();

  _addTextFile(archive, 'META-INF/container.xml', '''
<?xml version="1.0"?>
<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
  <rootfiles>
    <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
  </rootfiles>
</container>
''');

  _addTextFile(archive, 'OEBPS/content.opf', '''
<?xml version="1.0"?>
<package xmlns="http://www.idpf.org/2007/opf" version="3.0" unique-identifier="bookid">
  <manifest>
    <item id="ch1" href="Text/chapter1.xhtml" media-type="application/xhtml+xml" media-overlay="ch1-smil"/>
    <item id="ch1-smil" href="Text/chapter1.smil" media-type="application/smil+xml"/>
    <item id="ch2" href="Text/chapter2.xhtml" media-type="application/xhtml+xml"/>
    <item id="audio1" href="Audio/ch01.mp3" media-type="audio/mpeg"/>
  </manifest>
  <spine>
    <itemref idref="ch1"/>
    <itemref idref="ch2"/>
  </spine>
</package>
''');

  _addTextFile(archive, 'OEBPS/Text/chapter1.smil', '''
<?xml version="1.0"?>
<smil xmlns="http://www.w3.org/ns/SMIL" version="3.0">
  <body>
    <seq id="seq1" epub:textref="chapter1.xhtml">
      <par id="par1">
        <text src="chapter1.xhtml#sent1"/>
        <audio src="../Audio/ch01.mp3" clipBegin="0:00:00.000" clipEnd="0:00:03.500"/>
      </par>
      <par id="par2">
        <text src="chapter1.xhtml#sent2"/>
        <audio src="../Audio/ch01.mp3" clipBegin="00:00:03.500" clipEnd="00:00:07.250"/>
      </par>
      <par id="par3">
        <text src="chapter1.xhtml#sent3"/>
        <audio src="../Audio/ch02.mp3" clipBegin="1.2s" clipEnd="4s"/>
      </par>
    </seq>
  </body>
</smil>
''');

  return Uint8List.fromList(ZipEncoder().encode(archive));
}

/// A fixture with two narrated sections (each with its own audio file),
/// used to verify that a book-wide track list is built across the whole
/// book rather than restarting per section.
Uint8List _buildTwoSectionFixtureEpub() {
  final archive = Archive();

  _addTextFile(archive, 'META-INF/container.xml', '''
<?xml version="1.0"?>
<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
  <rootfiles>
    <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
  </rootfiles>
</container>
''');

  _addTextFile(archive, 'OEBPS/content.opf', '''
<?xml version="1.0"?>
<package xmlns="http://www.idpf.org/2007/opf" version="3.0" unique-identifier="bookid">
  <manifest>
    <item id="ch1" href="Text/chapter1.xhtml" media-type="application/xhtml+xml" media-overlay="ch1-smil"/>
    <item id="ch1-smil" href="Text/chapter1.smil" media-type="application/smil+xml"/>
    <item id="ch2" href="Text/chapter2.xhtml" media-type="application/xhtml+xml" media-overlay="ch2-smil"/>
    <item id="ch2-smil" href="Text/chapter2.smil" media-type="application/smil+xml"/>
  </manifest>
  <spine>
    <itemref idref="ch1"/>
    <itemref idref="ch2"/>
  </spine>
</package>
''');

  _addTextFile(archive, 'OEBPS/Text/chapter1.smil', '''
<?xml version="1.0"?>
<smil xmlns="http://www.w3.org/ns/SMIL" version="3.0">
  <body>
    <par id="par1">
      <text src="chapter1.xhtml#sent1"/>
      <audio src="../Audio/ch01.mp3" clipBegin="0s" clipEnd="10s"/>
    </par>
  </body>
</smil>
''');

  _addTextFile(archive, 'OEBPS/Text/chapter2.smil', '''
<?xml version="1.0"?>
<smil xmlns="http://www.w3.org/ns/SMIL" version="3.0">
  <body>
    <par id="par1">
      <text src="chapter2.xhtml#sent1"/>
      <audio src="../Audio/ch02.mp3" clipBegin="0s" clipEnd="20s"/>
    </par>
  </body>
</smil>
''');

  return Uint8List.fromList(ZipEncoder().encode(archive));
}

/// A fixture where the SAME physical audio file is shared across a chapter
/// boundary — section 1 uses the first 10s of `shared.mp4`, and section 2
/// continues with the SAME file starting from 10s onward. This is the
/// pattern that caused duration over-counting: a naive reader would treat
/// section 2's group as spanning [0, 25s) of the file (since its clips'
/// absolute end is 25s), double-counting the first 10s already played in
/// section 1.
Uint8List _buildSharedAudioAcrossSectionsFixtureEpub() {
  final archive = Archive();

  _addTextFile(archive, 'META-INF/container.xml', '''
<?xml version="1.0"?>
<container xmlns="urn:oasis:names:tc:opendocument:xmlns:container" version="1.0">
  <rootfiles>
    <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
  </rootfiles>
</container>
''');

  _addTextFile(archive, 'OEBPS/content.opf', '''
<?xml version="1.0"?>
<package xmlns="http://www.idpf.org/2007/opf" version="3.0" unique-identifier="bookid">
  <manifest>
    <item id="ch1" href="Text/chapter1.xhtml" media-type="application/xhtml+xml" media-overlay="ch1-smil"/>
    <item id="ch1-smil" href="Text/chapter1.smil" media-type="application/smil+xml"/>
    <item id="ch2" href="Text/chapter2.xhtml" media-type="application/xhtml+xml" media-overlay="ch2-smil"/>
    <item id="ch2-smil" href="Text/chapter2.smil" media-type="application/smil+xml"/>
  </manifest>
  <spine>
    <itemref idref="ch1"/>
    <itemref idref="ch2"/>
  </spine>
</package>
''');

  _addTextFile(archive, 'OEBPS/Text/chapter1.smil', '''
<?xml version="1.0"?>
<smil xmlns="http://www.w3.org/ns/SMIL" version="3.0">
  <body>
    <par id="par1">
      <text src="chapter1.xhtml#sent1"/>
      <audio src="../Audio/shared.mp4" clipBegin="0s" clipEnd="10s"/>
    </par>
  </body>
</smil>
''');

  _addTextFile(archive, 'OEBPS/Text/chapter2.smil', '''
<?xml version="1.0"?>
<smil xmlns="http://www.w3.org/ns/SMIL" version="3.0">
  <body>
    <par id="par1">
      <text src="chapter2.xhtml#sent1"/>
      <audio src="../Audio/shared.mp4" clipBegin="10s" clipEnd="25s"/>
    </par>
  </body>
</smil>
''');

  return Uint8List.fromList(ZipEncoder().encode(archive));
}

void main() {
  group('EpubMediaOverlayEngine', () {
    late EpubMediaOverlayEngine engine;

    setUp(() {
      engine = EpubMediaOverlayEngine.fromBytes(_buildFixtureEpub());
    });

    test('detects media overlays from the OPF manifest without parsing SMIL', () {
      expect(engine.hasMediaOverlays, isTrue);
    });

    test('reports the spine section count', () {
      expect(engine.sectionCount, 2);
    });

    test('returns null for a section with no media overlay', () {
      expect(engine.sectionAt(1), isNull);
    });

    test('returns null for an out-of-range section', () {
      expect(engine.sectionAt(-1), isNull);
      expect(engine.sectionAt(99), isNull);
    });

    test('parses SMIL into audio groups split on contiguous audio href', () {
      final section = engine.sectionAt(0);
      expect(section, isNotNull);
      expect(section!.smilHref, 'OEBPS/Text/chapter1.smil');
      expect(section.audioGroups, hasLength(2));

      final firstGroup = section.audioGroups[0];
      expect(firstGroup.audioHref, 'OEBPS/Audio/ch01.mp3');
      expect(firstGroup.clips, hasLength(2));
      expect(firstGroup.clips[0].textHref, 'OEBPS/Text/chapter1.xhtml#sent1');
      expect(firstGroup.clips[0].begin, 0.0);
      expect(firstGroup.clips[0].end, 3.5);
      expect(firstGroup.clips[1].begin, 3.5);
      expect(firstGroup.clips[1].end, 7.25);

      final secondGroup = section.audioGroups[1];
      expect(secondGroup.audioHref, 'OEBPS/Audio/ch02.mp3');
      expect(secondGroup.clips, hasLength(1));
      expect(secondGroup.clips[0].begin, 1.2);
      expect(secondGroup.clips[0].end, 4.0);
    });

    test('flatten() returns clips in order across audio groups', () {
      final section = engine.sectionAt(0)!;
      final flat = section.flatten();
      expect(flat, hasLength(3));
      expect(flat[0].groupIndex, 0);
      expect(flat[2].groupIndex, 1);
    });

    test('caches parsed sections', () {
      final first = engine.sectionAt(0);
      final second = engine.sectionAt(0);
      expect(identical(first, second), isTrue);
    });

    test('nextOverlaySectionFrom finds the next section with an overlay', () {
      expect(engine.nextOverlaySectionFrom(0), 0);
      expect(engine.nextOverlaySectionFrom(1), isNull);
    });

    group('sectionIndexForHref', () {
      test('matches an exact manifest-relative href', () {
        expect(engine.sectionIndexForHref('Text/chapter1.xhtml'), 0);
        expect(engine.sectionIndexForHref('Text/chapter2.xhtml'), 1);
      });

      test('ignores a fragment on the href', () {
        expect(engine.sectionIndexForHref('Text/chapter1.xhtml#top'), 0);
      });

      test('falls back to a suffix match for a differently-based href', () {
        expect(engine.sectionIndexForHref('OEBPS/Text/chapter1.xhtml'), 0);
        expect(engine.sectionIndexForHref('chapter1.xhtml'), 0);
      });

      test('returns null for an href with no matching section', () {
        expect(engine.sectionIndexForHref('Text/does-not-exist.xhtml'), isNull);
      });
    });

    test('collectBookTracks only includes the single narrated section here', () {
      final tracks = engine.collectBookTracks();
      expect(tracks, hasLength(2));
      expect(tracks.every((t) => t.sectionIndex == 0), isTrue);
    });
  });

  group('EpubMediaOverlayEngine with narration across multiple sections', () {
    late EpubMediaOverlayEngine engine;

    setUp(() {
      engine = EpubMediaOverlayEngine.fromBytes(_buildTwoSectionFixtureEpub());
    });

    test('collectBookTracks spans every narrated section in spine order', () {
      final tracks = engine.collectBookTracks();
      expect(tracks, hasLength(2));
      expect(tracks[0].sectionIndex, 0);
      expect(tracks[0].group.audioHref, 'OEBPS/Audio/ch01.mp3');
      expect(tracks[0].group.duration, 10.0);
      expect(tracks[1].sectionIndex, 1);
      expect(tracks[1].group.audioHref, 'OEBPS/Audio/ch02.mp3');
      expect(tracks[1].group.duration, 20.0);
    });

    test('total narrated duration is the sum across every section, not just one', () {
      final tracks = engine.collectBookTracks();
      final totalDuration = tracks.fold<double>(0.0, (sum, t) => sum + t.group.duration);
      expect(totalDuration, 30.0);
    });
  });

  group('EpubMediaOverlayEngine with a shared audio file spanning a chapter boundary', () {
    late EpubMediaOverlayEngine engine;

    setUp(() {
      engine = EpubMediaOverlayEngine.fromBytes(_buildSharedAudioAcrossSectionsFixtureEpub());
    });

    test('each group\'s duration is its own slice, not the file\'s absolute end', () {
      final tracks = engine.collectBookTracks();
      expect(tracks, hasLength(2));

      // Section 2's group uses clipBegin=10s/clipEnd=25s of the SAME file
      // section 1 already used [0s, 10s) of — its own slice is 15s, not the
      // file's absolute 25s end (which would double-count section 1's 10s).
      expect(tracks[0].group.duration, 10.0);
      expect(tracks[1].group.duration, 15.0);

      final totalDuration = tracks.fold<double>(0.0, (sum, t) => sum + t.group.duration);
      expect(totalDuration, 25.0, reason: 'total must equal the file\'s actual length, not 10 + 25 = 35');
    });
  });
}
