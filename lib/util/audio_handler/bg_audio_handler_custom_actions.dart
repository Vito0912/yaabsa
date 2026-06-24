part of 'bg_audio_handler.dart';

extension _BGAudioHandlerCustomActions on BGAudioHandler {
  Future<Map<String, dynamic>?> _handleCustomAction(String name, {Map<String, dynamic>? extras}) async {
    if (name == _widgetCustomActionPlayLast) {
      final started = await playLastPlayed();
      logger('Widget custom action: play last (started=$started)', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true, 'started': started};
    }

    if (name == _androidAutoCustomActionRewind) {
      _setAndroidAutoMoreMenuVisible(false);

      await rewind();
      logger('Android Auto custom action: rewind', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true};
    }

    if (name == _androidAutoCustomActionFastForward) {
      _setAndroidAutoMoreMenuVisible(false);

      await fastForward();
      logger('Android Auto custom action: fast forward', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true};
    }

    if (name == _androidAutoCustomActionSpeed) {
      _setAndroidAutoMoreMenuVisible(false);

      const steps = <double>[0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
      final currentSpeed = _player.speed;

      final currentIndex = steps.indexWhere((value) => (value - currentSpeed).abs() < 0.001);
      final nextIndex = currentIndex < 0 ? 1 : (currentIndex + 1) % steps.length;
      final nextSpeed = steps[nextIndex];

      await setSpeed(nextSpeed);
      logger('Android Auto custom action: speed changed to $nextSpeed', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true, 'speed': nextSpeed};
    }

    if (name == _androidAutoCustomActionMoreMenu) {
      _setAndroidAutoMoreMenuVisible(true, autoCloseAfter: const Duration(seconds: 4));

      logger('Android Auto more menu opened', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{
        'handled': true,
        'actions': <String>['close', 'stop'],
      };
    }

    if (name == _androidAutoCustomActionMoreClose) {
      _setAndroidAutoMoreMenuVisible(false);

      logger('Android Auto custom action: more menu closed', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true, 'action': 'close'};
    }

    if (name == _androidAutoCustomActionStop) {
      _setAndroidAutoMoreMenuVisible(false);

      await stop();
      logger('Android Auto custom action: stop invoked', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true, 'action': 'stop'};
    }

    if (name == 'custom.switch_page') {
      _cycleNotificationPage();
      logger('Media notification custom action: switch page', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true, 'action': 'switchPage'};
    }

    if (name == 'custom.skip_next') {
      await skipToNext();
      logger('Media notification custom action: skip to next', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true, 'action': 'skipToNext'};
    }

    if (name == 'custom.skip_previous') {
      await skipToPrevious();
      logger('Media notification custom action: skip to previous', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true, 'action': 'skipToPrevious'};
    }

    return null;
  }
}
