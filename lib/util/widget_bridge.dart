import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/services.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/util/logger.dart';

const String _widgetChannelName = 'de.vito0912.yaabsa/widget';
const String _newestEpisodesShelfId = 'newest-episodes';

class WidgetBridge {
  WidgetBridge._();

  static const MethodChannel _channel = MethodChannel(_widgetChannelName);

  static bool get _isAndroid => !kIsWeb && Platform.isAndroid;

  static Future<bool> publishShelfSnapshot({
    String? userId,
    String? userName,
    required String libraryId,
    String? libraryName,
    required String shelfId,
    required String shelfLabel,
    required List<Map<String, dynamic>> items,
  }) async {
    if (!_isAndroid) {
      return false;
    }

    try {
      final payload = <String, dynamic>{
        if (userId != null && userId.trim().isNotEmpty) 'userId': userId,
        if (userName != null && userName.trim().isNotEmpty) 'userName': userName,
        'libraryId': libraryId,
        if (libraryName != null && libraryName.trim().isNotEmpty) 'libraryName': libraryName,
        'shelfId': shelfId,
        'shelfLabel': shelfLabel,
        'itemsJson': jsonEncode(items),
      };

      final result = await _channel.invokeMethod<bool>('publishShelfSnapshot', payload);
      return result ?? false;
    } catch (e) {
      logger(
        'Failed to publish widget shelf snapshot ($libraryId/$shelfId): $e',
        tag: 'WidgetBridge',
        level: InfoLevel.warning,
      );
      return false;
    }
  }

  static Future<bool> publishWidgetConfig({required int appWidgetId, required Map<String, dynamic> config}) async {
    if (!_isAndroid) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('publishWidgetConfig', <String, dynamic>{
        'appWidgetId': appWidgetId,
        'config': config,
      });
      return result ?? false;
    } catch (e) {
      logger('Failed to publish widget config for $appWidgetId: $e', tag: 'WidgetBridge', level: InfoLevel.warning);
      return false;
    }
  }

  static Future<bool> publishWidgetTheme({required bool isDarkMode}) async {
    if (!_isAndroid) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('publishWidgetTheme', <String, dynamic>{
        'isDarkMode': isDarkMode,
      });
      return result ?? false;
    } catch (e) {
      logger('Failed to publish widget theme: $e', tag: 'WidgetBridge', level: InfoLevel.warning);
      return false;
    }
  }

  static Future<bool> consumePopulateAllRequest() async {
    if (!_isAndroid) {
      return false;
    }

    try {
      final result = await _channel.invokeMethod<bool>('consumePopulateAllRequest');
      return result ?? false;
    } catch (e) {
      logger('Failed to consume widget populate-all request: $e', tag: 'WidgetBridge', level: InfoLevel.warning);
      return false;
    }
  }

  static Future<void> triggerWidgetUpdate({int? appWidgetId}) async {
    if (!_isAndroid) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('triggerWidgetUpdate', <String, dynamic>{'appWidgetId': appWidgetId});
    } catch (e) {
      logger('Failed to trigger widget update: $e', tag: 'WidgetBridge', level: InfoLevel.warning);
    }
  }

  static Future<void> publishPersonalizedLibrarySnapshots({
    String? userId,
    String? userName,
    required String libraryId,
    String? libraryName,
    required PersonalizedLibrary personalizedLibrary,
    required ABSApi? api,
    int maxItemsPerShelf = 12,
    bool? isDarkMode,
  }) async {
    if (!_isAndroid) {
      return;
    }

    if (isDarkMode != null) {
      await publishWidgetTheme(isDarkMode: isDarkMode);
    }

    final snapshots = _buildShelfSnapshots(
      userId: userId,
      userName: userName,
      libraryId: libraryId,
      libraryName: libraryName,
      personalizedLibrary: personalizedLibrary,
      api: api,
      maxItemsPerShelf: maxItemsPerShelf,
    );

    for (final snapshot in snapshots) {
      await publishShelfSnapshot(
        userId: snapshot.userId,
        userName: snapshot.userName,
        libraryId: snapshot.libraryId,
        libraryName: snapshot.libraryName,
        shelfId: snapshot.shelfId,
        shelfLabel: snapshot.shelfLabel,
        items: snapshot.items,
      );
    }
  }

  static List<_WidgetShelfSnapshot> _buildShelfSnapshots({
    String? userId,
    String? userName,
    required String libraryId,
    String? libraryName,
    required PersonalizedLibrary personalizedLibrary,
    required ABSApi? api,
    int maxItemsPerShelf = 12,
  }) {
    final snapshots = <_WidgetShelfSnapshot>[];

    void addShelf(ShelfEntry<LibraryItem>? shelf) {
      if (shelf == null || shelf.entities.isEmpty) {
        return;
      }

      final items = <Map<String, dynamic>>[];
      for (final item in shelf.entities.take(maxItemsPerShelf)) {
        final coverUrl = api?.getLibraryItemApi().getCoverUri(item.id, item: item).toString();
        final coverAuthToken = api?.token;

        final itemData = <String, dynamic>{
          'id': item.id,
          'title': item.title,
          'subtitle': item.subtitle,
          'author': item.authorString,
          'mediaId': 'aa/play/item/${Uri.encodeComponent(item.id)}',
          // ignore: use_null_aware_elements
          if (coverUrl != null) 'coverUrl': coverUrl,
          // ignore: use_null_aware_elements
          if (coverAuthToken != null) 'coverAuthToken': coverAuthToken,
        };

        items.add(itemData);
      }

      if (items.isEmpty) {
        return;
      }

      snapshots.add(
        _WidgetShelfSnapshot(
          userId: userId,
          userName: userName,
          libraryId: libraryId,
          libraryName: libraryName,
          shelfId: shelf.id,
          shelfLabel: shelf.label,
          items: items,
        ),
      );
    }

    ShelfEntry<LibraryItem>? newestEpisodesAsLibraryItems;
    for (final shelf in personalizedLibrary.extraLibraryShelves) {
      if (shelf.id == _newestEpisodesShelfId) {
        newestEpisodesAsLibraryItems = shelf;
        break;
      }
    }

    addShelf(personalizedLibrary.continueListening);
    addShelf(newestEpisodesAsLibraryItems);
    addShelf(personalizedLibrary.listenAgain);
    addShelf(personalizedLibrary.continueSeries);
    addShelf(personalizedLibrary.recentlyAdded);
    addShelf(personalizedLibrary.discover);

    for (final shelf in personalizedLibrary.extraLibraryShelves) {
      if (shelf.id == _newestEpisodesShelfId) {
        continue;
      }
      addShelf(shelf);
    }

    return snapshots;
  }
}

class _WidgetShelfSnapshot {
  const _WidgetShelfSnapshot({
    required this.userId,
    required this.userName,
    required this.libraryId,
    required this.libraryName,
    required this.shelfId,
    required this.shelfLabel,
    required this.items,
  });

  final String? userId;
  final String? userName;
  final String libraryId;
  final String? libraryName;
  final String shelfId;
  final String shelfLabel;
  final List<Map<String, dynamic>> items;
}
