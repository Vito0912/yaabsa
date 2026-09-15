import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';

void main() {
  group('UserSeekNavigationLedger', () {
    test('tracks active operations and returns stable snapshots', () {
      final ledger = UserSeekNavigationLedger();

      expect(ledger.hasActive, isFalse);
      expect(ledger.begin(1), isTrue);
      final firstSnapshot = ledger.activeSnapshot;
      expect(firstSnapshot, <int>{1});

      expect(ledger.begin(2), isTrue);
      expect(ledger.activeSnapshot, <int>{1, 2});
      expect(firstSnapshot, <int>{1});
      expect(ledger.hasActive, isTrue);
    });

    test('settlement is idempotent and only removes owned operations', () {
      final ledger = UserSeekNavigationLedger();
      expect(ledger.begin(7), isTrue);
      expect(ledger.settle(7), isTrue);
      expect(ledger.settle(7), isFalse);
      expect(ledger.settle(99), isFalse);
      expect(ledger.hasActive, isFalse);
      expect(ledger.activeSnapshot, isEmpty);
    });
  });
}
