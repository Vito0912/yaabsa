import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/audio_handler/sleep_timer_completion_gate.dart';

void main() {
  group('playbackStatePlayingForSleepTimerCompletion', () {
    test('suppressed final completion is published as not playing', () {
      expect(
        playbackStatePlayingForSleepTimerCompletion(playerPlaying: true, suppressCompletedAutoAdvance: true),
        isFalse,
      );
    });

    test('ordinary playback preserves the player playing state', () {
      expect(
        playbackStatePlayingForSleepTimerCompletion(playerPlaying: true, suppressCompletedAutoAdvance: false),
        isTrue,
      );
    });

    test('paused playback remains paused without suppression', () {
      expect(
        playbackStatePlayingForSleepTimerCompletion(playerPlaying: false, suppressCompletedAutoAdvance: false),
        isFalse,
      );
    });
  });

  group('SleepTimerCompletionGateLedger', () {
    test('only the current owner can clear an armed gate', () {
      final ledger = SleepTimerCompletionGateLedger();
      final first = ledger.arm(itemId: 'book-a');
      final second = ledger.arm(itemId: 'book-a');

      expect(ledger.clear(first), isFalse);
      expect(ledger.armedToken, same(second));
      expect(ledger.clear(second), isTrue);
      expect(ledger.hasArmedGate, isFalse);
    });

    test('claim freezes the matched gate without consuming owner state', () {
      final ledger = SleepTimerCompletionGateLedger();
      final token = ledger.arm(itemId: 'book-a', episodeId: 'episode-a');

      final claim = ledger.claimWhere((itemId, episodeId) => itemId == 'book-a' && episodeId == 'episode-a');

      expect(claim, isNotNull);
      expect(claim!.token, same(token));
      expect(claim.itemId, 'book-a');
      expect(claim.episodeId, 'episode-a');
      expect(ledger.armedToken, same(token));
      expect(ledger.hasArmedGate, isTrue);
    });

    test('a stale completion can claim again until the owner clears the gate', () {
      final ledger = SleepTimerCompletionGateLedger();
      final token = ledger.arm(itemId: 'book-a', episodeId: 'episode-a');

      final firstClaim = ledger.claimWhere((itemId, episodeId) => itemId == 'book-a' && episodeId == 'episode-a');
      final secondClaim = ledger.claimWhere((itemId, episodeId) => itemId == 'book-a' && episodeId == 'episode-a');

      expect(firstClaim?.token, same(token));
      expect(secondClaim?.token, same(token));
      expect(ledger.clear(token), isTrue);
      expect(ledger.claimWhere((_, __) => true), isNull);
    });

    test('non-matching completion cannot claim the current gate', () {
      final ledger = SleepTimerCompletionGateLedger();
      final token = ledger.arm(itemId: 'book-a', episodeId: 'episode-a');

      final claim = ledger.claimWhere((itemId, episodeId) => itemId == 'book-b' && episodeId == 'episode-a');

      expect(claim, isNull);
      expect(ledger.armedToken, same(token));
    });

    test('an old claimed owner cannot clear a newer gate', () {
      final ledger = SleepTimerCompletionGateLedger();
      final first = ledger.arm(itemId: 'book-a');
      final firstClaim = ledger.claimWhere((itemId, _) => itemId == 'book-a');
      expect(firstClaim, isNotNull);

      final second = ledger.arm(itemId: 'book-a');

      expect(ledger.clear(first), isFalse);
      expect(ledger.armedToken, same(second));
      expect(firstClaim!.token, same(first));
    });
  });
}
