// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Yaabsa`
  String get appName {
    return Intl.message('Yaabsa', name: 'appName', desc: '', args: []);
  }

  /// `Downloaded files: {downloadedFiles}/{totalFiles}`
  String componentsAppDownloadsDownloadListTileDownloadedFiles(Object downloadedFiles, Object totalFiles) {
    return Intl.message(
      'Downloaded files: $downloadedFiles/$totalFiles',
      name: 'componentsAppDownloadsDownloadListTileDownloadedFiles',
      desc: '',
      args: [downloadedFiles, totalFiles],
    );
  }

  /// `Warning: Download unfinished or incomplete. Not available for offline use yet.`
  String get componentsAppDownloadsDownloadListTileWarningDownloadUnfinishedOrIncompleteNot {
    return Intl.message(
      'Warning: Download unfinished or incomplete. Not available for offline use yet.',
      name: 'componentsAppDownloadsDownloadListTileWarningDownloadUnfinishedOrIncompleteNot',
      desc: '',
      args: [],
    );
  }

  /// `Delete download`
  String get componentsAppDownloadsDownloadListTileDeleteDownload {
    return Intl.message(
      'Delete download',
      name: 'componentsAppDownloadsDownloadListTileDeleteDownload',
      desc: '',
      args: [],
    );
  }

  /// `Could not load active downloads: {p1}`
  String componentsAppDownloadStatusCouldNotLoadActiveDownloads(Object p1) {
    return Intl.message(
      'Could not load active downloads: $p1',
      name: 'componentsAppDownloadStatusCouldNotLoadActiveDownloads',
      desc: '',
      args: [p1],
    );
  }

  /// `No active downloads.`
  String get componentsAppDownloadStatusNoActiveDownloads {
    return Intl.message(
      'No active downloads.',
      name: 'componentsAppDownloadStatusNoActiveDownloads',
      desc: '',
      args: [],
    );
  }

  /// `Downloads in progress`
  String get componentsAppDownloadStatusDownloadsInProgress {
    return Intl.message(
      'Downloads in progress',
      name: 'componentsAppDownloadStatusDownloadsInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Could not cancel download: {e}`
  String componentsAppDownloadStatusCouldNotCancelDownload(Object e) {
    return Intl.message(
      'Could not cancel download: $e',
      name: 'componentsAppDownloadStatusCouldNotCancelDownload',
      desc: '',
      args: [e],
    );
  }

  /// `{p1} | {p2}%`
  String componentsAppDownloadStatusText(Object p1, Object p2) {
    return Intl.message('$p1 | $p2%', name: 'componentsAppDownloadStatusText', desc: '', args: [p1, p2]);
  }

  /// `Download Error`
  String get componentsAppDownloadStatusDownloadError {
    return Intl.message('Download Error', name: 'componentsAppDownloadStatusDownloadError', desc: '', args: []);
  }

  /// `Error: {error}`
  String componentsAppDownloadStatusError(Object error) {
    return Intl.message('Error: $error', name: 'componentsAppDownloadStatusError', desc: '', args: [error]);
  }

  /// `OK`
  String get componentsAppDownloadStatusOk {
    return Intl.message('OK', name: 'componentsAppDownloadStatusOk', desc: '', args: []);
  }

  /// `Cancel download`
  String get componentsAppDownloadStatusCancelDownload {
    return Intl.message('Cancel download', name: 'componentsAppDownloadStatusCancelDownload', desc: '', args: []);
  }

  /// `No changes to save.`
  String get componentsAppItemEditorLibraryItemEditorFormNoChangesToSave {
    return Intl.message(
      'No changes to save.',
      name: 'componentsAppItemEditorLibraryItemEditorFormNoChangesToSave',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get componentsAppItemEditorLibraryItemEditorFormClose {
    return Intl.message('Close', name: 'componentsAppItemEditorLibraryItemEditorFormClose', desc: '', args: []);
  }

  /// `Metadata`
  String get componentsAppItemEditorLibraryItemEditorFormMetadata {
    return Intl.message('Metadata', name: 'componentsAppItemEditorLibraryItemEditorFormMetadata', desc: '', args: []);
  }

  /// `Description`
  String get componentsAppItemEditorLibraryItemEditorFormDescription {
    return Intl.message(
      'Description',
      name: 'componentsAppItemEditorLibraryItemEditorFormDescription',
      desc: '',
      args: [],
    );
  }

  /// `YYYY-MM-DD`
  String get componentsAppItemEditorLibraryItemEditorFormYyyyMMDD {
    return Intl.message('YYYY-MM-DD', name: 'componentsAppItemEditorLibraryItemEditorFormYyyyMMDD', desc: '', args: []);
  }

  /// `episodic or serial`
  String get componentsAppItemEditorLibraryItemEditorFormEpisodicOrSerial {
    return Intl.message(
      'episodic or serial',
      name: 'componentsAppItemEditorLibraryItemEditorFormEpisodicOrSerial',
      desc: '',
      args: [],
    );
  }

  /// `Series number`
  String get componentsAppItemEditorLibraryItemEditorInputsSeriesNumber {
    return Intl.message(
      'Series number',
      name: 'componentsAppItemEditorLibraryItemEditorInputsSeriesNumber',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get componentsAppItemEditorLibraryItemEditorInputsSkip {
    return Intl.message('Skip', name: 'componentsAppItemEditorLibraryItemEditorInputsSkip', desc: '', args: []);
  }

  /// `Save`
  String get componentsAppItemEditorLibraryItemEditorInputsSave {
    return Intl.message('Save', name: 'componentsAppItemEditorLibraryItemEditorInputsSave', desc: '', args: []);
  }

  /// `Could not open the series sequence prompt. Please try again.`
  String get componentsAppItemEditorLibraryItemEditorInputsCouldNotOpenTheSeriesSequence {
    return Intl.message(
      'Could not open the series sequence prompt. Please try again.',
      name: 'componentsAppItemEditorLibraryItemEditorInputsCouldNotOpenTheSeriesSequence',
      desc: '',
      args: [],
    );
  }

  /// `Series`
  String get componentsAppItemEditorLibraryItemEditorInputsSeries {
    return Intl.message('Series', name: 'componentsAppItemEditorLibraryItemEditorInputsSeries', desc: '', args: []);
  }

  /// `Sequence`
  String get componentsAppItemEditorLibraryItemEditorInputsSequence {
    return Intl.message('Sequence', name: 'componentsAppItemEditorLibraryItemEditorInputsSequence', desc: '', args: []);
  }

  /// `e.g. 1,2.5,03 (no spaces)`
  String get componentsAppItemEditorLibraryItemEditorInputsEG12503 {
    return Intl.message(
      'e.g. 1,2.5,03 (no spaces)',
      name: 'componentsAppItemEditorLibraryItemEditorInputsEG12503',
      desc: '',
      args: [],
    );
  }

  /// `Add series`
  String get componentsAppItemEditorLibraryItemEditorInputsAddSeries {
    return Intl.message(
      'Add series',
      name: 'componentsAppItemEditorLibraryItemEditorInputsAddSeries',
      desc: '',
      args: [],
    );
  }

  /// `No server connection available.`
  String get componentsAppItemEditorLibraryItemEditOverlayNoServerConnectionAvailable {
    return Intl.message(
      'No server connection available.',
      name: 'componentsAppItemEditorLibraryItemEditOverlayNoServerConnectionAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Saved item details.`
  String get componentsAppItemEditorLibraryItemEditOverlaySavedItemDetails {
    return Intl.message(
      'Saved item details.',
      name: 'componentsAppItemEditorLibraryItemEditOverlaySavedItemDetails',
      desc: '',
      args: [],
    );
  }

  /// `Could not load item details for editing.\n{error}`
  String componentsAppItemEditorLibraryItemEditOverlayCouldNotLoadItemDetailsFor(Object error) {
    return Intl.message(
      'Could not load item details for editing.\n$error',
      name: 'componentsAppItemEditorLibraryItemEditOverlayCouldNotLoadItemDetailsFor',
      desc: '',
      args: [error],
    );
  }

  /// `Edit item`
  String get componentsAppItemEditorLibraryItemEditOverlayEditItem {
    return Intl.message('Edit item', name: 'componentsAppItemEditorLibraryItemEditOverlayEditItem', desc: '', args: []);
  }

  /// `Previous item`
  String get componentsAppItemEditorLibraryItemEditOverlayPreviousItem {
    return Intl.message(
      'Previous item',
      name: 'componentsAppItemEditorLibraryItemEditOverlayPreviousItem',
      desc: '',
      args: [],
    );
  }

  /// `Next item`
  String get componentsAppItemEditorLibraryItemEditOverlayNextItem {
    return Intl.message('Next item', name: 'componentsAppItemEditorLibraryItemEditOverlayNextItem', desc: '', args: []);
  }

  /// `Close editor`
  String get componentsAppItemEditorLibraryItemEditOverlayCloseEditor {
    return Intl.message(
      'Close editor',
      name: 'componentsAppItemEditorLibraryItemEditOverlayCloseEditor',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get componentsAppItemEditorLibraryItemEditOverlayTabDetails {
    return Intl.message('Details', name: 'componentsAppItemEditorLibraryItemEditOverlayTabDetails', desc: '', args: []);
  }

  /// `Embedding`
  String get componentsAppItemEditorLibraryItemEditOverlayTabEmbedding {
    return Intl.message(
      'Embedding',
      name: 'componentsAppItemEditorLibraryItemEditOverlayTabEmbedding',
      desc: '',
      args: [],
    );
  }

  /// `Encoder`
  String get componentsAppItemEditorLibraryItemEditOverlayTabEncoder {
    return Intl.message('Encoder', name: 'componentsAppItemEditorLibraryItemEditOverlayTabEncoder', desc: '', args: []);
  }

  /// `Failed to load metadata object: {error}`
  String componentsAppItemEditorLibraryItemEditOverlayFailedToLoadMetadataObject(Object error) {
    return Intl.message(
      'Failed to load metadata object: $error',
      name: 'componentsAppItemEditorLibraryItemEditOverlayFailedToLoadMetadataObject',
      desc: '',
      args: [error],
    );
  }

  /// `Failed to start embedding: {error}`
  String componentsAppItemEditorLibraryItemEditOverlayFailedToStartEmbedding(Object error) {
    return Intl.message(
      'Failed to start embedding: $error',
      name: 'componentsAppItemEditorLibraryItemEditOverlayFailedToStartEmbedding',
      desc: '',
      args: [error],
    );
  }

  /// `Failed to start M4B encoding: {error}`
  String componentsAppItemEditorLibraryItemEditOverlayFailedToStartM4bEncoding(Object error) {
    return Intl.message(
      'Failed to start M4B encoding: $error',
      name: 'componentsAppItemEditorLibraryItemEditOverlayFailedToStartM4bEncoding',
      desc: '',
      args: [error],
    );
  }

  /// `Failed to cancel encoding: {error}`
  String componentsAppItemEditorLibraryItemEditOverlayFailedToCancelEncoding(Object error) {
    return Intl.message(
      'Failed to cancel encoding: $error',
      name: 'componentsAppItemEditorLibraryItemEditOverlayFailedToCancelEncoding',
      desc: '',
      args: [error],
    );
  }

  /// `Request failed ({statusCode}).`
  String componentsAppItemEditorLibraryItemEditOverlayRequestFailed(Object statusCode) {
    return Intl.message(
      'Request failed ($statusCode).',
      name: 'componentsAppItemEditorLibraryItemEditOverlayRequestFailed',
      desc: '',
      args: [statusCode],
    );
  }

  /// `Update request failed.`
  String get componentsAppItemEditorLibraryItemEditOverlayUpdateRequestFailed {
    return Intl.message(
      'Update request failed.',
      name: 'componentsAppItemEditorLibraryItemEditOverlayUpdateRequestFailed',
      desc: '',
      args: [],
    );
  }

  /// `Could not save item details.`
  String get componentsAppItemEditorLibraryItemEditOverlayCouldNotSaveItemDetails {
    return Intl.message(
      'Could not save item details.',
      name: 'componentsAppItemEditorLibraryItemEditOverlayCouldNotSaveItemDetails',
      desc: '',
      args: [],
    );
  }

  /// `Embedding task failed.`
  String get componentsAppItemEditorLibraryItemEditOverlayEmbeddingTaskFailed {
    return Intl.message(
      'Embedding task failed.',
      name: 'componentsAppItemEditorLibraryItemEditOverlayEmbeddingTaskFailed',
      desc: '',
      args: [],
    );
  }

  /// `M4B encoding task failed.`
  String get componentsAppItemEditorLibraryItemEditOverlayM4bEncodingTaskFailed {
    return Intl.message(
      'M4B encoding task failed.',
      name: 'componentsAppItemEditorLibraryItemEditOverlayM4bEncodingTaskFailed',
      desc: '',
      args: [],
    );
  }

  /// `No audio tracks are available for metadata embedding.`
  String get componentsAppItemEditorLibraryItemEmbeddingViewNoAudioTracksAreAvailableFor {
    return Intl.message(
      'No audio tracks are available for metadata embedding.',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewNoAudioTracksAreAvailableFor',
      desc: '',
      args: [],
    );
  }

  /// `Embedding`
  String get componentsAppItemEditorLibraryItemEmbeddingViewEmbedding {
    return Intl.message(
      'Embedding',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewEmbedding',
      desc: '',
      args: [],
    );
  }

  /// `Backup audio files before embedding`
  String get componentsAppItemEditorLibraryItemEmbeddingViewBackupAudioFilesBeforeEmbedding {
    return Intl.message(
      'Backup audio files before embedding',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewBackupAudioFilesBeforeEmbedding',
      desc: '',
      args: [],
    );
  }

  /// `Force chapter embedding`
  String get componentsAppItemEditorLibraryItemEmbeddingViewForceChapterEmbedding {
    return Intl.message(
      'Force chapter embedding',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewForceChapterEmbedding',
      desc: '',
      args: [],
    );
  }

  /// `Forces chapter markers to be rewritten in the output files, even when chapters already exist.`
  String get componentsAppItemEditorLibraryItemEmbeddingViewForcesChapterMarkersToBeRewritten {
    return Intl.message(
      'Forces chapter markers to be rewritten in the output files, even when chapters already exist.',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewForcesChapterMarkersToBeRewritten',
      desc: '',
      args: [],
    );
  }

  /// `Refresh Metadata`
  String get componentsAppItemEditorLibraryItemEmbeddingViewRefreshMetadata {
    return Intl.message(
      'Refresh Metadata',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewRefreshMetadata',
      desc: '',
      args: [],
    );
  }

  /// `No metadata object returned by the server.`
  String get componentsAppItemEditorLibraryItemEmbeddingViewNoMetadataObjectReturnedByThe {
    return Intl.message(
      'No metadata object returned by the server.',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewNoMetadataObjectReturnedByThe',
      desc: '',
      args: [],
    );
  }

  /// `No chapters available.`
  String get componentsAppItemEditorLibraryItemEmbeddingViewNoChaptersAvailable {
    return Intl.message(
      'No chapters available.',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewNoChaptersAvailable',
      desc: '',
      args: [],
    );
  }

  /// `→`
  String get componentsAppItemEditorLibraryItemEmbeddingViewText {
    return Intl.message('→', name: 'componentsAppItemEditorLibraryItemEmbeddingViewText', desc: '', args: []);
  }

  /// `No audio tracks are available for M4B encoding.`
  String get componentsAppItemEditorLibraryItemEncoderViewNoAudioTracksAreAvailableFor {
    return Intl.message(
      'No audio tracks are available for M4B encoding.',
      name: 'componentsAppItemEditorLibraryItemEncoderViewNoAudioTracksAreAvailableFor',
      desc: '',
      args: [],
    );
  }

  /// `M4B Encoder`
  String get componentsAppItemEditorLibraryItemEncoderViewM4bEncoder {
    return Intl.message(
      'M4B Encoder',
      name: 'componentsAppItemEditorLibraryItemEncoderViewM4bEncoder',
      desc: '',
      args: [],
    );
  }

  /// `Progress: {p1}`
  String componentsAppItemEditorLibraryItemEncoderViewProgress(Object p1) {
    return Intl.message(
      'Progress: $p1',
      name: 'componentsAppItemEditorLibraryItemEncoderViewProgress',
      desc: '',
      args: [p1],
    );
  }

  /// `Presets`
  String get componentsAppItemEditorLibraryItemEncoderViewPresets {
    return Intl.message('Presets', name: 'componentsAppItemEditorLibraryItemEncoderViewPresets', desc: '', args: []);
  }

  /// `Advanced`
  String get componentsAppItemEditorLibraryItemEncoderViewAdvanced {
    return Intl.message('Advanced', name: 'componentsAppItemEditorLibraryItemEncoderViewAdvanced', desc: '', args: []);
  }

  /// `Audio Tracks`
  String get componentsAppItemEditorLibraryItemEncoderViewAudioTracks {
    return Intl.message(
      'Audio Tracks',
      name: 'componentsAppItemEditorLibraryItemEncoderViewAudioTracks',
      desc: '',
      args: [],
    );
  }

  /// `{p1}.`
  String componentsAppItemEditorLibraryItemEncoderViewText(Object p1) {
    return Intl.message('$p1.', name: 'componentsAppItemEditorLibraryItemEncoderViewText', desc: '', args: [p1]);
  }

  /// `Codec`
  String get componentsAppItemEditorLibraryItemEncoderViewCodec {
    return Intl.message('Codec', name: 'componentsAppItemEditorLibraryItemEncoderViewCodec', desc: '', args: []);
  }

  /// `Bitrate`
  String get componentsAppItemEditorLibraryItemEncoderViewBitrate {
    return Intl.message('Bitrate', name: 'componentsAppItemEditorLibraryItemEncoderViewBitrate', desc: '', args: []);
  }

  /// `Channels`
  String get componentsAppItemEditorLibraryItemEncoderViewChannels {
    return Intl.message('Channels', name: 'componentsAppItemEditorLibraryItemEncoderViewChannels', desc: '', args: []);
  }

  /// `Submitting...`
  String get componentsAppItemEditorLibraryItemEncoderViewSubmitting {
    return Intl.message(
      'Submitting...',
      name: 'componentsAppItemEditorLibraryItemEncoderViewSubmitting',
      desc: '',
      args: [],
    );
  }

  /// `Running...`
  String get componentsAppItemEditorLibraryItemEncoderViewRunning {
    return Intl.message('Running...', name: 'componentsAppItemEditorLibraryItemEncoderViewRunning', desc: '', args: []);
  }

  /// `Start Encode`
  String get componentsAppItemEditorLibraryItemEncoderViewStartEncode {
    return Intl.message(
      'Start Encode',
      name: 'componentsAppItemEditorLibraryItemEncoderViewStartEncode',
      desc: '',
      args: [],
    );
  }

  /// `Canceling...`
  String get componentsAppItemEditorLibraryItemEncoderViewCanceling {
    return Intl.message(
      'Canceling...',
      name: 'componentsAppItemEditorLibraryItemEncoderViewCanceling',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get componentsAppItemEditorLibraryItemEncoderViewCancel {
    return Intl.message('Cancel', name: 'componentsAppItemEditorLibraryItemEncoderViewCancel', desc: '', args: []);
  }

  /// `unknown codec`
  String get componentsAppItemEditorLibraryItemEncoderViewUnknownCodec {
    return Intl.message(
      'unknown codec',
      name: 'componentsAppItemEditorLibraryItemEncoderViewUnknownCodec',
      desc: '',
      args: [],
    );
  }

  /// `unknown bitrate`
  String get componentsAppItemEditorLibraryItemEncoderViewUnknownBitrate {
    return Intl.message(
      'unknown bitrate',
      name: 'componentsAppItemEditorLibraryItemEncoderViewUnknownBitrate',
      desc: '',
      args: [],
    );
  }

  /// `unknown channels`
  String get componentsAppItemEditorLibraryItemEncoderViewUnknownChannels {
    return Intl.message(
      'unknown channels',
      name: 'componentsAppItemEditorLibraryItemEncoderViewUnknownChannels',
      desc: '',
      args: [],
    );
  }

  /// `unknown duration`
  String get componentsAppItemEditorLibraryItemEncoderViewUnknownDuration {
    return Intl.message(
      'unknown duration',
      name: 'componentsAppItemEditorLibraryItemEncoderViewUnknownDuration',
      desc: '',
      args: [],
    );
  }

  /// `{value}k`
  String componentsAppItemEditorLibraryItemEncoderViewBitrateKbps(Object value) {
    return Intl.message(
      '${value}k',
      name: 'componentsAppItemEditorLibraryItemEncoderViewBitrateKbps',
      desc: '',
      args: [value],
    );
  }

  /// `{value}ch`
  String componentsAppItemEditorLibraryItemEncoderViewChannelsShort(Object value) {
    return Intl.message(
      '${value}ch',
      name: 'componentsAppItemEditorLibraryItemEncoderViewChannelsShort',
      desc: '',
      args: [value],
    );
  }

  /// `{codec} • {bitrate} • {channels} • {duration} • {size}`
  String componentsAppItemEditorLibraryItemEncoderViewTrackMetaLine(
    Object bitrate,
    Object channels,
    Object codec,
    Object duration,
    Object size,
  ) {
    return Intl.message(
      '$codec • $bitrate • $channels • $duration • $size',
      name: 'componentsAppItemEditorLibraryItemEncoderViewTrackMetaLine',
      desc: '',
      args: [bitrate, channels, codec, duration, size],
    );
  }

  /// `Only audiobooks can be deleted from this action.`
  String get componentsAppItemItemDeleteActionsOnlyAudiobooksCanBeDeletedFrom {
    return Intl.message(
      'Only audiobooks can be deleted from this action.',
      name: 'componentsAppItemItemDeleteActionsOnlyAudiobooksCanBeDeletedFrom',
      desc: '',
      args: [],
    );
  }

  /// `No selected audiobooks can be deleted. Select audiobook items and try again.`
  String get componentsAppItemItemDeleteActionsNoSelectedAudiobooksCanBeDeleted {
    return Intl.message(
      'No selected audiobooks can be deleted. Select audiobook items and try again.',
      name: 'componentsAppItemItemDeleteActionsNoSelectedAudiobooksCanBeDeleted',
      desc: '',
      args: [],
    );
  }

  /// `DESCRIPTION`
  String get componentsAppItemItemDescriptionDescription {
    return Intl.message('DESCRIPTION', name: 'componentsAppItemItemDescriptionDescription', desc: '', args: []);
  }

  /// `Show less`
  String get componentsAppItemItemDescriptionShowLess {
    return Intl.message('Show less', name: 'componentsAppItemItemDescriptionShowLess', desc: '', args: []);
  }

  /// `Show more`
  String get componentsAppItemItemDescriptionShowMore {
    return Intl.message('Show more', name: 'componentsAppItemItemDescriptionShowMore', desc: '', args: []);
  }

  /// `Book details`
  String get componentsAppItemItemDetailComponentsBookDetails {
    return Intl.message('Book details', name: 'componentsAppItemItemDetailComponentsBookDetails', desc: '', args: []);
  }

  /// `, `
  String get componentsAppItemItemDetailComponentsText {
    return Intl.message(', ', name: 'componentsAppItemItemDetailComponentsText', desc: '', args: []);
  }

  /// `Back`
  String get componentsAppItemItemDetailComponentsBack {
    return Intl.message('Back', name: 'componentsAppItemItemDetailComponentsBack', desc: '', args: []);
  }

  /// `Edit item`
  String get componentsAppItemItemMoreActionsButtonEditItem {
    return Intl.message('Edit item', name: 'componentsAppItemItemMoreActionsButtonEditItem', desc: '', args: []);
  }

  /// `Quick Match`
  String get componentsAppItemItemMoreActionsButtonQuickMatch {
    return Intl.message('Quick Match', name: 'componentsAppItemItemMoreActionsButtonQuickMatch', desc: '', args: []);
  }

  /// `Manual Match`
  String get componentsAppItemItemMoreActionsButtonManualMatch {
    return Intl.message('Manual Match', name: 'componentsAppItemItemMoreActionsButtonManualMatch', desc: '', args: []);
  }

  /// `Add To Playlist`
  String get componentsAppItemItemMoreActionsButtonAddToPlaylist {
    return Intl.message(
      'Add To Playlist',
      name: 'componentsAppItemItemMoreActionsButtonAddToPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Add To Collection`
  String get componentsAppItemItemMoreActionsButtonAddToCollection {
    return Intl.message(
      'Add To Collection',
      name: 'componentsAppItemItemMoreActionsButtonAddToCollection',
      desc: '',
      args: [],
    );
  }

  /// `Delete Audiobook`
  String get componentsAppItemItemMoreActionsButtonDeleteAudiobook {
    return Intl.message(
      'Delete Audiobook',
      name: 'componentsAppItemItemMoreActionsButtonDeleteAudiobook',
      desc: '',
      args: [],
    );
  }

  /// `Play History`
  String get componentsAppItemItemMoreActionsButtonPlayHistory {
    return Intl.message('Play History', name: 'componentsAppItemItemMoreActionsButtonPlayHistory', desc: '', args: []);
  }

  /// `Mark As Unfinished`
  String get componentsAppItemItemMoreActionsButtonMarkAsUnfinished {
    return Intl.message(
      'Mark As Unfinished',
      name: 'componentsAppItemItemMoreActionsButtonMarkAsUnfinished',
      desc: '',
      args: [],
    );
  }

  /// `Mark As Finished`
  String get componentsAppItemItemMoreActionsButtonMarkAsFinished {
    return Intl.message(
      'Mark As Finished',
      name: 'componentsAppItemItemMoreActionsButtonMarkAsFinished',
      desc: '',
      args: [],
    );
  }

  /// `More actions`
  String get componentsAppItemItemMoreActionsButtonMoreActions {
    return Intl.message('More actions', name: 'componentsAppItemItemMoreActionsButtonMoreActions', desc: '', args: []);
  }

  /// `Progress updates are currently available for books only.`
  String get componentsAppItemItemProgressActionsProgressUpdatesAreCurrentlyAvailableFor {
    return Intl.message(
      'Progress updates are currently available for books only.',
      name: 'componentsAppItemItemProgressActionsProgressUpdatesAreCurrentlyAvailableFor',
      desc: '',
      args: [],
    );
  }

  /// `Progress updates are currently available for podcast episodes only.`
  String get componentsAppItemItemProgressActionsProgressUpdatesAreCurrentlyAvailableFor2 {
    return Intl.message(
      'Progress updates are currently available for podcast episodes only.',
      name: 'componentsAppItemItemProgressActionsProgressUpdatesAreCurrentlyAvailableFor2',
      desc: '',
      args: [],
    );
  }

  /// `No selected books can be updated.`
  String get componentsAppItemItemProgressActionsNoSelectedBooksCanBeUpdated {
    return Intl.message(
      'No selected books can be updated.',
      name: 'componentsAppItemItemProgressActionsNoSelectedBooksCanBeUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Read`
  String get componentsAppItemLibraryItemViewComponentsRead {
    return Intl.message('Read', name: 'componentsAppItemLibraryItemViewComponentsRead', desc: '', args: []);
  }

  /// `Chapter`
  String get componentsAppItemLibraryItemViewComponentsChapter {
    return Intl.message('Chapter', name: 'componentsAppItemLibraryItemViewComponentsChapter', desc: '', args: []);
  }

  /// `Start`
  String get componentsAppItemLibraryItemViewComponentsStart {
    return Intl.message('Start', name: 'componentsAppItemLibraryItemViewComponentsStart', desc: '', args: []);
  }

  /// `Length`
  String get componentsAppItemLibraryItemViewComponentsLength {
    return Intl.message('Length', name: 'componentsAppItemLibraryItemViewComponentsLength', desc: '', args: []);
  }

  /// `Series`
  String get componentsAppItemLibraryItemViewComponentsSeries {
    return Intl.message('Series', name: 'componentsAppItemLibraryItemViewComponentsSeries', desc: '', args: []);
  }

  /// `Authors`
  String get componentsAppItemLibraryItemViewComponentsAuthors {
    return Intl.message('Authors', name: 'componentsAppItemLibraryItemViewComponentsAuthors', desc: '', args: []);
  }

  /// `Narrators`
  String get componentsAppItemLibraryItemViewComponentsNarrators {
    return Intl.message('Narrators', name: 'componentsAppItemLibraryItemViewComponentsNarrators', desc: '', args: []);
  }

  /// `Published year`
  String get componentsAppItemLibraryItemViewComponentsPublishedYear {
    return Intl.message(
      'Published year',
      name: 'componentsAppItemLibraryItemViewComponentsPublishedYear',
      desc: '',
      args: [],
    );
  }

  /// `Publisher`
  String get componentsAppItemLibraryItemViewComponentsPublisher {
    return Intl.message('Publisher', name: 'componentsAppItemLibraryItemViewComponentsPublisher', desc: '', args: []);
  }

  /// `Genres`
  String get componentsAppItemLibraryItemViewComponentsGenres {
    return Intl.message('Genres', name: 'componentsAppItemLibraryItemViewComponentsGenres', desc: '', args: []);
  }

  /// `Tags`
  String get componentsAppItemLibraryItemViewComponentsTags {
    return Intl.message('Tags', name: 'componentsAppItemLibraryItemViewComponentsTags', desc: '', args: []);
  }

  /// `Language`
  String get componentsAppItemLibraryItemViewComponentsLanguage {
    return Intl.message('Language', name: 'componentsAppItemLibraryItemViewComponentsLanguage', desc: '', args: []);
  }

  /// `Duration`
  String get componentsAppItemLibraryItemViewComponentsDuration {
    return Intl.message('Duration', name: 'componentsAppItemLibraryItemViewComponentsDuration', desc: '', args: []);
  }

  /// `Size`
  String get componentsAppItemLibraryItemViewComponentsSize {
    return Intl.message('Size', name: 'componentsAppItemLibraryItemViewComponentsSize', desc: '', args: []);
  }

  /// `Loading`
  String get componentsAppItemLibraryItemViewComponentsLoading {
    return Intl.message('Loading', name: 'componentsAppItemLibraryItemViewComponentsLoading', desc: '', args: []);
  }

  /// `Pause`
  String get componentsAppItemLibraryItemViewComponentsPause {
    return Intl.message('Pause', name: 'componentsAppItemLibraryItemViewComponentsPause', desc: '', args: []);
  }

  /// `Resume`
  String get componentsAppItemLibraryItemViewComponentsResume {
    return Intl.message('Resume', name: 'componentsAppItemLibraryItemViewComponentsResume', desc: '', args: []);
  }

  /// `Play`
  String get componentsAppItemLibraryItemViewComponentsPlay {
    return Intl.message('Play', name: 'componentsAppItemLibraryItemViewComponentsPlay', desc: '', args: []);
  }

  /// `Downloading`
  String get componentsAppItemLibraryItemViewComponentsDownloading {
    return Intl.message(
      'Downloading',
      name: 'componentsAppItemLibraryItemViewComponentsDownloading',
      desc: '',
      args: [],
    );
  }

  /// `Delete download`
  String get componentsAppItemLibraryItemViewComponentsDeleteDownload {
    return Intl.message(
      'Delete download',
      name: 'componentsAppItemLibraryItemViewComponentsDeleteDownload',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get componentsAppItemLibraryItemViewComponentsDownload {
    return Intl.message('Download', name: 'componentsAppItemLibraryItemViewComponentsDownload', desc: '', args: []);
  }

  /// `Remove from queue`
  String get componentsAppItemLibraryItemViewComponentsRemoveFromQueue {
    return Intl.message(
      'Remove from queue',
      name: 'componentsAppItemLibraryItemViewComponentsRemoveFromQueue',
      desc: '',
      args: [],
    );
  }

  /// `Add to queue`
  String get componentsAppItemLibraryItemViewComponentsAddToQueue {
    return Intl.message(
      'Add to queue',
      name: 'componentsAppItemLibraryItemViewComponentsAddToQueue',
      desc: '',
      args: [],
    );
  }

  /// `Currently playing`
  String get componentsAppItemLibraryItemViewComponentsCurrentlyPlaying {
    return Intl.message(
      'Currently playing',
      name: 'componentsAppItemLibraryItemViewComponentsCurrentlyPlaying',
      desc: '',
      args: [],
    );
  }

  /// `Chapters ({count})`
  String componentsAppItemLibraryItemViewComponentsChaptersCount(Object count) {
    return Intl.message(
      'Chapters ($count)',
      name: 'componentsAppItemLibraryItemViewComponentsChaptersCount',
      desc: '',
      args: [count],
    );
  }

  /// `Audio files ({count})`
  String componentsAppItemLibraryItemViewComponentsAudioFilesCount(Object count) {
    return Intl.message(
      'Audio files ($count)',
      name: 'componentsAppItemLibraryItemViewComponentsAudioFilesCount',
      desc: '',
      args: [count],
    );
  }

  /// `Ebook files`
  String get componentsAppItemLibraryItemViewComponentsEbookFiles {
    return Intl.message(
      'Ebook files',
      name: 'componentsAppItemLibraryItemViewComponentsEbookFiles',
      desc: '',
      args: [],
    );
  }

  /// `No API session available.`
  String get componentsAppItemMatchLibraryItemQuickMatchActionsNoAPISessionAvailable {
    return Intl.message(
      'No API session available.',
      name: 'componentsAppItemMatchLibraryItemQuickMatchActionsNoAPISessionAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Could not run quick match: {error}`
  String componentsAppItemMatchLibraryItemQuickMatchActionsCouldNotRunQuickMatch(Object error) {
    return Intl.message(
      'Could not run quick match: $error',
      name: 'componentsAppItemMatchLibraryItemQuickMatchActionsCouldNotRunQuickMatch',
      desc: '',
      args: [error],
    );
  }

  /// `Search filters collapsed`
  String get componentsAppItemMatchManualMatchManualMatchCollapsedSearchBarSearchFiltersCollapsed {
    return Intl.message(
      'Search filters collapsed',
      name: 'componentsAppItemMatchManualMatchManualMatchCollapsedSearchBarSearchFiltersCollapsed',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get componentsAppItemMatchManualMatchManualMatchCollapsedSearchBarEdit {
    return Intl.message(
      'Edit',
      name: 'componentsAppItemMatchManualMatchManualMatchCollapsedSearchBarEdit',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a title.`
  String get componentsAppItemMatchManualMatchManualMatchDialogPleaseEnterATitle {
    return Intl.message(
      'Please enter a title.',
      name: 'componentsAppItemMatchManualMatchManualMatchDialogPleaseEnterATitle',
      desc: '',
      args: [],
    );
  }

  /// `Select at least one provider.`
  String get componentsAppItemMatchManualMatchManualMatchDialogSelectAtLeastOneProvider {
    return Intl.message(
      'Select at least one provider.',
      name: 'componentsAppItemMatchManualMatchManualMatchDialogSelectAtLeastOneProvider',
      desc: '',
      args: [],
    );
  }

  /// `No API session available.`
  String get componentsAppItemMatchManualMatchManualMatchDialogNoAPISessionAvailable {
    return Intl.message(
      'No API session available.',
      name: 'componentsAppItemMatchManualMatchManualMatchDialogNoAPISessionAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No match results found.`
  String get componentsAppItemMatchManualMatchManualMatchDialogNoMatchResultsFound {
    return Intl.message(
      'No match results found.',
      name: 'componentsAppItemMatchManualMatchManualMatchDialogNoMatchResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `Select at least one field to apply.`
  String get componentsAppItemMatchManualMatchManualMatchDialogSelectAtLeastOneFieldTo {
    return Intl.message(
      'Select at least one field to apply.',
      name: 'componentsAppItemMatchManualMatchManualMatchDialogSelectAtLeastOneFieldTo',
      desc: '',
      args: [],
    );
  }

  /// `No writable values were selected from this match result.`
  String get componentsAppItemMatchManualMatchManualMatchDialogNoWritableValuesWereSelectedFrom {
    return Intl.message(
      'No writable values were selected from this match result.',
      name: 'componentsAppItemMatchManualMatchManualMatchDialogNoWritableValuesWereSelectedFrom',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save manual match: {error}`
  String componentsAppItemMatchManualMatchManualMatchDialogFailedToSaveManualMatch(Object error) {
    return Intl.message(
      'Failed to save manual match: $error',
      name: 'componentsAppItemMatchManualMatchManualMatchDialogFailedToSaveManualMatch',
      desc: '',
      args: [error],
    );
  }

  /// `Candidates`
  String get componentsAppItemMatchManualMatchManualMatchDialogCandidates {
    return Intl.message(
      'Candidates',
      name: 'componentsAppItemMatchManualMatchManualMatchDialogCandidates',
      desc: '',
      args: [],
    );
  }

  /// `Selection`
  String get componentsAppItemMatchManualMatchManualMatchDialogSelection {
    return Intl.message(
      'Selection',
      name: 'componentsAppItemMatchManualMatchManualMatchDialogSelection',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get componentsAppItemMatchManualMatchManualMatchDialogCancel {
    return Intl.message('Cancel', name: 'componentsAppItemMatchManualMatchManualMatchDialogCancel', desc: '', args: []);
  }

  /// `Close`
  String get componentsAppItemMatchManualMatchManualMatchDialogClose {
    return Intl.message('Close', name: 'componentsAppItemMatchManualMatchManualMatchDialogClose', desc: '', args: []);
  }

  /// `Select a match result to choose which metadata fields to apply.`
  String get componentsAppItemMatchManualMatchManualMatchEditorPaneSelectAMatchResultToChoose {
    return Intl.message(
      'Select a match result to choose which metadata fields to apply.',
      name: 'componentsAppItemMatchManualMatchManualMatchEditorPaneSelectAMatchResultToChoose',
      desc: '',
      args: [],
    );
  }

  /// `Apply fields`
  String get componentsAppItemMatchManualMatchManualMatchEditorPaneApplyFields {
    return Intl.message(
      'Apply fields',
      name: 'componentsAppItemMatchManualMatchManualMatchEditorPaneApplyFields',
      desc: '',
      args: [],
    );
  }

  /// `Select all available fields`
  String get componentsAppItemMatchManualMatchManualMatchEditorPaneSelectAllAvailableFields {
    return Intl.message(
      'Select all available fields',
      name: 'componentsAppItemMatchManualMatchManualMatchEditorPaneSelectAllAvailableFields',
      desc: '',
      args: [],
    );
  }

  /// `Current: {currentLabel}`
  String componentsAppItemMatchManualMatchManualMatchFieldEditorCurrent(Object currentLabel) {
    return Intl.message(
      'Current: $currentLabel',
      name: 'componentsAppItemMatchManualMatchManualMatchFieldEditorCurrent',
      desc: '',
      args: [currentLabel],
    );
  }

  /// `Yes`
  String get componentsAppItemMatchManualMatchManualMatchFieldEditorYes {
    return Intl.message('Yes', name: 'componentsAppItemMatchManualMatchManualMatchFieldEditorYes', desc: '', args: []);
  }

  /// `No`
  String get componentsAppItemMatchManualMatchManualMatchFieldEditorNo {
    return Intl.message('No', name: 'componentsAppItemMatchManualMatchManualMatchFieldEditorNo', desc: '', args: []);
  }

  /// `Mode:`
  String get componentsAppItemMatchManualMatchManualMatchFieldEditorMode {
    return Intl.message(
      'Mode:',
      name: 'componentsAppItemMatchManualMatchManualMatchFieldEditorMode',
      desc: '',
      args: [],
    );
  }

  /// `Add value`
  String get componentsAppItemMatchManualMatchManualMatchFieldEditorAddValue {
    return Intl.message(
      'Add value',
      name: 'componentsAppItemMatchManualMatchManualMatchFieldEditorAddValue',
      desc: '',
      args: [],
    );
  }

  /// `Select providers`
  String get componentsAppItemMatchManualMatchManualMatchProviderDropdownSelectProviders {
    return Intl.message(
      'Select providers',
      name: 'componentsAppItemMatchManualMatchManualMatchProviderDropdownSelectProviders',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get componentsAppItemMatchManualMatchManualMatchProviderDropdownCancel {
    return Intl.message(
      'Cancel',
      name: 'componentsAppItemMatchManualMatchManualMatchProviderDropdownCancel',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get componentsAppItemMatchManualMatchManualMatchProviderDropdownApply {
    return Intl.message(
      'Apply',
      name: 'componentsAppItemMatchManualMatchManualMatchProviderDropdownApply',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get componentsAppItemMatchManualMatchManualMatchProviderDropdownClose {
    return Intl.message(
      'Close',
      name: 'componentsAppItemMatchManualMatchManualMatchProviderDropdownClose',
      desc: '',
      args: [],
    );
  }

  /// `Match candidates`
  String get componentsAppItemMatchManualMatchManualMatchResultsPaneMatchCandidates {
    return Intl.message(
      'Match candidates',
      name: 'componentsAppItemMatchManualMatchManualMatchResultsPaneMatchCandidates',
      desc: '',
      args: [],
    );
  }

  /// `Run a search to load metadata match results.`
  String get componentsAppItemMatchManualMatchManualMatchResultsPaneRunASearchToLoadMetadata {
    return Intl.message(
      'Run a search to load metadata match results.',
      name: 'componentsAppItemMatchManualMatchManualMatchResultsPaneRunASearchToLoadMetadata',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get componentsAppItemMatchManualMatchManualMatchSearchCardLoading {
    return Intl.message(
      'Loading...',
      name: 'componentsAppItemMatchManualMatchManualMatchSearchCardLoading',
      desc: '',
      args: [],
    );
  }

  /// `{error}`
  String componentsAppItemMatchManualMatchManualMatchSearchCardText(Object error) {
    return Intl.message(
      '$error',
      name: 'componentsAppItemMatchManualMatchManualMatchSearchCardText',
      desc: '',
      args: [error],
    );
  }

  /// `No providers available`
  String get componentsAppItemMatchManualMatchManualMatchSearchCardNoProvidersAvailable {
    return Intl.message(
      'No providers available',
      name: 'componentsAppItemMatchManualMatchManualMatchSearchCardNoProvidersAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get componentsAppItemMatchManualMatchManualMatchSearchCardTitle {
    return Intl.message(
      'Title',
      name: 'componentsAppItemMatchManualMatchManualMatchSearchCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `Search title`
  String get componentsAppItemMatchManualMatchManualMatchSearchCardSearchTitle {
    return Intl.message(
      'Search title',
      name: 'componentsAppItemMatchManualMatchManualMatchSearchCardSearchTitle',
      desc: '',
      args: [],
    );
  }

  /// `Author`
  String get componentsAppItemMatchManualMatchManualMatchSearchCardAuthor {
    return Intl.message(
      'Author',
      name: 'componentsAppItemMatchManualMatchManualMatchSearchCardAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Providers`
  String get componentsAppItemMatchManualMatchManualMatchSearchCardProviders {
    return Intl.message(
      'Providers',
      name: 'componentsAppItemMatchManualMatchManualMatchSearchCardProviders',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load providers`
  String get componentsAppItemMatchManualMatchManualMatchSearchCardFailedToLoadProviders {
    return Intl.message(
      'Failed to load providers',
      name: 'componentsAppItemMatchManualMatchManualMatchSearchCardFailedToLoadProviders',
      desc: '',
      args: [],
    );
  }

  /// `Loading providers...`
  String get componentsAppItemMatchQuickMatchOptionsDialogLoadingProviders {
    return Intl.message(
      'Loading providers...',
      name: 'componentsAppItemMatchQuickMatchOptionsDialogLoadingProviders',
      desc: '',
      args: [],
    );
  }

  /// `Could not load metadata providers: {error}`
  String componentsAppItemMatchQuickMatchOptionsDialogCouldNotLoadMetadataProviders(Object error) {
    return Intl.message(
      'Could not load metadata providers: $error',
      name: 'componentsAppItemMatchQuickMatchOptionsDialogCouldNotLoadMetadataProviders',
      desc: '',
      args: [error],
    );
  }

  /// `No metadata providers are available for this media type.`
  String get componentsAppItemMatchQuickMatchOptionsDialogNoMetadataProvidersAreAvailableFor {
    return Intl.message(
      'No metadata providers are available for this media type.',
      name: 'componentsAppItemMatchQuickMatchOptionsDialogNoMetadataProvidersAreAvailableFor',
      desc: '',
      args: [],
    );
  }

  /// `Overwrite current metadata`
  String get componentsAppItemMatchQuickMatchOptionsDialogOverwriteCurrentMetadata {
    return Intl.message(
      'Overwrite current metadata',
      name: 'componentsAppItemMatchQuickMatchOptionsDialogOverwriteCurrentMetadata',
      desc: '',
      args: [],
    );
  }

  /// `Replace existing title, author, description, and related fields.`
  String get componentsAppItemMatchQuickMatchOptionsDialogReplaceExistingTitleAuthorDescriptionAnd {
    return Intl.message(
      'Replace existing title, author, description, and related fields.',
      name: 'componentsAppItemMatchQuickMatchOptionsDialogReplaceExistingTitleAuthorDescriptionAnd',
      desc: '',
      args: [],
    );
  }

  /// `Overwrite cover image`
  String get componentsAppItemMatchQuickMatchOptionsDialogOverwriteCoverImage {
    return Intl.message(
      'Overwrite cover image',
      name: 'componentsAppItemMatchQuickMatchOptionsDialogOverwriteCoverImage',
      desc: '',
      args: [],
    );
  }

  /// `Replace current cover artwork when a match provides one.`
  String get componentsAppItemMatchQuickMatchOptionsDialogReplaceCurrentCoverArtworkWhenA {
    return Intl.message(
      'Replace current cover artwork when a match provides one.',
      name: 'componentsAppItemMatchQuickMatchOptionsDialogReplaceCurrentCoverArtworkWhenA',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get componentsAppItemMatchQuickMatchOptionsDialogCancel {
    return Intl.message('Cancel', name: 'componentsAppItemMatchQuickMatchOptionsDialogCancel', desc: '', args: []);
  }

  /// `Provider`
  String get componentsAppItemMatchQuickMatchOptionsDialogProvider {
    return Intl.message('Provider', name: 'componentsAppItemMatchQuickMatchOptionsDialogProvider', desc: '', args: []);
  }

  /// `You are offline. Please reconnect and try again.`
  String get componentsAppLibraryAuthorCleanupToolYouAreOfflinePleaseReconnectAnd {
    return Intl.message(
      'You are offline. Please reconnect and try again.',
      name: 'componentsAppLibraryAuthorCleanupToolYouAreOfflinePleaseReconnectAnd',
      desc: '',
      args: [],
    );
  }

  /// `Could not remove authors without books: {error}`
  String componentsAppLibraryAuthorCleanupToolCouldNotRemoveAuthorsWithoutBooks(Object error) {
    return Intl.message(
      'Could not remove authors without books: $error',
      name: 'componentsAppLibraryAuthorCleanupToolCouldNotRemoveAuthorsWithoutBooks',
      desc: '',
      args: [error],
    );
  }

  /// `No Authors To Remove`
  String get componentsAppLibraryAuthorCleanupToolNoAuthorsToRemove {
    return Intl.message(
      'No Authors To Remove',
      name: 'componentsAppLibraryAuthorCleanupToolNoAuthorsToRemove',
      desc: '',
      args: [],
    );
  }

  /// `No authors with 0 books were found.`
  String get componentsAppLibraryAuthorCleanupToolNoAuthorsWith0BooksWere {
    return Intl.message(
      'No authors with 0 books were found.',
      name: 'componentsAppLibraryAuthorCleanupToolNoAuthorsWith0BooksWere',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get componentsAppLibraryAuthorCleanupToolClose {
    return Intl.message('Close', name: 'componentsAppLibraryAuthorCleanupToolClose', desc: '', args: []);
  }

  /// `These authors have 0 books and will be removed permanently:`
  String get componentsAppLibraryAuthorCleanupToolTheseAuthorsHave0BooksAnd {
    return Intl.message(
      'These authors have 0 books and will be removed permanently:',
      name: 'componentsAppLibraryAuthorCleanupToolTheseAuthorsHave0BooksAnd',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get componentsAppLibraryAuthorCleanupToolCancel {
    return Intl.message('Cancel', name: 'componentsAppLibraryAuthorCleanupToolCancel', desc: '', args: []);
  }

  /// `Delete {p1}`
  String componentsAppLibraryAuthorCleanupToolDelete(Object p1) {
    return Intl.message('Delete $p1', name: 'componentsAppLibraryAuthorCleanupToolDelete', desc: '', args: [p1]);
  }

  /// `{p1}/{p2}`
  String componentsAppLibraryAuthorCleanupToolText(Object p1, Object p2) {
    return Intl.message('$p1/$p2', name: 'componentsAppLibraryAuthorCleanupToolText', desc: '', args: [p1, p2]);
  }

  /// `Open Series`
  String get componentsAppLibraryAuthorDetailContentOpenSeries {
    return Intl.message('Open Series', name: 'componentsAppLibraryAuthorDetailContentOpenSeries', desc: '', args: []);
  }

  /// `Sort Authors`
  String get componentsAppLibraryAuthorSortSheetSortAuthors {
    return Intl.message('Sort Authors', name: 'componentsAppLibraryAuthorSortSheetSortAuthors', desc: '', args: []);
  }

  /// `Close`
  String get componentsAppLibraryAuthorSortSheetClose {
    return Intl.message('Close', name: 'componentsAppLibraryAuthorSortSheetClose', desc: '', args: []);
  }

  /// `Library Filters`
  String get componentsAppLibraryLibraryFilterSheetLibraryFilters {
    return Intl.message(
      'Library Filters',
      name: 'componentsAppLibraryLibraryFilterSheetLibraryFilters',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get componentsAppLibraryLibraryFilterSheetClear {
    return Intl.message('Clear', name: 'componentsAppLibraryLibraryFilterSheetClear', desc: '', args: []);
  }

  /// `No filter options are available for this library yet.`
  String get componentsAppLibraryLibraryFilterSheetNoFilterOptionsAreAvailableFor {
    return Intl.message(
      'No filter options are available for this library yet.',
      name: 'componentsAppLibraryLibraryFilterSheetNoFilterOptionsAreAvailableFor',
      desc: '',
      args: [],
    );
  }

  /// `No matching options`
  String get componentsAppLibraryLibraryFilterSheetNoMatchingOptions {
    return Intl.message(
      'No matching options',
      name: 'componentsAppLibraryLibraryFilterSheetNoMatchingOptions',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get componentsAppLibraryLibraryFilterSheetClose {
    return Intl.message('Close', name: 'componentsAppLibraryLibraryFilterSheetClose', desc: '', args: []);
  }

  /// `Search options`
  String get componentsAppLibraryLibraryFilterSheetSearchOptions {
    return Intl.message(
      'Search options',
      name: 'componentsAppLibraryLibraryFilterSheetSearchOptions',
      desc: '',
      args: [],
    );
  }

  /// `Selected: {label}`
  String componentsAppLibraryLibraryFilterSheetSelected(Object label) {
    return Intl.message(
      'Selected: $label',
      name: 'componentsAppLibraryLibraryFilterSheetSelected',
      desc: '',
      args: [label],
    );
  }

  /// `{count} options`
  String componentsAppLibraryLibraryFilterSheetOptionsCount(Object count) {
    return Intl.message(
      '$count options',
      name: 'componentsAppLibraryLibraryFilterSheetOptionsCount',
      desc: '',
      args: [count],
    );
  }

  /// `No API session available.`
  String get componentsAppLibraryLibraryMultiSelectActionsNoAPISessionAvailable {
    return Intl.message(
      'No API session available.',
      name: 'componentsAppLibraryLibraryMultiSelectActionsNoAPISessionAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Could not quick match selected books: {error}`
  String componentsAppLibraryLibraryMultiSelectActionsCouldNotQuickMatchSelectedBooks(Object error) {
    return Intl.message(
      'Could not quick match selected books: $error',
      name: 'componentsAppLibraryLibraryMultiSelectActionsCouldNotQuickMatchSelectedBooks',
      desc: '',
      args: [error],
    );
  }

  /// `Add to playlist`
  String get componentsAppLibraryLibraryMultiSelectHostAddToPlaylist {
    return Intl.message(
      'Add to playlist',
      name: 'componentsAppLibraryLibraryMultiSelectHostAddToPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Add to collection`
  String get componentsAppLibraryLibraryMultiSelectHostAddToCollection {
    return Intl.message(
      'Add to collection',
      name: 'componentsAppLibraryLibraryMultiSelectHostAddToCollection',
      desc: '',
      args: [],
    );
  }

  /// `Quick match selected books`
  String get componentsAppLibraryLibraryMultiSelectHostQuickMatchSelectedBooks {
    return Intl.message(
      'Quick match selected books',
      name: 'componentsAppLibraryLibraryMultiSelectHostQuickMatchSelectedBooks',
      desc: '',
      args: [],
    );
  }

  /// `Sort Library`
  String get componentsAppLibraryLibrarySortSheetSortLibrary {
    return Intl.message('Sort Library', name: 'componentsAppLibraryLibrarySortSheetSortLibrary', desc: '', args: []);
  }

  /// `Close`
  String get componentsAppLibraryLibrarySortSheetClose {
    return Intl.message('Close', name: 'componentsAppLibraryLibrarySortSheetClose', desc: '', args: []);
  }

  /// `Retry`
  String get componentsAppLibraryLibraryTargetPickerSheetRetry {
    return Intl.message('Retry', name: 'componentsAppLibraryLibraryTargetPickerSheetRetry', desc: '', args: []);
  }

  /// `Select library`
  String get componentsAppLibrarySwitcherSelectLibrary {
    return Intl.message('Select library', name: 'componentsAppLibrarySwitcherSelectLibrary', desc: '', args: []);
  }

  /// `Task Activity`
  String get componentsAppTasksTaskNotificationPanelTaskActivity {
    return Intl.message(
      'Task Activity',
      name: 'componentsAppTasksTaskNotificationPanelTaskActivity',
      desc: '',
      args: [],
    );
  }

  /// `No tasks yet.`
  String get componentsAppTasksTaskNotificationPanelNoTasksYet {
    return Intl.message('No tasks yet.', name: 'componentsAppTasksTaskNotificationPanelNoTasksYet', desc: '', args: []);
  }

  /// `Clear completed activity`
  String get componentsAppTasksTaskNotificationPanelClearCompletedActivity {
    return Intl.message(
      'Clear completed activity',
      name: 'componentsAppTasksTaskNotificationPanelClearCompletedActivity',
      desc: '',
      args: [],
    );
  }

  /// `Suggested: {p1} | {p2} | {p3}`
  String componentsAppUploadLibraryUploadItemCardSuggested(Object p1, Object p2, Object p3) {
    return Intl.message(
      'Suggested: $p1 | $p2 | $p3',
      name: 'componentsAppUploadLibraryUploadItemCardSuggested',
      desc: '',
      args: [p1, p2, p3],
    );
  }

  /// `Files ({p1})`
  String componentsAppUploadLibraryUploadItemCardFiles(Object p1) {
    return Intl.message('Files ($p1)', name: 'componentsAppUploadLibraryUploadItemCardFiles', desc: '', args: [p1]);
  }

  /// `{p1} | {p2}`
  String componentsAppUploadLibraryUploadItemCardText(Object p1, Object p2) {
    return Intl.message('$p1 | $p2', name: 'componentsAppUploadLibraryUploadItemCardText', desc: '', args: [p1, p2]);
  }

  /// `Fetch metadata`
  String get componentsAppUploadLibraryUploadItemCardFetchMetadata {
    return Intl.message(
      'Fetch metadata',
      name: 'componentsAppUploadLibraryUploadItemCardFetchMetadata',
      desc: '',
      args: [],
    );
  }

  /// `Remove upload item`
  String get componentsAppUploadLibraryUploadItemCardRemoveUploadItem {
    return Intl.message(
      'Remove upload item',
      name: 'componentsAppUploadLibraryUploadItemCardRemoveUploadItem',
      desc: '',
      args: [],
    );
  }

  /// `Accept metadata suggestion`
  String get componentsAppUploadLibraryUploadItemCardAcceptMetadataSuggestion {
    return Intl.message(
      'Accept metadata suggestion',
      name: 'componentsAppUploadLibraryUploadItemCardAcceptMetadataSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Reject metadata suggestion`
  String get componentsAppUploadLibraryUploadItemCardRejectMetadataSuggestion {
    return Intl.message(
      'Reject metadata suggestion',
      name: 'componentsAppUploadLibraryUploadItemCardRejectMetadataSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Path check issues found`
  String get componentsAppUploadLibraryUploadPanelPathCheckIssuesFound {
    return Intl.message(
      'Path check issues found',
      name: 'componentsAppUploadLibraryUploadPanelPathCheckIssuesFound',
      desc: '',
      args: [],
    );
  }

  /// `Some items have destination conflicts or path-check errors. Continue anyway?`
  String get componentsAppUploadLibraryUploadPanelSomeItemsHaveDestinationConflictsOr {
    return Intl.message(
      'Some items have destination conflicts or path-check errors. Continue anyway?',
      name: 'componentsAppUploadLibraryUploadPanelSomeItemsHaveDestinationConflictsOr',
      desc: '',
      args: [],
    );
  }

  /// `- {p1}`
  String componentsAppUploadLibraryUploadPanelText(Object p1) {
    return Intl.message('- $p1', name: 'componentsAppUploadLibraryUploadPanelText', desc: '', args: [p1]);
  }

  /// `Cancel upload`
  String get componentsAppUploadLibraryUploadPanelCancelUpload {
    return Intl.message('Cancel upload', name: 'componentsAppUploadLibraryUploadPanelCancelUpload', desc: '', args: []);
  }

  /// `Continue anyway`
  String get componentsAppUploadLibraryUploadPanelContinueAnyway {
    return Intl.message(
      'Continue anyway',
      name: 'componentsAppUploadLibraryUploadPanelContinueAnyway',
      desc: '',
      args: [],
    );
  }

  /// `Upload to {p1}`
  String componentsAppUploadLibraryUploadPanelUploadTo(Object p1) {
    return Intl.message('Upload to $p1', name: 'componentsAppUploadLibraryUploadPanelUploadTo', desc: '', args: [p1]);
  }

  /// `Advanced options`
  String get componentsAppUploadLibraryUploadPanelAdvancedOptions {
    return Intl.message(
      'Advanced options',
      name: 'componentsAppUploadLibraryUploadPanelAdvancedOptions',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get componentsAppUploadLibraryUploadPanelSettings {
    return Intl.message('Settings', name: 'componentsAppUploadLibraryUploadPanelSettings', desc: '', args: []);
  }

  /// `Requires admin role.`
  String get componentsAppUploadLibraryUploadPanelRequiresAdminRole {
    return Intl.message(
      'Requires admin role.',
      name: 'componentsAppUploadLibraryUploadPanelRequiresAdminRole',
      desc: '',
      args: [],
    );
  }

  /// `Bulk update queue metadata`
  String get componentsAppUploadLibraryUploadPanelBulkUpdateQueueMetadata {
    return Intl.message(
      'Bulk update queue metadata',
      name: 'componentsAppUploadLibraryUploadPanelBulkUpdateQueueMetadata',
      desc: '',
      args: [],
    );
  }

  /// `Apply author`
  String get componentsAppUploadLibraryUploadPanelApplyAuthor {
    return Intl.message('Apply author', name: 'componentsAppUploadLibraryUploadPanelApplyAuthor', desc: '', args: []);
  }

  /// `Apply series`
  String get componentsAppUploadLibraryUploadPanelApplySeries {
    return Intl.message('Apply series', name: 'componentsAppUploadLibraryUploadPanelApplySeries', desc: '', args: []);
  }

  /// `Clear queue`
  String get componentsAppUploadLibraryUploadPanelClearQueue {
    return Intl.message('Clear queue', name: 'componentsAppUploadLibraryUploadPanelClearQueue', desc: '', args: []);
  }

  /// `Cancel uploads`
  String get componentsAppUploadLibraryUploadPanelCancelUploads {
    return Intl.message(
      'Cancel uploads',
      name: 'componentsAppUploadLibraryUploadPanelCancelUploads',
      desc: '',
      args: [],
    );
  }

  /// `Start upload`
  String get componentsAppUploadLibraryUploadPanelStartUpload {
    return Intl.message('Start upload', name: 'componentsAppUploadLibraryUploadPanelStartUpload', desc: '', args: []);
  }

  /// `Upload queue is empty. Add files or folders using the drop area above.`
  String get componentsAppUploadLibraryUploadPanelUploadQueueIsEmptyAddFiles {
    return Intl.message(
      'Upload queue is empty. Add files or folders using the drop area above.',
      name: 'componentsAppUploadLibraryUploadPanelUploadQueueIsEmptyAddFiles',
      desc: '',
      args: [],
    );
  }

  /// `Choose files`
  String get componentsAppUploadLibraryUploadPanelChooseFiles {
    return Intl.message('Choose files', name: 'componentsAppUploadLibraryUploadPanelChooseFiles', desc: '', args: []);
  }

  /// `Choose folder`
  String get componentsAppUploadLibraryUploadPanelChooseFolder {
    return Intl.message('Choose folder', name: 'componentsAppUploadLibraryUploadPanelChooseFolder', desc: '', args: []);
  }

  /// `Back`
  String get componentsAppUploadLibraryUploadPanelBack {
    return Intl.message('Back', name: 'componentsAppUploadLibraryUploadPanelBack', desc: '', args: []);
  }

  /// `Switch User`
  String get componentsAppUserSwitcherSwitchUser {
    return Intl.message('Switch User', name: 'componentsAppUserSwitcherSwitchUser', desc: '', args: []);
  }

  /// `Are you sure you want to switch users? When you switch the user, the player will not be able to sync the progress. It will still be saved locally and sync with the server after an app restart.`
  String get componentsAppUserSwitcherAreYouSureYouWantTo {
    return Intl.message(
      'Are you sure you want to switch users? When you switch the user, the player will not be able to sync the progress. It will still be saved locally and sync with the server after an app restart.',
      name: 'componentsAppUserSwitcherAreYouSureYouWantTo',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get componentsAppUserSwitcherCancel {
    return Intl.message('Cancel', name: 'componentsAppUserSwitcherCancel', desc: '', args: []);
  }

  /// `Switch`
  String get componentsAppUserSwitcherSwitch {
    return Intl.message('Switch', name: 'componentsAppUserSwitcherSwitch', desc: '', args: []);
  }

  /// `Add New User`
  String get componentsAppUserSwitcherAddNewUser {
    return Intl.message('Add New User', name: 'componentsAppUserSwitcherAddNewUser', desc: '', args: []);
  }

  /// `Error loading users: {error}`
  String componentsAppUserSwitcherErrorLoadingUsers(Object error) {
    return Intl.message(
      'Error loading users: $error',
      name: 'componentsAppUserSwitcherErrorLoadingUsers',
      desc: '',
      args: [error],
    );
  }

  /// `Error loading current user: {error}`
  String componentsAppUserSwitcherErrorLoadingCurrentUser(Object error) {
    return Intl.message(
      'Error loading current user: $error',
      name: 'componentsAppUserSwitcherErrorLoadingCurrentUser',
      desc: '',
      args: [error],
    );
  }

  /// `Switch or Add User`
  String get componentsAppUserSwitcherSwitchOrAddUser {
    return Intl.message('Switch or Add User', name: 'componentsAppUserSwitcherSwitchOrAddUser', desc: '', args: []);
  }

  /// `Server reachable`
  String get componentsAppUserSwitcherAvatarServerReachable {
    return Intl.message('Server reachable', name: 'componentsAppUserSwitcherAvatarServerReachable', desc: '', args: []);
  }

  /// `Server connection problems`
  String get componentsAppUserSwitcherAvatarServerConnectionProblems {
    return Intl.message(
      'Server connection problems',
      name: 'componentsAppUserSwitcherAvatarServerConnectionProblems',
      desc: '',
      args: [],
    );
  }

  /// `Checking server status`
  String get componentsAppUserSwitcherAvatarCheckingServerStatus {
    return Intl.message(
      'Checking server status',
      name: 'componentsAppUserSwitcherAvatarCheckingServerStatus',
      desc: '',
      args: [],
    );
  }

  /// `Unselect all`
  String get componentsCommonBookEditorSheetUnselectAll {
    return Intl.message('Unselect all', name: 'componentsCommonBookEditorSheetUnselectAll', desc: '', args: []);
  }

  /// `Search books to add`
  String get componentsCommonBookEditorSheetSearchBooksToAdd {
    return Intl.message(
      'Search books to add',
      name: 'componentsCommonBookEditorSheetSearchBooksToAdd',
      desc: '',
      args: [],
    );
  }

  /// `No matching books found.`
  String get componentsCommonBookEditorSheetNoMatchingBooksFound {
    return Intl.message(
      'No matching books found.',
      name: 'componentsCommonBookEditorSheetNoMatchingBooksFound',
      desc: '',
      args: [],
    );
  }

  /// `Search failed. Please try another query.`
  String get componentsCommonBookEditorSheetSearchFailedPleaseTryAnotherQuery {
    return Intl.message(
      'Search failed. Please try another query.',
      name: 'componentsCommonBookEditorSheetSearchFailedPleaseTryAnotherQuery',
      desc: '',
      args: [],
    );
  }

  /// `Selected ({p1})`
  String componentsCommonBookEditorSheetSelected(Object p1) {
    return Intl.message('Selected ($p1)', name: 'componentsCommonBookEditorSheetSelected', desc: '', args: [p1]);
  }

  /// `No books selected.`
  String get componentsCommonBookEditorSheetNoBooksSelected {
    return Intl.message(
      'No books selected.',
      name: 'componentsCommonBookEditorSheetNoBooksSelected',
      desc: '',
      args: [],
    );
  }

  /// `Search books`
  String get componentsCommonBookEditorSheetSearchBooks {
    return Intl.message('Search books', name: 'componentsCommonBookEditorSheetSearchBooks', desc: '', args: []);
  }

  /// `Title, author, or series`
  String get componentsCommonBookEditorSheetTitleAuthorOrSeries {
    return Intl.message(
      'Title, author, or series',
      name: 'componentsCommonBookEditorSheetTitleAuthorOrSeries',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get componentsCommonCoverZoomViewClose {
    return Intl.message('Close', name: 'componentsCommonCoverZoomViewClose', desc: '', args: []);
  }

  /// `Choose deletion mode:`
  String get componentsCommonLibraryItemDeleteDialogChooseDeletionMode {
    return Intl.message(
      'Choose deletion mode:',
      name: 'componentsCommonLibraryItemDeleteDialogChooseDeletionMode',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{Delete audiobook?} other{Delete audiobooks?}}`
  String componentsCommonLibraryItemDeleteDialogDeleteAudiobookQuestion(int count) {
    return Intl.plural(
      count,
      one: 'Delete audiobook?',
      other: 'Delete audiobooks?',
      name: 'componentsCommonLibraryItemDeleteDialogDeleteAudiobookQuestion',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{This action will remove the audiobook from Audiobookshelf and cannot be undone.} other{This action will remove {count} audiobooks from Audiobookshelf and cannot be undone.}}`
  String componentsCommonLibraryItemDeleteDialogDeleteWarning(int count) {
    return Intl.plural(
      count,
      one: 'This action will remove the audiobook from Audiobookshelf and cannot be undone.',
      other: 'This action will remove $count audiobooks from Audiobookshelf and cannot be undone.',
      name: 'componentsCommonLibraryItemDeleteDialogDeleteWarning',
      desc: '',
      args: [count],
    );
  }

  /// `{skippedCount} selected item(s) are not audiobooks and will be skipped.`
  String componentsCommonLibraryItemDeleteDialogSelectedItemSAreNotAudiobooks(Object skippedCount) {
    return Intl.message(
      '$skippedCount selected item(s) are not audiobooks and will be skipped.',
      name: 'componentsCommonLibraryItemDeleteDialogSelectedItemSAreNotAudiobooks',
      desc: '',
      args: [skippedCount],
    );
  }

  /// `Cancel`
  String get componentsCommonLibraryItemDeleteDialogCancel {
    return Intl.message('Cancel', name: 'componentsCommonLibraryItemDeleteDialogCancel', desc: '', args: []);
  }

  /// `Back`
  String get componentsCommonListEntityMissingViewBack {
    return Intl.message('Back', name: 'componentsCommonListEntityMissingViewBack', desc: '', args: []);
  }

  /// `Cancel`
  String get componentsCommonListManagementDialogsCancel {
    return Intl.message('Cancel', name: 'componentsCommonListManagementDialogsCancel', desc: '', args: []);
  }

  /// `Name`
  String get componentsCommonListManagementDialogsName {
    return Intl.message('Name', name: 'componentsCommonListManagementDialogsName', desc: '', args: []);
  }

  /// `Description`
  String get componentsCommonListManagementDialogsDescription {
    return Intl.message('Description', name: 'componentsCommonListManagementDialogsDescription', desc: '', args: []);
  }

  /// `Optional`
  String get componentsCommonListManagementDialogsOptional {
    return Intl.message('Optional', name: 'componentsCommonListManagementDialogsOptional', desc: '', args: []);
  }

  /// `+{hiddenBookCount}`
  String componentsCommonMultiBookEntryWidgetText(Object hiddenBookCount) {
    return Intl.message(
      '+$hiddenBookCount',
      name: 'componentsCommonMultiBookEntryWidgetText',
      desc: '',
      args: [hiddenBookCount],
    );
  }

  /// `No active media to bookmark.`
  String get componentsPlayerCommonBookmarksButtonNoActiveMediaToBookmark {
    return Intl.message(
      'No active media to bookmark.',
      name: 'componentsPlayerCommonBookmarksButtonNoActiveMediaToBookmark',
      desc: '',
      args: [],
    );
  }

  /// `Bookmarks`
  String get componentsPlayerCommonBookmarksButtonBookmarks {
    return Intl.message('Bookmarks', name: 'componentsPlayerCommonBookmarksButtonBookmarks', desc: '', args: []);
  }

  /// `Cast Devices`
  String get componentsPlayerCommonCastButtonCastDevices {
    return Intl.message('Cast Devices', name: 'componentsPlayerCommonCastButtonCastDevices', desc: '', args: []);
  }

  /// `Searching for cast devices...`
  String get componentsPlayerCommonCastButtonSearchingForCastDevices {
    return Intl.message(
      'Searching for cast devices...',
      name: 'componentsPlayerCommonCastButtonSearchingForCastDevices',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get componentsPlayerCommonCastButtonConnected {
    return Intl.message('Connected', name: 'componentsPlayerCommonCastButtonConnected', desc: '', args: []);
  }

  /// `Disconnect`
  String get componentsPlayerCommonCastButtonDisconnect {
    return Intl.message('Disconnect', name: 'componentsPlayerCommonCastButtonDisconnect', desc: '', args: []);
  }

  /// `Retry Cast setup`
  String get componentsPlayerCommonCastButtonRetryCastSetup {
    return Intl.message('Retry Cast setup', name: 'componentsPlayerCommonCastButtonRetryCastSetup', desc: '', args: []);
  }

  /// `Connect to a cast device`
  String get componentsPlayerCommonCastButtonConnectToACastDevice {
    return Intl.message(
      'Connect to a cast device',
      name: 'componentsPlayerCommonCastButtonConnectToACastDevice',
      desc: '',
      args: [],
    );
  }

  /// `Manage cast device`
  String get componentsPlayerCommonCastButtonManageCastDevice {
    return Intl.message(
      'Manage cast device',
      name: 'componentsPlayerCommonCastButtonManageCastDevice',
      desc: '',
      args: [],
    );
  }

  /// `Nothing is currently playing to cast.`
  String get componentsPlayerCommonCastButtonNothingIsCurrentlyPlayingToCast {
    return Intl.message(
      'Nothing is currently playing to cast.',
      name: 'componentsPlayerCommonCastButtonNothingIsCurrentlyPlayingToCast',
      desc: '',
      args: [],
    );
  }

  /// `Unable to determine the current track.`
  String get componentsPlayerCommonCastButtonUnableToDetermineTheCurrentTrack {
    return Intl.message(
      'Unable to determine the current track.',
      name: 'componentsPlayerCommonCastButtonUnableToDetermineTheCurrentTrack',
      desc: '',
      args: [],
    );
  }

  /// `Current track does not have a playable URL.`
  String get componentsPlayerCommonCastButtonCurrentTrackDoesNotHaveAPlayableUrl {
    return Intl.message(
      'Current track does not have a playable URL.',
      name: 'componentsPlayerCommonCastButtonCurrentTrackDoesNotHaveAPlayableUrl',
      desc: '',
      args: [],
    );
  }

  /// `Casting local downloads requires an active server connection.`
  String get componentsPlayerCommonCastButtonCastingLocalDownloadsRequiresAnActiveServerConnection {
    return Intl.message(
      'Casting local downloads requires an active server connection.',
      name: 'componentsPlayerCommonCastButtonCastingLocalDownloadsRequiresAnActiveServerConnection',
      desc: '',
      args: [],
    );
  }

  /// `Chrome Cast is unavailable on this platform.`
  String get componentsPlayerCommonCastButtonChromeCastIsUnavailableOnThisPlatform {
    return Intl.message(
      'Chrome Cast is unavailable on this platform.',
      name: 'componentsPlayerCommonCastButtonChromeCastIsUnavailableOnThisPlatform',
      desc: '',
      args: [],
    );
  }

  /// `Chrome Cast is unavailable on this device.`
  String get componentsPlayerCommonCastButtonChromeCastIsUnavailableOnThisDevice {
    return Intl.message(
      'Chrome Cast is unavailable on this device.',
      name: 'componentsPlayerCommonCastButtonChromeCastIsUnavailableOnThisDevice',
      desc: '',
      args: [],
    );
  }

  /// `Disconnected from cast device.`
  String get componentsPlayerCommonCastButtonDisconnectedFromCastDevice {
    return Intl.message(
      'Disconnected from cast device.',
      name: 'componentsPlayerCommonCastButtonDisconnectedFromCastDevice',
      desc: '',
      args: [],
    );
  }

  /// `Failed to disconnect: {error}`
  String componentsPlayerCommonCastButtonFailedToDisconnect(Object error) {
    return Intl.message(
      'Failed to disconnect: $error',
      name: 'componentsPlayerCommonCastButtonFailedToDisconnect',
      desc: '',
      args: [error],
    );
  }

  /// `Unable to connect to {deviceName}.`
  String componentsPlayerCommonCastButtonUnableToConnectTo(Object deviceName) {
    return Intl.message(
      'Unable to connect to $deviceName.',
      name: 'componentsPlayerCommonCastButtonUnableToConnectTo',
      desc: '',
      args: [deviceName],
    );
  }

  /// `Casting to {deviceName}.`
  String componentsPlayerCommonCastButtonCastingTo(Object deviceName) {
    return Intl.message(
      'Casting to $deviceName.',
      name: 'componentsPlayerCommonCastButtonCastingTo',
      desc: '',
      args: [deviceName],
    );
  }

  /// `Failed to cast: {error}`
  String componentsPlayerCommonCastButtonFailedToCast(Object error) {
    return Intl.message(
      'Failed to cast: $error',
      name: 'componentsPlayerCommonCastButtonFailedToCast',
      desc: '',
      args: [error],
    );
  }

  /// `Unable to prepare a server stream for this item.`
  String get componentsPlayerCommonCastButtonUnableToPrepareServerStreamForThisItem {
    return Intl.message(
      'Unable to prepare a server stream for this item.',
      name: 'componentsPlayerCommonCastButtonUnableToPrepareServerStreamForThisItem',
      desc: '',
      args: [],
    );
  }

  /// `Unknown model`
  String get componentsPlayerCommonCastButtonUnknownModel {
    return Intl.message('Unknown model', name: 'componentsPlayerCommonCastButtonUnknownModel', desc: '', args: []);
  }

  /// `Sleep timer`
  String get componentsPlayerCommonSleepTimerButtonSleepTimer {
    return Intl.message('Sleep timer', name: 'componentsPlayerCommonSleepTimerButtonSleepTimer', desc: '', args: []);
  }

  /// `Remaining {p1}`
  String componentsPlayerCommonSleepTimerButtonRemaining(Object p1) {
    return Intl.message('Remaining $p1', name: 'componentsPlayerCommonSleepTimerButtonRemaining', desc: '', args: [p1]);
  }

  /// `+5m`
  String get componentsPlayerCommonSleepTimerButtonK5m {
    return Intl.message('+5m', name: 'componentsPlayerCommonSleepTimerButtonK5m', desc: '', args: []);
  }

  /// `Stop`
  String get componentsPlayerCommonSleepTimerButtonStop {
    return Intl.message('Stop', name: 'componentsPlayerCommonSleepTimerButtonStop', desc: '', args: []);
  }

  /// `Start`
  String get componentsPlayerCommonSleepTimerButtonStart {
    return Intl.message('Start', name: 'componentsPlayerCommonSleepTimerButtonStart', desc: '', args: []);
  }

  /// `Not valid`
  String get componentsPlayerCommonSleepTimerButtonNotValid {
    return Intl.message('Not valid', name: 'componentsPlayerCommonSleepTimerButtonNotValid', desc: '', args: []);
  }

  /// `Custom minutes`
  String get componentsPlayerCommonSleepTimerButtonCustomMinutes {
    return Intl.message(
      'Custom minutes',
      name: 'componentsPlayerCommonSleepTimerButtonCustomMinutes',
      desc: '',
      args: [],
    );
  }

  /// `Minutes`
  String get componentsPlayerCommonSleepTimerButtonMinutes {
    return Intl.message('Minutes', name: 'componentsPlayerCommonSleepTimerButtonMinutes', desc: '', args: []);
  }

  /// `{p1}x`
  String componentsPlayerCommonSpeedSliderX(Object p1) {
    return Intl.message('${p1}x', name: 'componentsPlayerCommonSpeedSliderX', desc: '', args: [p1]);
  }

  /// `Playback speed`
  String get componentsPlayerCommonSpeedSliderPlaybackSpeed {
    return Intl.message('Playback speed', name: 'componentsPlayerCommonSpeedSliderPlaybackSpeed', desc: '', args: []);
  }

  /// `Cancel`
  String get componentsPlayerCommonSpeedSliderCancel {
    return Intl.message('Cancel', name: 'componentsPlayerCommonSpeedSliderCancel', desc: '', args: []);
  }

  /// `Apply`
  String get componentsPlayerCommonSpeedSliderApply {
    return Intl.message('Apply', name: 'componentsPlayerCommonSpeedSliderApply', desc: '', args: []);
  }

  /// `Custom value`
  String get componentsPlayerCommonSpeedSliderCustomValue {
    return Intl.message('Custom value', name: 'componentsPlayerCommonSpeedSliderCustomValue', desc: '', args: []);
  }

  /// `0.5 - 3.0`
  String get componentsPlayerCommonSpeedSliderK0530 {
    return Intl.message('0.5 - 3.0', name: 'componentsPlayerCommonSpeedSliderK0530', desc: '', args: []);
  }

  /// `Volume {p1}%`
  String componentsPlayerCommonVolumeSliderVolume(Object p1) {
    return Intl.message('Volume $p1%', name: 'componentsPlayerCommonVolumeSliderVolume', desc: '', args: [p1]);
  }

  /// `Volume`
  String get componentsPlayerCommonVolumeSliderPanelVolume {
    return Intl.message('Volume', name: 'componentsPlayerCommonVolumeSliderPanelVolume', desc: '', args: []);
  }

  /// `{p1}%`
  String componentsPlayerCommonVolumeSliderPanelText(Object p1) {
    return Intl.message('$p1%', name: 'componentsPlayerCommonVolumeSliderPanelText', desc: '', args: [p1]);
  }

  /// `Delete Selected Sessions`
  String get componentsSessionsCurrentUserListeningSessionsTabDeleteSelectedSessions {
    return Intl.message(
      'Delete Selected Sessions',
      name: 'componentsSessionsCurrentUserListeningSessionsTabDeleteSelectedSessions',
      desc: '',
      args: [],
    );
  }

  /// `Delete {p1} selected session(s)? This cannot be undone.`
  String componentsSessionsCurrentUserListeningSessionsTabDeleteSelectedSessionSThisCannot(Object p1) {
    return Intl.message(
      'Delete $p1 selected session(s)? This cannot be undone.',
      name: 'componentsSessionsCurrentUserListeningSessionsTabDeleteSelectedSessionSThisCannot',
      desc: '',
      args: [p1],
    );
  }

  /// `Cancel`
  String get componentsSessionsCurrentUserListeningSessionsTabCancel {
    return Intl.message('Cancel', name: 'componentsSessionsCurrentUserListeningSessionsTabCancel', desc: '', args: []);
  }

  /// `Delete`
  String get componentsSessionsCurrentUserListeningSessionsTabDelete {
    return Intl.message('Delete', name: 'componentsSessionsCurrentUserListeningSessionsTabDelete', desc: '', args: []);
  }

  /// `Deleted {deletedCount} session(s).`
  String componentsSessionsCurrentUserListeningSessionsTabDeletedSessionS(Object deletedCount) {
    return Intl.message(
      'Deleted $deletedCount session(s).',
      name: 'componentsSessionsCurrentUserListeningSessionsTabDeletedSessionS',
      desc: '',
      args: [deletedCount],
    );
  }

  /// `Failed to delete {p1} session(s). Check logs for details.`
  String componentsSessionsCurrentUserListeningSessionsTabFailedToDeleteSessionSCheck(Object p1) {
    return Intl.message(
      'Failed to delete $p1 session(s). Check logs for details.',
      name: 'componentsSessionsCurrentUserListeningSessionsTabFailedToDeleteSessionSCheck',
      desc: '',
      args: [p1],
    );
  }

  /// `No active user.`
  String get componentsSessionsCurrentUserListeningSessionsTabNoActiveUser {
    return Intl.message(
      'No active user.',
      name: 'componentsSessionsCurrentUserListeningSessionsTabNoActiveUser',
      desc: '',
      args: [],
    );
  }

  /// `{p1} selected`
  String componentsSessionsCurrentUserListeningSessionsTabSelected(Object p1) {
    return Intl.message(
      '$p1 selected',
      name: 'componentsSessionsCurrentUserListeningSessionsTabSelected',
      desc: '',
      args: [p1],
    );
  }

  /// `Delete Selected`
  String get componentsSessionsCurrentUserListeningSessionsTabDeleteSelected {
    return Intl.message(
      'Delete Selected',
      name: 'componentsSessionsCurrentUserListeningSessionsTabDeleteSelected',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user: {error}`
  String componentsSessionsCurrentUserListeningSessionsTabFailedToLoadUser(Object error) {
    return Intl.message(
      'Failed to load user: $error',
      name: 'componentsSessionsCurrentUserListeningSessionsTabFailedToLoadUser',
      desc: '',
      args: [error],
    );
  }

  /// `Delete Selected Sessions`
  String get componentsSessionsLibraryItemListeningSessionsTabDeleteSelectedSessions {
    return Intl.message(
      'Delete Selected Sessions',
      name: 'componentsSessionsLibraryItemListeningSessionsTabDeleteSelectedSessions',
      desc: '',
      args: [],
    );
  }

  /// `Delete {p1} selected session(s)? This cannot be undone.`
  String componentsSessionsLibraryItemListeningSessionsTabDeleteSelectedSessionSThisCannot(Object p1) {
    return Intl.message(
      'Delete $p1 selected session(s)? This cannot be undone.',
      name: 'componentsSessionsLibraryItemListeningSessionsTabDeleteSelectedSessionSThisCannot',
      desc: '',
      args: [p1],
    );
  }

  /// `Cancel`
  String get componentsSessionsLibraryItemListeningSessionsTabCancel {
    return Intl.message('Cancel', name: 'componentsSessionsLibraryItemListeningSessionsTabCancel', desc: '', args: []);
  }

  /// `Delete`
  String get componentsSessionsLibraryItemListeningSessionsTabDelete {
    return Intl.message('Delete', name: 'componentsSessionsLibraryItemListeningSessionsTabDelete', desc: '', args: []);
  }

  /// `Deleted {deletedCount} session(s).`
  String componentsSessionsLibraryItemListeningSessionsTabDeletedSessionS(Object deletedCount) {
    return Intl.message(
      'Deleted $deletedCount session(s).',
      name: 'componentsSessionsLibraryItemListeningSessionsTabDeletedSessionS',
      desc: '',
      args: [deletedCount],
    );
  }

  /// `Failed to delete {p1} session(s). Check logs for details.`
  String componentsSessionsLibraryItemListeningSessionsTabFailedToDeleteSessionSCheck(Object p1) {
    return Intl.message(
      'Failed to delete $p1 session(s). Check logs for details.',
      name: 'componentsSessionsLibraryItemListeningSessionsTabFailedToDeleteSessionSCheck',
      desc: '',
      args: [p1],
    );
  }

  /// `No active user.`
  String get componentsSessionsLibraryItemListeningSessionsTabNoActiveUser {
    return Intl.message(
      'No active user.',
      name: 'componentsSessionsLibraryItemListeningSessionsTabNoActiveUser',
      desc: '',
      args: [],
    );
  }

  /// `All Episodes`
  String get componentsSessionsLibraryItemListeningSessionsTabAllEpisodes {
    return Intl.message(
      'All Episodes',
      name: 'componentsSessionsLibraryItemListeningSessionsTabAllEpisodes',
      desc: '',
      args: [],
    );
  }

  /// `{p1} selected`
  String componentsSessionsLibraryItemListeningSessionsTabSelected(Object p1) {
    return Intl.message(
      '$p1 selected',
      name: 'componentsSessionsLibraryItemListeningSessionsTabSelected',
      desc: '',
      args: [p1],
    );
  }

  /// `Delete Selected`
  String get componentsSessionsLibraryItemListeningSessionsTabDeleteSelected {
    return Intl.message(
      'Delete Selected',
      name: 'componentsSessionsLibraryItemListeningSessionsTabDeleteSelected',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user: {error}`
  String componentsSessionsLibraryItemListeningSessionsTabFailedToLoadUser(Object error) {
    return Intl.message(
      'Failed to load user: $error',
      name: 'componentsSessionsLibraryItemListeningSessionsTabFailedToLoadUser',
      desc: '',
      args: [error],
    );
  }

  /// `Filter by Episode`
  String get componentsSessionsLibraryItemListeningSessionsTabFilterByEpisode {
    return Intl.message(
      'Filter by Episode',
      name: 'componentsSessionsLibraryItemListeningSessionsTabFilterByEpisode',
      desc: '',
      args: [],
    );
  }

  /// `Delete Session`
  String get componentsSessionsListeningSessionEditorDialogDeleteSession {
    return Intl.message(
      'Delete Session',
      name: 'componentsSessionsListeningSessionEditorDialogDeleteSession',
      desc: '',
      args: [],
    );
  }

  /// `Delete this session permanently? This cannot be undone.`
  String get componentsSessionsListeningSessionEditorDialogDeleteThisSessionPermanentlyThisCannot {
    return Intl.message(
      'Delete this session permanently? This cannot be undone.',
      name: 'componentsSessionsListeningSessionEditorDialogDeleteThisSessionPermanentlyThisCannot',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get componentsSessionsListeningSessionEditorDialogCancel {
    return Intl.message('Cancel', name: 'componentsSessionsListeningSessionEditorDialogCancel', desc: '', args: []);
  }

  /// `Delete`
  String get componentsSessionsListeningSessionEditorDialogDelete {
    return Intl.message('Delete', name: 'componentsSessionsListeningSessionEditorDialogDelete', desc: '', args: []);
  }

  /// `Close`
  String get componentsSessionsListeningSessionEditorDialogClose {
    return Intl.message('Close', name: 'componentsSessionsListeningSessionEditorDialogClose', desc: '', args: []);
  }

  /// `Save`
  String get componentsSessionsListeningSessionEditorDialogSave {
    return Intl.message('Save', name: 'componentsSessionsListeningSessionEditorDialogSave', desc: '', args: []);
  }

  /// `Total: {total}`
  String componentsSessionsListeningSessionsPaginationControlsTotal(Object total) {
    return Intl.message(
      'Total: $total',
      name: 'componentsSessionsListeningSessionsPaginationControlsTotal',
      desc: '',
      args: [total],
    );
  }

  /// `Page {currentPage} / {clampedPages}`
  String componentsSessionsListeningSessionsPaginationControlsPage(Object clampedPages, Object currentPage) {
    return Intl.message(
      'Page $currentPage / $clampedPages',
      name: 'componentsSessionsListeningSessionsPaginationControlsPage',
      desc: '',
      args: [clampedPages, currentPage],
    );
  }

  /// `Per page:`
  String get componentsSessionsListeningSessionsPaginationControlsPerPage {
    return Intl.message(
      'Per page:',
      name: 'componentsSessionsListeningSessionsPaginationControlsPerPage',
      desc: '',
      args: [],
    );
  }

  /// `Previous page`
  String get componentsSessionsListeningSessionsPaginationControlsPreviousPage {
    return Intl.message(
      'Previous page',
      name: 'componentsSessionsListeningSessionsPaginationControlsPreviousPage',
      desc: '',
      args: [],
    );
  }

  /// `Next page`
  String get componentsSessionsListeningSessionsPaginationControlsNextPage {
    return Intl.message(
      'Next page',
      name: 'componentsSessionsListeningSessionsPaginationControlsNextPage',
      desc: '',
      args: [],
    );
  }

  /// `Delete Shared Session`
  String get componentsSessionsOpenShareSessionDialogDeleteSharedSession {
    return Intl.message(
      'Delete Shared Session',
      name: 'componentsSessionsOpenShareSessionDialogDeleteSharedSession',
      desc: '',
      args: [],
    );
  }

  /// `Delete this shared session permanently? This cannot be undone.`
  String get componentsSessionsOpenShareSessionDialogDeleteThisSharedSessionPermanentlyThis {
    return Intl.message(
      'Delete this shared session permanently? This cannot be undone.',
      name: 'componentsSessionsOpenShareSessionDialogDeleteThisSharedSessionPermanentlyThis',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get componentsSessionsOpenShareSessionDialogCancel {
    return Intl.message('Cancel', name: 'componentsSessionsOpenShareSessionDialogCancel', desc: '', args: []);
  }

  /// `Delete`
  String get componentsSessionsOpenShareSessionDialogDelete {
    return Intl.message('Delete', name: 'componentsSessionsOpenShareSessionDialogDelete', desc: '', args: []);
  }

  /// `Shared Session`
  String get componentsSessionsOpenShareSessionDialogSharedSession {
    return Intl.message(
      'Shared Session',
      name: 'componentsSessionsOpenShareSessionDialogSharedSession',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get componentsSessionsOpenShareSessionDialogClose {
    return Intl.message('Close', name: 'componentsSessionsOpenShareSessionDialogClose', desc: '', args: []);
  }

  /// `Cancel`
  String get componentsSessionsSessionDurationPickerFieldCancel {
    return Intl.message('Cancel', name: 'componentsSessionsSessionDurationPickerFieldCancel', desc: '', args: []);
  }

  /// `Set`
  String get componentsSessionsSessionDurationPickerFieldSet {
    return Intl.message('Set', name: 'componentsSessionsSessionDurationPickerFieldSet', desc: '', args: []);
  }

  /// `Added provider "{name}".`
  String componentsSettingsAdminCustomMetadataProviderManagerAddedProvider(Object name) {
    return Intl.message(
      'Added provider "$name".',
      name: 'componentsSettingsAdminCustomMetadataProviderManagerAddedProvider',
      desc: '',
      args: [name],
    );
  }

  /// `Updated provider "{name}".`
  String componentsSettingsAdminCustomMetadataProviderManagerUpdatedProvider(Object name) {
    return Intl.message(
      'Updated provider "$name".',
      name: 'componentsSettingsAdminCustomMetadataProviderManagerUpdatedProvider',
      desc: '',
      args: [name],
    );
  }

  /// `Deleted provider "{p1}".`
  String componentsSettingsAdminCustomMetadataProviderManagerDeletedProvider(Object p1) {
    return Intl.message(
      'Deleted provider "$p1".',
      name: 'componentsSettingsAdminCustomMetadataProviderManagerDeletedProvider',
      desc: '',
      args: [p1],
    );
  }

  /// `Add`
  String get componentsSettingsAdminCustomMetadataProviderManagerAdd {
    return Intl.message('Add', name: 'componentsSettingsAdminCustomMetadataProviderManagerAdd', desc: '', args: []);
  }

  /// `No custom metadata providers found.`
  String get componentsSettingsAdminCustomMetadataProviderManagerNoCustomMetadataProvidersFound {
    return Intl.message(
      'No custom metadata providers found.',
      name: 'componentsSettingsAdminCustomMetadataProviderManagerNoCustomMetadataProvidersFound',
      desc: '',
      args: [],
    );
  }

  /// `Auth header configured`
  String get componentsSettingsAdminCustomMetadataProviderManagerAuthHeaderConfigured {
    return Intl.message(
      'Auth header configured',
      name: 'componentsSettingsAdminCustomMetadataProviderManagerAuthHeaderConfigured',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get componentsSettingsAdminCustomMetadataProviderManagerCancel {
    return Intl.message(
      'Cancel',
      name: 'componentsSettingsAdminCustomMetadataProviderManagerCancel',
      desc: '',
      args: [],
    );
  }

  /// `Refresh providers`
  String get componentsSettingsAdminCustomMetadataProviderManagerRefreshProviders {
    return Intl.message(
      'Refresh providers',
      name: 'componentsSettingsAdminCustomMetadataProviderManagerRefreshProviders',
      desc: '',
      args: [],
    );
  }

  /// `Edit provider`
  String get componentsSettingsAdminCustomMetadataProviderManagerEditProvider {
    return Intl.message(
      'Edit provider',
      name: 'componentsSettingsAdminCustomMetadataProviderManagerEditProvider',
      desc: '',
      args: [],
    );
  }

  /// `Delete provider`
  String get componentsSettingsAdminCustomMetadataProviderManagerDeleteProvider {
    return Intl.message(
      'Delete provider',
      name: 'componentsSettingsAdminCustomMetadataProviderManagerDeleteProvider',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get componentsSettingsAdminCustomMetadataProviderManagerName {
    return Intl.message('Name', name: 'componentsSettingsAdminCustomMetadataProviderManagerName', desc: '', args: []);
  }

  /// `URL`
  String get componentsSettingsAdminCustomMetadataProviderManagerUrl {
    return Intl.message('URL', name: 'componentsSettingsAdminCustomMetadataProviderManagerUrl', desc: '', args: []);
  }

  /// `https://example.com/path`
  String get componentsSettingsAdminCustomMetadataProviderManagerHttpsExampleComPath {
    return Intl.message(
      'https://example.com/path',
      name: 'componentsSettingsAdminCustomMetadataProviderManagerHttpsExampleComPath',
      desc: '',
      args: [],
    );
  }

  /// `Auth Header Value`
  String get componentsSettingsAdminCustomMetadataProviderManagerAuthHeaderValue {
    return Intl.message(
      'Auth Header Value',
      name: 'componentsSettingsAdminCustomMetadataProviderManagerAuthHeaderValue',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get componentsSettingsAdminCustomMetadataProviderManagerOptional {
    return Intl.message(
      'Optional',
      name: 'componentsSettingsAdminCustomMetadataProviderManagerOptional',
      desc: '',
      args: [],
    );
  }

  /// `Force metadata refresh`
  String get componentsSettingsAdminForceMetadataRefreshToolForceMetadataRefresh {
    return Intl.message(
      'Force metadata refresh',
      name: 'componentsSettingsAdminForceMetadataRefreshToolForceMetadataRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Recreates the metadata.json files for all items`
  String get componentsSettingsAdminForceMetadataRefreshToolRecreatesTheMetadataJsonFilesFor {
    return Intl.message(
      'Recreates the metadata.json files for all items',
      name: 'componentsSettingsAdminForceMetadataRefreshToolRecreatesTheMetadataJsonFilesFor',
      desc: '',
      args: [],
    );
  }

  /// `Run`
  String get componentsSettingsAdminForceMetadataRefreshToolRun {
    return Intl.message('Run', name: 'componentsSettingsAdminForceMetadataRefreshToolRun', desc: '', args: []);
  }

  /// `No active API client.`
  String get componentsSettingsAdminForceMetadataRefreshToolNoActiveAPIClient {
    return Intl.message(
      'No active API client.',
      name: 'componentsSettingsAdminForceMetadataRefreshToolNoActiveAPIClient',
      desc: '',
      args: [],
    );
  }

  /// `Force Metadata Refresh`
  String get componentsSettingsAdminForceMetadataRefreshToolForceMetadataRefresh2 {
    return Intl.message(
      'Force Metadata Refresh',
      name: 'componentsSettingsAdminForceMetadataRefreshToolForceMetadataRefresh2',
      desc: '',
      args: [],
    );
  }

  /// `This tool appends the "force-metadata" tag to every item in the selected libraries, performs a batch update, then removes the tag via the remove endpoint.`
  String get componentsSettingsAdminForceMetadataRefreshToolThisToolAppendsTheForceMetadata {
    return Intl.message(
      'This tool appends the "force-metadata" tag to every item in the selected libraries, performs a batch update, then removes the tag via the remove endpoint.',
      name: 'componentsSettingsAdminForceMetadataRefreshToolThisToolAppendsTheForceMetadata',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get componentsSettingsAdminForceMetadataRefreshToolCancel {
    return Intl.message('Cancel', name: 'componentsSettingsAdminForceMetadataRefreshToolCancel', desc: '', args: []);
  }

  /// `No active user. Sign in to manage item metadata utilities.`
  String get componentsSettingsAdminItemMetadataUtilsViewNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to manage item metadata utilities.',
      name: 'componentsSettingsAdminItemMetadataUtilsViewNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `This page requires an admin account.`
  String get componentsSettingsAdminItemMetadataUtilsViewThisPageRequiresAnAdminAccount {
    return Intl.message(
      'This page requires an admin account.',
      name: 'componentsSettingsAdminItemMetadataUtilsViewThisPageRequiresAnAdminAccount',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user data: {error}`
  String componentsSettingsAdminItemMetadataUtilsViewFailedToLoadUserData(Object error) {
    return Intl.message(
      'Failed to load user data: $error',
      name: 'componentsSettingsAdminItemMetadataUtilsViewFailedToLoadUserData',
      desc: '',
      args: [error],
    );
  }

  /// `Retry`
  String get componentsSettingsAdminItemMetadataUtilsViewRetry {
    return Intl.message('Retry', name: 'componentsSettingsAdminItemMetadataUtilsViewRetry', desc: '', args: []);
  }

  /// `{rank}.`
  String componentsSettingsAdminLibraryStatsRankedSectionText(Object rank) {
    return Intl.message('$rank.', name: 'componentsSettingsAdminLibraryStatsRankedSectionText', desc: '', args: [rank]);
  }

  /// `Rename {p1}`
  String componentsSettingsAdminMetadataTermManagerRename(Object p1) {
    return Intl.message('Rename $p1', name: 'componentsSettingsAdminMetadataTermManagerRename', desc: '', args: [p1]);
  }

  /// `Cancel`
  String get componentsSettingsAdminMetadataTermManagerCancel {
    return Intl.message('Cancel', name: 'componentsSettingsAdminMetadataTermManagerCancel', desc: '', args: []);
  }

  /// `Save`
  String get componentsSettingsAdminMetadataTermManagerSave {
    return Intl.message('Save', name: 'componentsSettingsAdminMetadataTermManagerSave', desc: '', args: []);
  }

  /// `Updated {updatedCount} item(s).{mergeMessage}`
  String componentsSettingsAdminMetadataTermManagerUpdatedItemS(Object mergeMessage, Object updatedCount) {
    return Intl.message(
      'Updated $updatedCount item(s).$mergeMessage',
      name: 'componentsSettingsAdminMetadataTermManagerUpdatedItemS',
      desc: '',
      args: [mergeMessage, updatedCount],
    );
  }

  /// `Updated {p1} item(s).`
  String componentsSettingsAdminMetadataTermManagerUpdatedItemS2(Object p1) {
    return Intl.message(
      'Updated $p1 item(s).',
      name: 'componentsSettingsAdminMetadataTermManagerUpdatedItemS2',
      desc: '',
      args: [p1],
    );
  }

  /// `Refresh {p1}s`
  String componentsSettingsAdminMetadataTermManagerRefreshS(Object p1) {
    return Intl.message(
      'Refresh ${p1}s',
      name: 'componentsSettingsAdminMetadataTermManagerRefreshS',
      desc: '',
      args: [p1],
    );
  }

  /// `Delete {p1}`
  String componentsSettingsAdminMetadataTermManagerDelete(Object p1) {
    return Intl.message('Delete $p1', name: 'componentsSettingsAdminMetadataTermManagerDelete', desc: '', args: [p1]);
  }

  /// `Name`
  String get componentsSettingsAdminMetadataTermManagerName {
    return Intl.message('Name', name: 'componentsSettingsAdminMetadataTermManagerName', desc: '', args: []);
  }

  /// `No active user. Sign in to view library stats.`
  String get componentsSettingsAdminServerLibraryStatsViewNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to view library stats.',
      name: 'componentsSettingsAdminServerLibraryStatsViewNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `This page requires an admin account.`
  String get componentsSettingsAdminServerLibraryStatsViewThisPageRequiresAnAdminAccount {
    return Intl.message(
      'This page requires an admin account.',
      name: 'componentsSettingsAdminServerLibraryStatsViewThisPageRequiresAnAdminAccount',
      desc: '',
      args: [],
    );
  }

  /// `Select a library from the main view to inspect its stats.`
  String get componentsSettingsAdminServerLibraryStatsViewSelectALibraryFromTheMain {
    return Intl.message(
      'Select a library from the main view to inspect its stats.',
      name: 'componentsSettingsAdminServerLibraryStatsViewSelectALibraryFromTheMain',
      desc: '',
      args: [],
    );
  }

  /// `No stats available for the selected library.`
  String get componentsSettingsAdminServerLibraryStatsViewNoStatsAvailableForTheSelected {
    return Intl.message(
      'No stats available for the selected library.',
      name: 'componentsSettingsAdminServerLibraryStatsViewNoStatsAvailableForTheSelected',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user data: {error}`
  String componentsSettingsAdminServerLibraryStatsViewFailedToLoadUserData(Object error) {
    return Intl.message(
      'Failed to load user data: $error',
      name: 'componentsSettingsAdminServerLibraryStatsViewFailedToLoadUserData',
      desc: '',
      args: [error],
    );
  }

  /// `Retry`
  String get componentsSettingsAdminServerLibraryStatsViewRetry {
    return Intl.message('Retry', name: 'componentsSettingsAdminServerLibraryStatsViewRetry', desc: '', args: []);
  }

  /// `Refresh stats`
  String get componentsSettingsAdminServerLibraryStatsViewRefreshStats {
    return Intl.message(
      'Refresh stats',
      name: 'componentsSettingsAdminServerLibraryStatsViewRefreshStats',
      desc: '',
      args: [],
    );
  }

  /// `No active user. Sign in to view server logs.`
  String get componentsSettingsAdminServerLogsViewNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to view server logs.',
      name: 'componentsSettingsAdminServerLogsViewNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `This page requires an admin account.`
  String get componentsSettingsAdminServerLogsViewThisPageRequiresAnAdminAccount {
    return Intl.message(
      'This page requires an admin account.',
      name: 'componentsSettingsAdminServerLogsViewThisPageRequiresAnAdminAccount',
      desc: '',
      args: [],
    );
  }

  /// `Auto-scroll`
  String get componentsSettingsAdminServerLogsViewAutoScroll {
    return Intl.message('Auto-scroll', name: 'componentsSettingsAdminServerLogsViewAutoScroll', desc: '', args: []);
  }

  /// `No logs found for the current search.`
  String get componentsSettingsAdminServerLogsViewNoLogsFoundForTheCurrent {
    return Intl.message(
      'No logs found for the current search.',
      name: 'componentsSettingsAdminServerLogsViewNoLogsFoundForTheCurrent',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user data: {error}`
  String componentsSettingsAdminServerLogsViewFailedToLoadUserData(Object error) {
    return Intl.message(
      'Failed to load user data: $error',
      name: 'componentsSettingsAdminServerLogsViewFailedToLoadUserData',
      desc: '',
      args: [error],
    );
  }

  /// `Search logs`
  String get componentsSettingsAdminServerLogsViewSearchLogs {
    return Intl.message('Search logs', name: 'componentsSettingsAdminServerLogsViewSearchLogs', desc: '', args: []);
  }

  /// `Server Log Level`
  String get componentsSettingsAdminServerLogsViewServerLogLevel {
    return Intl.message(
      'Server Log Level',
      name: 'componentsSettingsAdminServerLogsViewServerLogLevel',
      desc: '',
      args: [],
    );
  }

  /// `Delete Selected Sessions`
  String get componentsSettingsAdminServerSessionsViewDeleteSelectedSessions {
    return Intl.message(
      'Delete Selected Sessions',
      name: 'componentsSettingsAdminServerSessionsViewDeleteSelectedSessions',
      desc: '',
      args: [],
    );
  }

  /// `Delete {p1} selected session(s)? This cannot be undone.`
  String componentsSettingsAdminServerSessionsViewDeleteSelectedSessionSThisCannot(Object p1) {
    return Intl.message(
      'Delete $p1 selected session(s)? This cannot be undone.',
      name: 'componentsSettingsAdminServerSessionsViewDeleteSelectedSessionSThisCannot',
      desc: '',
      args: [p1],
    );
  }

  /// `Cancel`
  String get componentsSettingsAdminServerSessionsViewCancel {
    return Intl.message('Cancel', name: 'componentsSettingsAdminServerSessionsViewCancel', desc: '', args: []);
  }

  /// `Delete`
  String get componentsSettingsAdminServerSessionsViewDelete {
    return Intl.message('Delete', name: 'componentsSettingsAdminServerSessionsViewDelete', desc: '', args: []);
  }

  /// `Deleted {deletedCount} session(s).`
  String componentsSettingsAdminServerSessionsViewDeletedSessionS(Object deletedCount) {
    return Intl.message(
      'Deleted $deletedCount session(s).',
      name: 'componentsSettingsAdminServerSessionsViewDeletedSessionS',
      desc: '',
      args: [deletedCount],
    );
  }

  /// `Failed to delete {p1} session(s). Check logs for details.`
  String componentsSettingsAdminServerSessionsViewFailedToDeleteSessionSCheck(Object p1) {
    return Intl.message(
      'Failed to delete $p1 session(s). Check logs for details.',
      name: 'componentsSettingsAdminServerSessionsViewFailedToDeleteSessionSCheck',
      desc: '',
      args: [p1],
    );
  }

  /// `Retry`
  String get componentsSettingsAdminServerSessionsViewRetry {
    return Intl.message('Retry', name: 'componentsSettingsAdminServerSessionsViewRetry', desc: '', args: []);
  }

  /// `{p1} selected`
  String componentsSettingsAdminServerSessionsViewSelected(Object p1) {
    return Intl.message(
      '$p1 selected',
      name: 'componentsSettingsAdminServerSessionsViewSelected',
      desc: '',
      args: [p1],
    );
  }

  /// `Delete Selected`
  String get componentsSettingsAdminServerSessionsViewDeleteSelected {
    return Intl.message(
      'Delete Selected',
      name: 'componentsSettingsAdminServerSessionsViewDeleteSelected',
      desc: '',
      args: [],
    );
  }

  /// `No shared sessions found.`
  String get componentsSettingsAdminServerSessionsViewNoSharedSessionsFound {
    return Intl.message(
      'No shared sessions found.',
      name: 'componentsSettingsAdminServerSessionsViewNoSharedSessionsFound',
      desc: '',
      args: [],
    );
  }

  /// `No active user. Sign in to manage sessions.`
  String get componentsSettingsAdminServerSessionsViewNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to manage sessions.',
      name: 'componentsSettingsAdminServerSessionsViewNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `This page requires an admin account.`
  String get componentsSettingsAdminServerSessionsViewThisPageRequiresAnAdminAccount {
    return Intl.message(
      'This page requires an admin account.',
      name: 'componentsSettingsAdminServerSessionsViewThisPageRequiresAnAdminAccount',
      desc: '',
      args: [],
    );
  }

  /// `All Users`
  String get componentsSettingsAdminServerSessionsViewAllUsers {
    return Intl.message('All Users', name: 'componentsSettingsAdminServerSessionsViewAllUsers', desc: '', args: []);
  }

  /// `Failed to load user data: {error}`
  String componentsSettingsAdminServerSessionsViewFailedToLoadUserData(Object error) {
    return Intl.message(
      'Failed to load user data: $error',
      name: 'componentsSettingsAdminServerSessionsViewFailedToLoadUserData',
      desc: '',
      args: [error],
    );
  }

  /// `Refresh sessions`
  String get componentsSettingsAdminServerSessionsViewRefreshSessions {
    return Intl.message(
      'Refresh sessions',
      name: 'componentsSettingsAdminServerSessionsViewRefreshSessions',
      desc: '',
      args: [],
    );
  }

  /// `Filter by User`
  String get componentsSettingsAdminServerSessionsViewFilterByUser {
    return Intl.message(
      'Filter by User',
      name: 'componentsSettingsAdminServerSessionsViewFilterByUser',
      desc: '',
      args: [],
    );
  }

  /// `Delete User`
  String get componentsSettingsAdminServerUsersViewDeleteUser {
    return Intl.message('Delete User', name: 'componentsSettingsAdminServerUsersViewDeleteUser', desc: '', args: []);
  }

  /// `Delete user "{p1}"? This cannot be undone.`
  String componentsSettingsAdminServerUsersViewDeleteUserThisCannotBeUndone(Object p1) {
    return Intl.message(
      'Delete user "$p1"? This cannot be undone.',
      name: 'componentsSettingsAdminServerUsersViewDeleteUserThisCannotBeUndone',
      desc: '',
      args: [p1],
    );
  }

  /// `Cancel`
  String get componentsSettingsAdminServerUsersViewCancel {
    return Intl.message('Cancel', name: 'componentsSettingsAdminServerUsersViewCancel', desc: '', args: []);
  }

  /// `Delete`
  String get componentsSettingsAdminServerUsersViewDelete {
    return Intl.message('Delete', name: 'componentsSettingsAdminServerUsersViewDelete', desc: '', args: []);
  }

  /// `Retry`
  String get componentsSettingsAdminServerUsersViewRetry {
    return Intl.message('Retry', name: 'componentsSettingsAdminServerUsersViewRetry', desc: '', args: []);
  }

  /// `Add user`
  String get componentsSettingsAdminServerUsersViewAddUser {
    return Intl.message('Add user', name: 'componentsSettingsAdminServerUsersViewAddUser', desc: '', args: []);
  }

  /// `Refresh`
  String get componentsSettingsAdminServerUsersViewRefresh {
    return Intl.message('Refresh', name: 'componentsSettingsAdminServerUsersViewRefresh', desc: '', args: []);
  }

  /// `No active user. Sign in to manage users.`
  String get componentsSettingsAdminServerUsersViewNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to manage users.',
      name: 'componentsSettingsAdminServerUsersViewNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `This page requires an admin account.`
  String get componentsSettingsAdminServerUsersViewThisPageRequiresAnAdminAccount {
    return Intl.message(
      'This page requires an admin account.',
      name: 'componentsSettingsAdminServerUsersViewThisPageRequiresAnAdminAccount',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user data: {error}`
  String componentsSettingsAdminServerUsersViewFailedToLoadUserData(Object error) {
    return Intl.message(
      'Failed to load user data: $error',
      name: 'componentsSettingsAdminServerUsersViewFailedToLoadUserData',
      desc: '',
      args: [error],
    );
  }

  /// `Search users`
  String get componentsSettingsAdminServerUsersViewSearchUsers {
    return Intl.message('Search users', name: 'componentsSettingsAdminServerUsersViewSearchUsers', desc: '', args: []);
  }

  /// `No active API client.`
  String get componentsSettingsAdminSplitMetadataTermsToolNoActiveAPIClient {
    return Intl.message(
      'No active API client.',
      name: 'componentsSettingsAdminSplitMetadataTermsToolNoActiveAPIClient',
      desc: '',
      args: [],
    );
  }

  /// `This tool splits combined {_noun} values using the delimiter below and updates affected items in the selected libraries.`
  String componentsSettingsAdminSplitMetadataTermsToolThisToolSplitsCombinedValuesUsing(Object _noun) {
    return Intl.message(
      'This tool splits combined {_noun} values using the delimiter below and updates affected items in the selected libraries.',
      name: 'componentsSettingsAdminSplitMetadataTermsToolThisToolSplitsCombinedValuesUsing',
      desc: '',
      args: [_noun],
    );
  }

  /// `Cancel`
  String get componentsSettingsAdminSplitMetadataTermsToolCancel {
    return Intl.message('Cancel', name: 'componentsSettingsAdminSplitMetadataTermsToolCancel', desc: '', args: []);
  }

  /// `Delimiter`
  String get componentsSettingsAdminSplitMetadataTermsToolDelimiter {
    return Intl.message(
      'Delimiter',
      name: 'componentsSettingsAdminSplitMetadataTermsToolDelimiter',
      desc: '',
      args: [],
    );
  }

  /// `Example: "," splits "Fantasy, Sci-Fi" into two values.`
  String get componentsSettingsAdminSplitMetadataTermsToolExampleSplitsFantasySciFiInto {
    return Intl.message(
      'Example: "," splits "Fantasy, Sci-Fi" into two values.',
      name: 'componentsSettingsAdminSplitMetadataTermsToolExampleSplitsFantasySciFiInto',
      desc: '',
      args: [],
    );
  }

  /// `Target libraries`
  String get componentsSettingsAdminToolLibrarySelectorTargetLibraries {
    return Intl.message(
      'Target libraries',
      name: 'componentsSettingsAdminToolLibrarySelectorTargetLibraries',
      desc: '',
      args: [],
    );
  }

  /// `{p1}/{p2}`
  String componentsSettingsAdminToolLibrarySelectorText(Object p1, Object p2) {
    return Intl.message('$p1/$p2', name: 'componentsSettingsAdminToolLibrarySelectorText', desc: '', args: [p1, p2]);
  }

  /// `Select all`
  String get componentsSettingsAdminToolLibrarySelectorSelectAll {
    return Intl.message('Select all', name: 'componentsSettingsAdminToolLibrarySelectorSelectAll', desc: '', args: []);
  }

  /// `Clear all`
  String get componentsSettingsAdminToolLibrarySelectorClearAll {
    return Intl.message('Clear all', name: 'componentsSettingsAdminToolLibrarySelectorClearAll', desc: '', args: []);
  }

  /// `No libraries available.`
  String get componentsSettingsAdminToolLibrarySelectorNoLibrariesAvailable {
    return Intl.message(
      'No libraries available.',
      name: 'componentsSettingsAdminToolLibrarySelectorNoLibrariesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get componentsSettingsAdminUsersAdminUserFormDialogAccount {
    return Intl.message('Account', name: 'componentsSettingsAdminUsersAdminUserFormDialogAccount', desc: '', args: []);
  }

  /// `User is active`
  String get componentsSettingsAdminUsersAdminUserFormDialogUserIsActive {
    return Intl.message(
      'User is active',
      name: 'componentsSettingsAdminUsersAdminUserFormDialogUserIsActive',
      desc: '',
      args: [],
    );
  }

  /// `Library and Tag Access`
  String get componentsSettingsAdminUsersAdminUserFormDialogLibraryAndTagAccess {
    return Intl.message(
      'Library and Tag Access',
      name: 'componentsSettingsAdminUsersAdminUserFormDialogLibraryAndTagAccess',
      desc: '',
      args: [],
    );
  }

  /// `Can access all libraries`
  String get componentsSettingsAdminUsersAdminUserFormDialogCanAccessAllLibraries {
    return Intl.message(
      'Can access all libraries',
      name: 'componentsSettingsAdminUsersAdminUserFormDialogCanAccessAllLibraries',
      desc: '',
      args: [],
    );
  }

  /// `Can access all tags`
  String get componentsSettingsAdminUsersAdminUserFormDialogCanAccessAllTags {
    return Intl.message(
      'Can access all tags',
      name: 'componentsSettingsAdminUsersAdminUserFormDialogCanAccessAllTags',
      desc: '',
      args: [],
    );
  }

  /// `Invert selected tags`
  String get componentsSettingsAdminUsersAdminUserFormDialogInvertSelectedTags {
    return Intl.message(
      'Invert selected tags',
      name: 'componentsSettingsAdminUsersAdminUserFormDialogInvertSelectedTags',
      desc: '',
      args: [],
    );
  }

  /// `When enabled, selected tags are blocked instead of allowed.`
  String get componentsSettingsAdminUsersAdminUserFormDialogWhenEnabledSelectedTagsAreBlocked {
    return Intl.message(
      'When enabled, selected tags are blocked instead of allowed.',
      name: 'componentsSettingsAdminUsersAdminUserFormDialogWhenEnabledSelectedTagsAreBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Unlink OpenID`
  String get componentsSettingsAdminUsersAdminUserFormDialogUnlinkOpenID {
    return Intl.message(
      'Unlink OpenID',
      name: 'componentsSettingsAdminUsersAdminUserFormDialogUnlinkOpenID',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get componentsSettingsAdminUsersAdminUserFormDialogCancel {
    return Intl.message('Cancel', name: 'componentsSettingsAdminUsersAdminUserFormDialogCancel', desc: '', args: []);
  }

  /// `Close`
  String get componentsSettingsAdminUsersAdminUserFormDialogClose {
    return Intl.message('Close', name: 'componentsSettingsAdminUsersAdminUserFormDialogClose', desc: '', args: []);
  }

  /// `Username`
  String get componentsSettingsAdminUsersAdminUserFormDialogUsername {
    return Intl.message(
      'Username',
      name: 'componentsSettingsAdminUsersAdminUserFormDialogUsername',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get componentsSettingsAdminUsersAdminUserFormDialogEmail {
    return Intl.message('Email', name: 'componentsSettingsAdminUsersAdminUserFormDialogEmail', desc: '', args: []);
  }

  /// `Account type`
  String get componentsSettingsAdminUsersAdminUserFormDialogAccountType {
    return Intl.message(
      'Account type',
      name: 'componentsSettingsAdminUsersAdminUserFormDialogAccountType',
      desc: '',
      args: [],
    );
  }

  /// `Edit user`
  String get componentsSettingsAdminUsersAdminUserListTileEditUser {
    return Intl.message('Edit user', name: 'componentsSettingsAdminUsersAdminUserListTileEditUser', desc: '', args: []);
  }

  /// `Unlink OpenID`
  String get componentsSettingsAdminUsersAdminUserListTileUnlinkOpenID {
    return Intl.message(
      'Unlink OpenID',
      name: 'componentsSettingsAdminUsersAdminUserListTileUnlinkOpenID',
      desc: '',
      args: [],
    );
  }

  /// `Delete user`
  String get componentsSettingsAdminUsersAdminUserListTileDeleteUser {
    return Intl.message(
      'Delete user',
      name: 'componentsSettingsAdminUsersAdminUserListTileDeleteUser',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get componentsSettingsAdminUsersAdminUserListTileEdit {
    return Intl.message('Edit', name: 'componentsSettingsAdminUsersAdminUserListTileEdit', desc: '', args: []);
  }

  /// `Delete`
  String get componentsSettingsAdminUsersAdminUserListTileDelete {
    return Intl.message('Delete', name: 'componentsSettingsAdminUsersAdminUserListTileDelete', desc: '', args: []);
  }

  /// `{p1}/{p2}`
  String componentsSettingsAdminUsersAdminUserMultiSelectCardText(Object p1, Object p2) {
    return Intl.message(
      '$p1/$p2',
      name: 'componentsSettingsAdminUsersAdminUserMultiSelectCardText',
      desc: '',
      args: [p1, p2],
    );
  }

  /// `Select all`
  String get componentsSettingsAdminUsersAdminUserMultiSelectCardSelectAll {
    return Intl.message(
      'Select all',
      name: 'componentsSettingsAdminUsersAdminUserMultiSelectCardSelectAll',
      desc: '',
      args: [],
    );
  }

  /// `Clear all`
  String get componentsSettingsAdminUsersAdminUserMultiSelectCardClearAll {
    return Intl.message(
      'Clear all',
      name: 'componentsSettingsAdminUsersAdminUserMultiSelectCardClearAll',
      desc: '',
      args: [],
    );
  }

  /// `Permissions`
  String get componentsSettingsAdminUsersAdminUserPermissionsEditorPermissions {
    return Intl.message(
      'Permissions',
      name: 'componentsSettingsAdminUsersAdminUserPermissionsEditorPermissions',
      desc: '',
      args: [],
    );
  }

  /// `Can download`
  String get componentsSettingsAdminUsersAdminUserPermissionsEditorCanDownload {
    return Intl.message(
      'Can download',
      name: 'componentsSettingsAdminUsersAdminUserPermissionsEditorCanDownload',
      desc: '',
      args: [],
    );
  }

  /// `Can update`
  String get componentsSettingsAdminUsersAdminUserPermissionsEditorCanUpdate {
    return Intl.message(
      'Can update',
      name: 'componentsSettingsAdminUsersAdminUserPermissionsEditorCanUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Can delete`
  String get componentsSettingsAdminUsersAdminUserPermissionsEditorCanDelete {
    return Intl.message(
      'Can delete',
      name: 'componentsSettingsAdminUsersAdminUserPermissionsEditorCanDelete',
      desc: '',
      args: [],
    );
  }

  /// `Can upload`
  String get componentsSettingsAdminUsersAdminUserPermissionsEditorCanUpload {
    return Intl.message(
      'Can upload',
      name: 'componentsSettingsAdminUsersAdminUserPermissionsEditorCanUpload',
      desc: '',
      args: [],
    );
  }

  /// `Can create eReader devices`
  String get componentsSettingsAdminUsersAdminUserPermissionsEditorCanCreateEreaderDevices {
    return Intl.message(
      'Can create eReader devices',
      name: 'componentsSettingsAdminUsersAdminUserPermissionsEditorCanCreateEreaderDevices',
      desc: '',
      args: [],
    );
  }

  /// `Can access explicit content`
  String get componentsSettingsAdminUsersAdminUserPermissionsEditorCanAccessExplicitContent {
    return Intl.message(
      'Can access explicit content',
      name: 'componentsSettingsAdminUsersAdminUserPermissionsEditorCanAccessExplicitContent',
      desc: '',
      args: [],
    );
  }

  /// `OpenID flow opened in your browser. Finish sign-in there and return to the app.`
  String get screensAuthSignInOpenidFlowOpenedInYourBrowser {
    return Intl.message(
      'OpenID flow opened in your browser. Finish sign-in there and return to the app.',
      name: 'screensAuthSignInOpenidFlowOpenedInYourBrowser',
      desc: '',
      args: [],
    );
  }

  /// `Yaabsa`
  String get screensAuthSignInYaabsa {
    return Intl.message('Yaabsa', name: 'screensAuthSignInYaabsa', desc: '', args: []);
  }

  /// `Sign in to your Audiobookshelf server`
  String get screensAuthSignInSignInToYourAudiobookshelfServer {
    return Intl.message(
      'Sign in to your Audiobookshelf server',
      name: 'screensAuthSignInSignInToYourAudiobookshelfServer',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get screensAuthSignInBack {
    return Intl.message('Back', name: 'screensAuthSignInBack', desc: '', args: []);
  }

  /// `Server Address`
  String get screensAuthSignInServerAddress {
    return Intl.message('Server Address', name: 'screensAuthSignInServerAddress', desc: '', args: []);
  }

  /// `https://your-audiobookshelf.example`
  String get screensAuthSignInHttpsYourAudiobookshelfExample {
    return Intl.message(
      'https://your-audiobookshelf.example',
      name: 'screensAuthSignInHttpsYourAudiobookshelfExample',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Options`
  String get screensAuthWidgetsSignInAdvancedOptionsAdvancedOptions {
    return Intl.message(
      'Advanced Options',
      name: 'screensAuthWidgetsSignInAdvancedOptionsAdvancedOptions',
      desc: '',
      args: [],
    );
  }

  /// `Use API Key`
  String get screensAuthWidgetsSignInAdvancedOptionsUseAPIKey {
    return Intl.message('Use API Key', name: 'screensAuthWidgetsSignInAdvancedOptionsUseAPIKey', desc: '', args: []);
  }

  /// `Authenticate with a generated API key instead of username/password.`
  String get screensAuthWidgetsSignInAdvancedOptionsAuthenticateWithAGeneratedAPIKey {
    return Intl.message(
      'Authenticate with a generated API key instead of username/password.',
      name: 'screensAuthWidgetsSignInAdvancedOptionsAuthenticateWithAGeneratedAPIKey',
      desc: '',
      args: [],
    );
  }

  /// `Custom Headers`
  String get screensAuthWidgetsSignInAdvancedOptionsCustomHeaders {
    return Intl.message(
      'Custom Headers',
      name: 'screensAuthWidgetsSignInAdvancedOptionsCustomHeaders',
      desc: '',
      args: [],
    );
  }

  /// `Add Header`
  String get screensAuthWidgetsSignInAdvancedOptionsAddHeader {
    return Intl.message('Add Header', name: 'screensAuthWidgetsSignInAdvancedOptionsAddHeader', desc: '', args: []);
  }

  /// `No custom headers configured.`
  String get screensAuthWidgetsSignInAdvancedOptionsNoCustomHeadersConfigured {
    return Intl.message(
      'No custom headers configured.',
      name: 'screensAuthWidgetsSignInAdvancedOptionsNoCustomHeadersConfigured',
      desc: '',
      args: [],
    );
  }

  /// `Edit header`
  String get screensAuthWidgetsSignInAdvancedOptionsEditHeader {
    return Intl.message('Edit header', name: 'screensAuthWidgetsSignInAdvancedOptionsEditHeader', desc: '', args: []);
  }

  /// `Remove header`
  String get screensAuthWidgetsSignInAdvancedOptionsRemoveHeader {
    return Intl.message(
      'Remove header',
      name: 'screensAuthWidgetsSignInAdvancedOptionsRemoveHeader',
      desc: '',
      args: [],
    );
  }

  /// `No supported authentication method is enabled on this server.`
  String get screensAuthWidgetsSignInAuthSectionNoSupportedAuthenticationMethodIsEnabled {
    return Intl.message(
      'No supported authentication method is enabled on this server.',
      name: 'screensAuthWidgetsSignInAuthSectionNoSupportedAuthenticationMethodIsEnabled',
      desc: '',
      args: [],
    );
  }

  /// `API Key`
  String get screensAuthWidgetsSignInAuthSectionApiKey {
    return Intl.message('API Key', name: 'screensAuthWidgetsSignInAuthSectionApiKey', desc: '', args: []);
  }

  /// `Username`
  String get screensAuthWidgetsSignInAuthSectionUsername {
    return Intl.message('Username', name: 'screensAuthWidgetsSignInAuthSectionUsername', desc: '', args: []);
  }

  /// `Password`
  String get screensAuthWidgetsSignInAuthSectionPassword {
    return Intl.message('Password', name: 'screensAuthWidgetsSignInAuthSectionPassword', desc: '', args: []);
  }

  /// `Copied`
  String get screensAuthWidgetsSignInErrorPanelCopied {
    return Intl.message('Copied', name: 'screensAuthWidgetsSignInErrorPanelCopied', desc: '', args: []);
  }

  /// `Cancel`
  String get screensAuthWidgetsSignInHeaderEditorDialogCancel {
    return Intl.message('Cancel', name: 'screensAuthWidgetsSignInHeaderEditorDialogCancel', desc: '', args: []);
  }

  /// `Save`
  String get screensAuthWidgetsSignInHeaderEditorDialogSave {
    return Intl.message('Save', name: 'screensAuthWidgetsSignInHeaderEditorDialogSave', desc: '', args: []);
  }

  /// `Header Name`
  String get screensAuthWidgetsSignInHeaderEditorDialogHeaderName {
    return Intl.message(
      'Header Name',
      name: 'screensAuthWidgetsSignInHeaderEditorDialogHeaderName',
      desc: '',
      args: [],
    );
  }

  /// `Header Value`
  String get screensAuthWidgetsSignInHeaderEditorDialogHeaderValue {
    return Intl.message(
      'Header Value',
      name: 'screensAuthWidgetsSignInHeaderEditorDialogHeaderValue',
      desc: '',
      args: [],
    );
  }

  /// `Header name and value are required.`
  String get screensAuthWidgetsSignInHeaderEditorDialogHeaderNameAndValueAreRequired {
    return Intl.message(
      'Header name and value are required.',
      name: 'screensAuthWidgetsSignInHeaderEditorDialogHeaderNameAndValueAreRequired',
      desc: '',
      args: [],
    );
  }

  /// `A header with this name already exists.`
  String get screensAuthWidgetsSignInHeaderEditorDialogAHeaderWithThisNameAlreadyExists {
    return Intl.message(
      'A header with this name already exists.',
      name: 'screensAuthWidgetsSignInHeaderEditorDialogAHeaderWithThisNameAlreadyExists',
      desc: '',
      args: [],
    );
  }

  /// `Checking server...`
  String get screensAuthWidgetsSignInServerStatusCheckingServer {
    return Intl.message(
      'Checking server...',
      name: 'screensAuthWidgetsSignInServerStatusCheckingServer',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get screensAutomotiveAaosSettingsScaffoldBack {
    return Intl.message('Back', name: 'screensAutomotiveAaosSettingsScaffoldBack', desc: '', args: []);
  }

  /// `Refresh`
  String get screensAutomotiveAaosSettingsScaffoldRefresh {
    return Intl.message('Refresh', name: 'screensAutomotiveAaosSettingsScaffoldRefresh', desc: '', args: []);
  }

  /// `Car Media App`
  String get screensAutomotiveParkedExperienceCarMediaApp {
    return Intl.message('Car Media App', name: 'screensAutomotiveParkedExperienceCarMediaApp', desc: '', args: []);
  }

  /// `Open Media Center`
  String get screensAutomotiveParkedExperienceOpenMediaCenter {
    return Intl.message(
      'Open Media Center',
      name: 'screensAutomotiveParkedExperienceOpenMediaCenter',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get screensAutomotiveParkedExperienceSettings {
    return Intl.message('Settings', name: 'screensAutomotiveParkedExperienceSettings', desc: '', args: []);
  }

  /// `Logout`
  String get screensAutomotiveParkedExperienceLogout {
    return Intl.message('Logout', name: 'screensAutomotiveParkedExperienceLogout', desc: '', args: []);
  }

  /// `Download added to queue.`
  String get screensItemLibraryItemBookViewDownloadAddedToQueue {
    return Intl.message(
      'Download added to queue.',
      name: 'screensItemLibraryItemBookViewDownloadAddedToQueue',
      desc: '',
      args: [],
    );
  }

  /// `Could not start download: {e}`
  String screensItemLibraryItemBookViewCouldNotStartDownload(Object e) {
    return Intl.message(
      'Could not start download: $e',
      name: 'screensItemLibraryItemBookViewCouldNotStartDownload',
      desc: '',
      args: [e],
    );
  }

  /// `Deleted {p1} file(s).{failedSuffix}`
  String screensItemLibraryItemBookViewDeletedFileS(Object failedSuffix, Object p1) {
    return Intl.message(
      'Deleted $p1 file(s).$failedSuffix',
      name: 'screensItemLibraryItemBookViewDeletedFileS',
      desc: '',
      args: [failedSuffix, p1],
    );
  }

  /// `Could not delete download: {e}`
  String screensItemLibraryItemBookViewCouldNotDeleteDownload(Object e) {
    return Intl.message(
      'Could not delete download: $e',
      name: 'screensItemLibraryItemBookViewCouldNotDeleteDownload',
      desc: '',
      args: [e],
    );
  }

  /// `Podcast metadata is unavailable.`
  String get screensItemLibraryItemPodcastViewPodcastMetadataIsUnavailable {
    return Intl.message(
      'Podcast metadata is unavailable.',
      name: 'screensItemLibraryItemPodcastViewPodcastMetadataIsUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `No episodes match the current search/filter settings.`
  String get screensItemLibraryItemPodcastViewNoEpisodesMatchTheCurrentSearch {
    return Intl.message(
      'No episodes match the current search/filter settings.',
      name: 'screensItemLibraryItemPodcastViewNoEpisodesMatchTheCurrentSearch',
      desc: '',
      args: [],
    );
  }

  /// `Download added to queue.`
  String get screensItemLibraryItemPodcastViewDownloadAddedToQueue {
    return Intl.message(
      'Download added to queue.',
      name: 'screensItemLibraryItemPodcastViewDownloadAddedToQueue',
      desc: '',
      args: [],
    );
  }

  /// `Could not start download: {e}`
  String screensItemLibraryItemPodcastViewCouldNotStartDownload(Object e) {
    return Intl.message(
      'Could not start download: $e',
      name: 'screensItemLibraryItemPodcastViewCouldNotStartDownload',
      desc: '',
      args: [e],
    );
  }

  /// `Deleted {p1} file(s).{failedSuffix}`
  String screensItemLibraryItemPodcastViewDeletedFileS(Object failedSuffix, Object p1) {
    return Intl.message(
      'Deleted $p1 file(s).$failedSuffix',
      name: 'screensItemLibraryItemPodcastViewDeletedFileS',
      desc: '',
      args: [failedSuffix, p1],
    );
  }

  /// `Could not delete download: {e}`
  String screensItemLibraryItemPodcastViewCouldNotDeleteDownload(Object e) {
    return Intl.message(
      'Could not delete download: $e',
      name: 'screensItemLibraryItemPodcastViewCouldNotDeleteDownload',
      desc: '',
      args: [e],
    );
  }

  /// `Episode`
  String get screensItemPodcastPodcastEpisodeDetailsEpisode {
    return Intl.message('Episode', name: 'screensItemPodcastPodcastEpisodeDetailsEpisode', desc: '', args: []);
  }

  /// `Downloading`
  String get screensItemPodcastPodcastEpisodeDetailsDownloading {
    return Intl.message('Downloading', name: 'screensItemPodcastPodcastEpisodeDetailsDownloading', desc: '', args: []);
  }

  /// `Deleted {p1} file(s).{failedSuffix}`
  String screensItemPodcastPodcastEpisodeDetailsDeletedFileS(Object failedSuffix, Object p1) {
    return Intl.message(
      'Deleted $p1 file(s).$failedSuffix',
      name: 'screensItemPodcastPodcastEpisodeDetailsDeletedFileS',
      desc: '',
      args: [failedSuffix, p1],
    );
  }

  /// `Could not delete download: {e}`
  String screensItemPodcastPodcastEpisodeDetailsCouldNotDeleteDownload(Object e) {
    return Intl.message(
      'Could not delete download: $e',
      name: 'screensItemPodcastPodcastEpisodeDetailsCouldNotDeleteDownload',
      desc: '',
      args: [e],
    );
  }

  /// `Delete download`
  String get screensItemPodcastPodcastEpisodeDetailsDeleteDownload {
    return Intl.message(
      'Delete download',
      name: 'screensItemPodcastPodcastEpisodeDetailsDeleteDownload',
      desc: '',
      args: [],
    );
  }

  /// `Download added to queue.`
  String get screensItemPodcastPodcastEpisodeDetailsDownloadAddedToQueue {
    return Intl.message(
      'Download added to queue.',
      name: 'screensItemPodcastPodcastEpisodeDetailsDownloadAddedToQueue',
      desc: '',
      args: [],
    );
  }

  /// `Could not start download: {e}`
  String screensItemPodcastPodcastEpisodeDetailsCouldNotStartDownload(Object e) {
    return Intl.message(
      'Could not start download: $e',
      name: 'screensItemPodcastPodcastEpisodeDetailsCouldNotStartDownload',
      desc: '',
      args: [e],
    );
  }

  /// `Download`
  String get screensItemPodcastPodcastEpisodeDetailsDownload {
    return Intl.message('Download', name: 'screensItemPodcastPodcastEpisodeDetailsDownload', desc: '', args: []);
  }

  /// `Description`
  String get screensItemPodcastPodcastEpisodeDetailsDescription {
    return Intl.message('Description', name: 'screensItemPodcastPodcastEpisodeDetailsDescription', desc: '', args: []);
  }

  /// `Close`
  String get screensItemPodcastPodcastEpisodeDetailsClose {
    return Intl.message('Close', name: 'screensItemPodcastPodcastEpisodeDetailsClose', desc: '', args: []);
  }

  /// `Episodes`
  String get screensItemPodcastPodcastEpisodesHeaderCardEpisodes {
    return Intl.message('Episodes', name: 'screensItemPodcastPodcastEpisodesHeaderCardEpisodes', desc: '', args: []);
  }

  /// `Clear search`
  String get screensItemPodcastPodcastEpisodesHeaderCardClearSearch {
    return Intl.message(
      'Clear search',
      name: 'screensItemPodcastPodcastEpisodesHeaderCardClearSearch',
      desc: '',
      args: [],
    );
  }

  /// `Search episodes by title`
  String get screensItemPodcastPodcastEpisodesHeaderCardSearchEpisodesByTitle {
    return Intl.message(
      'Search episodes by title',
      name: 'screensItemPodcastPodcastEpisodesHeaderCardSearchEpisodesByTitle',
      desc: '',
      args: [],
    );
  }

  /// `Podcast`
  String get screensItemPodcastPodcastHeaderCardPodcast {
    return Intl.message('Podcast', name: 'screensItemPodcastPodcastHeaderCardPodcast', desc: '', args: []);
  }

  /// `DESCRIPTION`
  String get screensItemPodcastPodcastHeaderCardDescription {
    return Intl.message('DESCRIPTION', name: 'screensItemPodcastPodcastHeaderCardDescription', desc: '', args: []);
  }

  /// `Back`
  String get screensItemPodcastPodcastHeaderCardBack {
    return Intl.message('Back', name: 'screensItemPodcastPodcastHeaderCardBack', desc: '', args: []);
  }

  /// `Leave upload page?`
  String get screensLayoutHomeLeaveUploadPage {
    return Intl.message('Leave upload page?', name: 'screensLayoutHomeLeaveUploadPage', desc: '', args: []);
  }

  /// `Leaving this page now cancels active uploads. Continue?`
  String get screensLayoutHomeLeavingThisPageNowCancelsActive {
    return Intl.message(
      'Leaving this page now cancels active uploads. Continue?',
      name: 'screensLayoutHomeLeavingThisPageNowCancelsActive',
      desc: '',
      args: [],
    );
  }

  /// `Stay here`
  String get screensLayoutHomeStayHere {
    return Intl.message('Stay here', name: 'screensLayoutHomeStayHere', desc: '', args: []);
  }

  /// `Leave page`
  String get screensLayoutHomeLeavePage {
    return Intl.message('Leave page', name: 'screensLayoutHomeLeavePage', desc: '', args: []);
  }

  /// `Upload`
  String get screensLayoutHomeLayoutHomeAppBarsUpload {
    return Intl.message('Upload', name: 'screensLayoutHomeLayoutHomeAppBarsUpload', desc: '', args: []);
  }

  /// `Clear selection`
  String get screensLayoutHomeLayoutHomeAppBarsClearSelection {
    return Intl.message(
      'Clear selection',
      name: 'screensLayoutHomeLayoutHomeAppBarsClearSelection',
      desc: '',
      args: [],
    );
  }

  /// `Open uploader`
  String get screensLayoutHomeLayoutHomeAppBarsOpenUploader {
    return Intl.message('Open uploader', name: 'screensLayoutHomeLayoutHomeAppBarsOpenUploader', desc: '', args: []);
  }

  /// `Clear search`
  String get screensLayoutHomeLayoutHomeAppBarsClearSearch {
    return Intl.message('Clear search', name: 'screensLayoutHomeLayoutHomeAppBarsClearSearch', desc: '', args: []);
  }

  /// `Search this library`
  String get screensLayoutHomeLayoutHomeAppBarsSearchThisLibrary {
    return Intl.message(
      'Search this library',
      name: 'screensLayoutHomeLayoutHomeAppBarsSearchThisLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get screensMainAuthorDetailViewBack {
    return Intl.message('Back', name: 'screensMainAuthorDetailViewBack', desc: '', args: []);
  }

  /// `No library selected. Please select a library via the switcher.`
  String get screensMainAuthorsViewNoLibrarySelectedPleaseSelectA {
    return Intl.message(
      'No library selected. Please select a library via the switcher.',
      name: 'screensMainAuthorsViewNoLibrarySelectedPleaseSelectA',
      desc: '',
      args: [],
    );
  }

  /// `Authors are available only for book libraries.`
  String get screensMainAuthorsViewAuthorsAreAvailableOnlyForBook {
    return Intl.message(
      'Authors are available only for book libraries.',
      name: 'screensMainAuthorsViewAuthorsAreAvailableOnlyForBook',
      desc: '',
      args: [],
    );
  }

  /// `No authors found in this library.`
  String get screensMainAuthorsViewNoAuthorsFoundInThisLibrary {
    return Intl.message(
      'No authors found in this library.',
      name: 'screensMainAuthorsViewNoAuthorsFoundInThisLibrary',
      desc: '',
      args: [],
    );
  }

  /// `No library selected. Please select a library via the switcher.`
  String get screensMainCollectionDetailViewNoLibrarySelectedPleaseSelectA {
    return Intl.message(
      'No library selected. Please select a library via the switcher.',
      name: 'screensMainCollectionDetailViewNoLibrarySelectedPleaseSelectA',
      desc: '',
      args: [],
    );
  }

  /// `Edit books`
  String get screensMainCollectionDetailViewEditBooks {
    return Intl.message('Edit books', name: 'screensMainCollectionDetailViewEditBooks', desc: '', args: []);
  }

  /// `Edit details`
  String get screensMainCollectionDetailViewEditDetails {
    return Intl.message('Edit details', name: 'screensMainCollectionDetailViewEditDetails', desc: '', args: []);
  }

  /// `Delete collection`
  String get screensMainCollectionDetailViewDeleteCollection {
    return Intl.message(
      'Delete collection',
      name: 'screensMainCollectionDetailViewDeleteCollection',
      desc: '',
      args: [],
    );
  }

  /// `No books found in this collection.`
  String get screensMainCollectionDetailViewNoBooksFoundInThisCollection {
    return Intl.message(
      'No books found in this collection.',
      name: 'screensMainCollectionDetailViewNoBooksFoundInThisCollection',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get screensMainCollectionDetailViewBack {
    return Intl.message('Back', name: 'screensMainCollectionDetailViewBack', desc: '', args: []);
  }

  /// `Collection actions`
  String get screensMainCollectionDetailViewCollectionActions {
    return Intl.message(
      'Collection actions',
      name: 'screensMainCollectionDetailViewCollectionActions',
      desc: '',
      args: [],
    );
  }

  /// `No library selected. Please select a library via the switcher.`
  String get screensMainCollectionViewNoLibrarySelectedPleaseSelectA {
    return Intl.message(
      'No library selected. Please select a library via the switcher.',
      name: 'screensMainCollectionViewNoLibrarySelectedPleaseSelectA',
      desc: '',
      args: [],
    );
  }

  /// `Edit books`
  String get screensMainCollectionViewEditBooks {
    return Intl.message('Edit books', name: 'screensMainCollectionViewEditBooks', desc: '', args: []);
  }

  /// `Edit details`
  String get screensMainCollectionViewEditDetails {
    return Intl.message('Edit details', name: 'screensMainCollectionViewEditDetails', desc: '', args: []);
  }

  /// `Delete collection`
  String get screensMainCollectionViewDeleteCollection {
    return Intl.message('Delete collection', name: 'screensMainCollectionViewDeleteCollection', desc: '', args: []);
  }

  /// `Delete download`
  String get screensMainDownloadsDeleteDownload {
    return Intl.message('Delete download', name: 'screensMainDownloadsDeleteDownload', desc: '', args: []);
  }

  /// `Delete {label} from local storage and remove it from Downloads?`
  String screensMainDownloadsDeleteFromLocalStorageAndRemove(Object label) {
    return Intl.message(
      'Delete $label from local storage and remove it from Downloads?',
      name: 'screensMainDownloadsDeleteFromLocalStorageAndRemove',
      desc: '',
      args: [label],
    );
  }

  /// `Cancel`
  String get screensMainDownloadsCancel {
    return Intl.message('Cancel', name: 'screensMainDownloadsCancel', desc: '', args: []);
  }

  /// `Delete`
  String get screensMainDownloadsDelete {
    return Intl.message('Delete', name: 'screensMainDownloadsDelete', desc: '', args: []);
  }

  /// `No active user.`
  String get screensMainDownloadsNoActiveUser {
    return Intl.message('No active user.', name: 'screensMainDownloadsNoActiveUser', desc: '', args: []);
  }

  /// `No downloads available.`
  String get screensMainDownloadsNoDownloadsAvailable {
    return Intl.message(
      'No downloads available.',
      name: 'screensMainDownloadsNoDownloadsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get screensMainDownloadsSelect {
    return Intl.message('Select', name: 'screensMainDownloadsSelect', desc: '', args: []);
  }

  /// `No library selected. Please select a library via the switcher.`
  String get screensMainLibraryViewNoLibrarySelectedPleaseSelectA {
    return Intl.message(
      'No library selected. Please select a library via the switcher.',
      name: 'screensMainLibraryViewNoLibrarySelectedPleaseSelectA',
      desc: '',
      args: [],
    );
  }

  /// `No items found in this library.`
  String get screensMainLibraryViewNoItemsFoundInThisLibrary {
    return Intl.message(
      'No items found in this library.',
      name: 'screensMainLibraryViewNoItemsFoundInThisLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get screensMainNarratorDetailViewBack {
    return Intl.message('Back', name: 'screensMainNarratorDetailViewBack', desc: '', args: []);
  }

  /// `No library selected. Please select a library via the switcher.`
  String get screensMainNarratorsViewNoLibrarySelectedPleaseSelectA {
    return Intl.message(
      'No library selected. Please select a library via the switcher.',
      name: 'screensMainNarratorsViewNoLibrarySelectedPleaseSelectA',
      desc: '',
      args: [],
    );
  }

  /// `Narrators are available only for book libraries.`
  String get screensMainNarratorsViewNarratorsAreAvailableOnlyForBook {
    return Intl.message(
      'Narrators are available only for book libraries.',
      name: 'screensMainNarratorsViewNarratorsAreAvailableOnlyForBook',
      desc: '',
      args: [],
    );
  }

  /// `No narrators found in this library.`
  String get screensMainNarratorsViewNoNarratorsFoundInThisLibrary {
    return Intl.message(
      'No narrators found in this library.',
      name: 'screensMainNarratorsViewNoNarratorsFoundInThisLibrary',
      desc: '',
      args: [],
    );
  }

  /// `No library selected. Please select a library via the switcher.`
  String get screensMainPersonalizedViewNoLibrarySelectedPleaseSelectA {
    return Intl.message(
      'No library selected. Please select a library via the switcher.',
      name: 'screensMainPersonalizedViewNoLibrarySelectedPleaseSelectA',
      desc: '',
      args: [],
    );
  }

  /// `Server connection is unstable. Displaying the latest available shelf data.`
  String get screensMainPersonalizedViewServerConnectionIsUnstableDisplayingThe {
    return Intl.message(
      'Server connection is unstable. Displaying the latest available shelf data.',
      name: 'screensMainPersonalizedViewServerConnectionIsUnstableDisplayingThe',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get screensMainPersonalizedViewRetry {
    return Intl.message('Retry', name: 'screensMainPersonalizedViewRetry', desc: '', args: []);
  }

  /// `Open Downloads`
  String get screensMainPersonalizedViewOpenDownloads {
    return Intl.message('Open Downloads', name: 'screensMainPersonalizedViewOpenDownloads', desc: '', args: []);
  }

  /// `Failed to queue visible items: {error}`
  String screensMainPersonalizedViewFailedToQueueVisibleItems(Object error) {
    return Intl.message(
      'Failed to queue visible items: $error',
      name: 'screensMainPersonalizedViewFailedToQueueVisibleItems',
      desc: '',
      args: [error],
    );
  }

  /// `Queue all items in this shelf`
  String get screensMainPersonalizedViewQueueAllItemsInThisShelf {
    return Intl.message(
      'Queue all items in this shelf',
      name: 'screensMainPersonalizedViewQueueAllItemsInThisShelf',
      desc: '',
      args: [],
    );
  }

  /// `No server connection available`
  String get screensMainPersonalizedViewNoServerConnectionAvailable {
    return Intl.message(
      'No server connection available',
      name: 'screensMainPersonalizedViewNoServerConnectionAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Pull down to refresh once your connection is back.`
  String get screensMainPersonalizedViewPullDownToRefreshOnceYourConnectionIs {
    return Intl.message(
      'Pull down to refresh once your connection is back.',
      name: 'screensMainPersonalizedViewPullDownToRefreshOnceYourConnectionIs',
      desc: '',
      args: [],
    );
  }

  /// `No personalized items found`
  String get screensMainPersonalizedViewNoPersonalizedItemsFound {
    return Intl.message(
      'No personalized items found',
      name: 'screensMainPersonalizedViewNoPersonalizedItemsFound',
      desc: '',
      args: [],
    );
  }

  /// `Personalized shelf is offline`
  String get screensMainPersonalizedViewPersonalizedShelfIsOffline {
    return Intl.message(
      'Personalized shelf is offline',
      name: 'screensMainPersonalizedViewPersonalizedShelfIsOffline',
      desc: '',
      args: [],
    );
  }

  /// `No personalized sections are available for this library yet.`
  String get screensMainPersonalizedViewNoPersonalizedSectionsAreAvailableForThis {
    return Intl.message(
      'No personalized sections are available for this library yet.',
      name: 'screensMainPersonalizedViewNoPersonalizedSectionsAreAvailableForThis',
      desc: '',
      args: [],
    );
  }

  /// `Unable to reach the server right now. Pull down to retry.`
  String get screensMainPersonalizedViewUnableToReachTheServerRightNowPull {
    return Intl.message(
      'Unable to reach the server right now. Pull down to retry.',
      name: 'screensMainPersonalizedViewUnableToReachTheServerRightNowPull',
      desc: '',
      args: [],
    );
  }

  /// `No personalized sections available yet`
  String get screensMainPersonalizedViewNoPersonalizedSectionsAvailableYet {
    return Intl.message(
      'No personalized sections available yet',
      name: 'screensMainPersonalizedViewNoPersonalizedSectionsAvailableYet',
      desc: '',
      args: [],
    );
  }

  /// `Pull down to refresh and try again.`
  String get screensMainPersonalizedViewPullDownToRefreshAndTryAgain {
    return Intl.message(
      'Pull down to refresh and try again.',
      name: 'screensMainPersonalizedViewPullDownToRefreshAndTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `No library selected. Please select a library via the switcher.`
  String get screensMainPlaylistDetailViewNoLibrarySelectedPleaseSelectA {
    return Intl.message(
      'No library selected. Please select a library via the switcher.',
      name: 'screensMainPlaylistDetailViewNoLibrarySelectedPleaseSelectA',
      desc: '',
      args: [],
    );
  }

  /// `Edit books`
  String get screensMainPlaylistDetailViewEditBooks {
    return Intl.message('Edit books', name: 'screensMainPlaylistDetailViewEditBooks', desc: '', args: []);
  }

  /// `Edit details`
  String get screensMainPlaylistDetailViewEditDetails {
    return Intl.message('Edit details', name: 'screensMainPlaylistDetailViewEditDetails', desc: '', args: []);
  }

  /// `Delete playlist`
  String get screensMainPlaylistDetailViewDeletePlaylist {
    return Intl.message('Delete playlist', name: 'screensMainPlaylistDetailViewDeletePlaylist', desc: '', args: []);
  }

  /// `No library items found in this playlist.`
  String get screensMainPlaylistDetailViewNoLibraryItemsFoundInThis {
    return Intl.message(
      'No library items found in this playlist.',
      name: 'screensMainPlaylistDetailViewNoLibraryItemsFoundInThis',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get screensMainPlaylistDetailViewBack {
    return Intl.message('Back', name: 'screensMainPlaylistDetailViewBack', desc: '', args: []);
  }

  /// `Playlist actions`
  String get screensMainPlaylistDetailViewPlaylistActions {
    return Intl.message('Playlist actions', name: 'screensMainPlaylistDetailViewPlaylistActions', desc: '', args: []);
  }

  /// `No library selected. Please select a library via the switcher.`
  String get screensMainPlaylistViewNoLibrarySelectedPleaseSelectA {
    return Intl.message(
      'No library selected. Please select a library via the switcher.',
      name: 'screensMainPlaylistViewNoLibrarySelectedPleaseSelectA',
      desc: '',
      args: [],
    );
  }

  /// `Edit books`
  String get screensMainPlaylistViewEditBooks {
    return Intl.message('Edit books', name: 'screensMainPlaylistViewEditBooks', desc: '', args: []);
  }

  /// `Edit details`
  String get screensMainPlaylistViewEditDetails {
    return Intl.message('Edit details', name: 'screensMainPlaylistViewEditDetails', desc: '', args: []);
  }

  /// `Delete playlist`
  String get screensMainPlaylistViewDeletePlaylist {
    return Intl.message('Delete playlist', name: 'screensMainPlaylistViewDeletePlaylist', desc: '', args: []);
  }

  /// `No library selected. Please select a library via the switcher.`
  String get screensMainSearchViewNoLibrarySelectedPleaseSelectA {
    return Intl.message(
      'No library selected. Please select a library via the switcher.',
      name: 'screensMainSearchViewNoLibrarySelectedPleaseSelectA',
      desc: '',
      args: [],
    );
  }

  /// `No results found.`
  String get screensMainSearchViewNoResultsFound {
    return Intl.message('No results found.', name: 'screensMainSearchViewNoResultsFound', desc: '', args: []);
  }

  /// `No results found for "{query}".`
  String screensMainSearchViewNoResultsFoundFor(Object query) {
    return Intl.message(
      'No results found for "$query".',
      name: 'screensMainSearchViewNoResultsFoundFor',
      desc: '',
      args: [query],
    );
  }

  /// `Search results for "{query}"`
  String screensMainSearchViewSearchResultsFor(Object query) {
    return Intl.message(
      'Search results for "$query"',
      name: 'screensMainSearchViewSearchResultsFor',
      desc: '',
      args: [query],
    );
  }

  /// `Error loading search results: {err}`
  String screensMainSearchViewErrorLoadingSearchResults(Object err) {
    return Intl.message(
      'Error loading search results: $err',
      name: 'screensMainSearchViewErrorLoadingSearchResults',
      desc: '',
      args: [err],
    );
  }

  /// `No library selected. Please select a library via the switcher.`
  String get screensMainSeriesDetailViewNoLibrarySelectedPleaseSelectA {
    return Intl.message(
      'No library selected. Please select a library via the switcher.',
      name: 'screensMainSeriesDetailViewNoLibrarySelectedPleaseSelectA',
      desc: '',
      args: [],
    );
  }

  /// `Series are available only for book libraries.`
  String get screensMainSeriesDetailViewSeriesAreAvailableOnlyForBook {
    return Intl.message(
      'Series are available only for book libraries.',
      name: 'screensMainSeriesDetailViewSeriesAreAvailableOnlyForBook',
      desc: '',
      args: [],
    );
  }

  /// `Series details could not be loaded.`
  String get screensMainSeriesDetailViewSeriesDetailsCouldNotBeLoaded {
    return Intl.message(
      'Series details could not be loaded.',
      name: 'screensMainSeriesDetailViewSeriesDetailsCouldNotBeLoaded',
      desc: '',
      args: [],
    );
  }

  /// `No books found in this series.`
  String get screensMainSeriesDetailViewNoBooksFoundInThisSeries {
    return Intl.message(
      'No books found in this series.',
      name: 'screensMainSeriesDetailViewNoBooksFoundInThisSeries',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get screensMainSeriesDetailViewBack {
    return Intl.message('Back', name: 'screensMainSeriesDetailViewBack', desc: '', args: []);
  }

  /// `No library selected. Please select a library via the switcher.`
  String get screensMainSeriesViewNoLibrarySelectedPleaseSelectA {
    return Intl.message(
      'No library selected. Please select a library via the switcher.',
      name: 'screensMainSeriesViewNoLibrarySelectedPleaseSelectA',
      desc: '',
      args: [],
    );
  }

  /// `Series are available only for book libraries.`
  String get screensMainSeriesViewSeriesAreAvailableOnlyForBook {
    return Intl.message(
      'Series are available only for book libraries.',
      name: 'screensMainSeriesViewSeriesAreAvailableOnlyForBook',
      desc: '',
      args: [],
    );
  }

  /// `No series found in this library.`
  String get screensMainSeriesViewNoSeriesFoundInThisLibrary {
    return Intl.message(
      'No series found in this library.',
      name: 'screensMainSeriesViewNoSeriesFoundInThisLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Less`
  String get screensMainStatsStatsActivityHeatmapLess {
    return Intl.message('Less', name: 'screensMainStatsStatsActivityHeatmapLess', desc: '', args: []);
  }

  /// `More`
  String get screensMainStatsStatsActivityHeatmapMore {
    return Intl.message('More', name: 'screensMainStatsStatsActivityHeatmapMore', desc: '', args: []);
  }

  /// `{range}d`
  String screensMainStatsStatsActivityRangeChartD(Object range) {
    return Intl.message('${range}d', name: 'screensMainStatsStatsActivityRangeChartD', desc: '', args: [range]);
  }

  /// `{p1}/{p2}`
  String screensMainStatsStatsActivityRangeChartText(Object p1, Object p2) {
    return Intl.message('$p1/$p2', name: 'screensMainStatsStatsActivityRangeChartText', desc: '', args: [p1, p2]);
  }

  /// `Last {_selectedRange} days`
  String screensMainStatsStatsActivityRangeChartLastDays(Object _selectedRange) {
    return Intl.message(
      'Last {_selectedRange} days',
      name: 'screensMainStatsStatsActivityRangeChartLastDays',
      desc: '',
      args: [_selectedRange],
    );
  }

  /// `Failed to load listening activity.`
  String get screensMainStatsStatsActivitySectionFailedToLoadListeningActivity {
    return Intl.message(
      'Failed to load listening activity.',
      name: 'screensMainStatsStatsActivitySectionFailedToLoadListeningActivity',
      desc: '',
      args: [],
    );
  }

  /// `Retry Activity`
  String get screensMainStatsStatsActivitySectionRetryActivity {
    return Intl.message(
      'Retry Activity',
      name: 'screensMainStatsStatsActivitySectionRetryActivity',
      desc: '',
      args: [],
    );
  }

  /// `Listening Time Totals`
  String get screensMainStatsStatsActivityTotalsCardListeningTimeTotals {
    return Intl.message(
      'Listening Time Totals',
      name: 'screensMainStatsStatsActivityTotalsCardListeningTimeTotals',
      desc: '',
      args: [],
    );
  }

  /// `Retry totals`
  String get screensMainStatsStatsActivityTotalsCardRetryTotals {
    return Intl.message('Retry totals', name: 'screensMainStatsStatsActivityTotalsCardRetryTotals', desc: '', args: []);
  }

  /// `Loading advanced analytics...`
  String get screensMainStatsStatsAdvancedDashboardLoadingAdvancedAnalytics {
    return Intl.message(
      'Loading advanced analytics...',
      name: 'screensMainStatsStatsAdvancedDashboardLoadingAdvancedAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Pages {p1}/{totalPagesLabel} • Sessions {p2}/{totalSessionsLabel}`
  String screensMainStatsStatsAdvancedDashboardPagesSessions(
    Object p1,
    Object p2,
    Object totalPagesLabel,
    Object totalSessionsLabel,
  ) {
    return Intl.message(
      'Pages $p1/$totalPagesLabel • Sessions $p2/$totalSessionsLabel',
      name: 'screensMainStatsStatsAdvancedDashboardPagesSessions',
      desc: '',
      args: [p1, p2, totalPagesLabel, totalSessionsLabel],
    );
  }

  /// `Failed to compute advanced stats.`
  String get screensMainStatsStatsAdvancedDashboardFailedToComputeAdvancedStats {
    return Intl.message(
      'Failed to compute advanced stats.',
      name: 'screensMainStatsStatsAdvancedDashboardFailedToComputeAdvancedStats',
      desc: '',
      args: [],
    );
  }

  /// `Retry Advanced Mode`
  String get screensMainStatsStatsAdvancedDashboardRetryAdvancedMode {
    return Intl.message(
      'Retry Advanced Mode',
      name: 'screensMainStatsStatsAdvancedDashboardRetryAdvancedMode',
      desc: '',
      args: [],
    );
  }

  /// `No recent sessions available.`
  String get screensMainStatsStatsRecentSessionsListNoRecentSessionsAvailable {
    return Intl.message(
      'No recent sessions available.',
      name: 'screensMainStatsStatsRecentSessionsListNoRecentSessionsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No weekday listening data available.`
  String get screensMainStatsStatsWeekdayBreakdownNoWeekdayListeningDataAvailable {
    return Intl.message(
      'No weekday listening data available.',
      name: 'screensMainStatsStatsWeekdayBreakdownNoWeekdayListeningDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No year-in-review data available for this year.`
  String get screensMainStatsStatsYearRewindSectionNoYearInReviewDataAvailable {
    return Intl.message(
      'No year-in-review data available for this year.',
      name: 'screensMainStatsStatsYearRewindSectionNoYearInReviewDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `{year} in rewind`
  String screensMainStatsStatsYearRewindSectionInRewind(Object year) {
    return Intl.message(
      '$year in rewind',
      name: 'screensMainStatsStatsYearRewindSectionInRewind',
      desc: '',
      args: [year],
    );
  }

  /// `Peak month: {peakMonth}`
  String screensMainStatsStatsYearRewindSectionPeakMonth(Object peakMonth) {
    return Intl.message(
      'Peak month: $peakMonth',
      name: 'screensMainStatsStatsYearRewindSectionPeakMonth',
      desc: '',
      args: [peakMonth],
    );
  }

  /// `Failed to load year-in-review stats.`
  String get screensMainStatsStatsYearRewindSectionFailedToLoadYearInReview {
    return Intl.message(
      'Failed to load year-in-review stats.',
      name: 'screensMainStatsStatsYearRewindSectionFailedToLoadYearInReview',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get screensMainStatsStatsYearRewindSectionRetry {
    return Intl.message('Retry', name: 'screensMainStatsStatsYearRewindSectionRetry', desc: '', args: []);
  }

  /// `Refresh`
  String get screensMainStatsStatsYearRewindSectionRefresh {
    return Intl.message('Refresh', name: 'screensMainStatsStatsYearRewindSectionRefresh', desc: '', args: []);
  }

  /// `Year`
  String get screensMainStatsStatsYearRewindSectionYear {
    return Intl.message('Year', name: 'screensMainStatsStatsYearRewindSectionYear', desc: '', args: []);
  }

  /// `Load advanced analytics?`
  String get screensMainStatsViewLoadAdvancedAnalytics {
    return Intl.message(
      'Load advanced analytics?',
      name: 'screensMainStatsViewLoadAdvancedAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Advanced mode fetches every listening-session page and can take time on large accounts.`
  String get screensMainStatsViewAdvancedModeFetchesEveryListeningSession {
    return Intl.message(
      'Advanced mode fetches every listening-session page and can take time on large accounts.',
      name: 'screensMainStatsViewAdvancedModeFetchesEveryListeningSession',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get screensMainStatsViewCancel {
    return Intl.message('Cancel', name: 'screensMainStatsViewCancel', desc: '', args: []);
  }

  /// `Load`
  String get screensMainStatsViewLoad {
    return Intl.message('Load', name: 'screensMainStatsViewLoad', desc: '', args: []);
  }

  /// `Recent Sessions`
  String get screensMainStatsViewRecentSessions {
    return Intl.message('Recent Sessions', name: 'screensMainStatsViewRecentSessions', desc: '', args: []);
  }

  /// `Load Advanced Analytics`
  String get screensMainStatsViewLoadAdvancedAnalytics2 {
    return Intl.message(
      'Load Advanced Analytics',
      name: 'screensMainStatsViewLoadAdvancedAnalytics2',
      desc: '',
      args: [],
    );
  }

  /// `Stats`
  String get screensMainStatsViewStats {
    return Intl.message('Stats', name: 'screensMainStatsViewStats', desc: '', args: []);
  }

  /// `Refresh activity`
  String get screensMainStatsViewRefreshActivity {
    return Intl.message('Refresh activity', name: 'screensMainStatsViewRefreshActivity', desc: '', args: []);
  }

  /// `Listening Sessions`
  String get screensMainUserListeningSessionsViewListeningSessions {
    return Intl.message(
      'Listening Sessions',
      name: 'screensMainUserListeningSessionsViewListeningSessions',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get screensMainUserListeningSessionsViewBack {
    return Intl.message('Back', name: 'screensMainUserListeningSessionsViewBack', desc: '', args: []);
  }

  /// `Play a little further before creating a bookmark.`
  String get screensPlayerBookmarksSheetPlayALittleFurtherBeforeCreating {
    return Intl.message(
      'Play a little further before creating a bookmark.',
      name: 'screensPlayerBookmarksSheetPlayALittleFurtherBeforeCreating',
      desc: '',
      args: [],
    );
  }

  /// `Please enter bookmark text.`
  String get screensPlayerBookmarksSheetPleaseEnterBookmarkText {
    return Intl.message(
      'Please enter bookmark text.',
      name: 'screensPlayerBookmarksSheetPleaseEnterBookmarkText',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create bookmark.`
  String get screensPlayerBookmarksSheetFailedToCreateBookmark {
    return Intl.message(
      'Failed to create bookmark.',
      name: 'screensPlayerBookmarksSheetFailedToCreateBookmark',
      desc: '',
      args: [],
    );
  }

  /// `Bookmark added at {p1}`
  String screensPlayerBookmarksSheetBookmarkAddedAt(Object p1) {
    return Intl.message(
      'Bookmark added at $p1',
      name: 'screensPlayerBookmarksSheetBookmarkAddedAt',
      desc: '',
      args: [p1],
    );
  }

  /// `Could not create bookmark right now.`
  String get screensPlayerBookmarksSheetCouldNotCreateBookmarkRightNow {
    return Intl.message(
      'Could not create bookmark right now.',
      name: 'screensPlayerBookmarksSheetCouldNotCreateBookmarkRightNow',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete bookmark.`
  String get screensPlayerBookmarksSheetFailedToDeleteBookmark {
    return Intl.message(
      'Failed to delete bookmark.',
      name: 'screensPlayerBookmarksSheetFailedToDeleteBookmark',
      desc: '',
      args: [],
    );
  }

  /// `Bookmark deleted.`
  String get screensPlayerBookmarksSheetBookmarkDeleted {
    return Intl.message('Bookmark deleted.', name: 'screensPlayerBookmarksSheetBookmarkDeleted', desc: '', args: []);
  }

  /// `Could not delete bookmark right now.`
  String get screensPlayerBookmarksSheetCouldNotDeleteBookmarkRightNow {
    return Intl.message(
      'Could not delete bookmark right now.',
      name: 'screensPlayerBookmarksSheetCouldNotDeleteBookmarkRightNow',
      desc: '',
      args: [],
    );
  }

  /// `Bookmarks`
  String get screensPlayerBookmarksSheetBookmarks {
    return Intl.message('Bookmarks', name: 'screensPlayerBookmarksSheetBookmarks', desc: '', args: []);
  }

  /// `No bookmarks yet`
  String get screensPlayerBookmarksSheetNoBookmarksYet {
    return Intl.message('No bookmarks yet', name: 'screensPlayerBookmarksSheetNoBookmarksYet', desc: '', args: []);
  }

  /// `Car Mode`
  String get screensPlayerCarModeScreenCarMode {
    return Intl.message('Car Mode', name: 'screensPlayerCarModeScreenCarMode', desc: '', args: []);
  }

  /// `{p1} - {p2}`
  String screensPlayerChapterText(Object p1, Object p2) {
    return Intl.message('$p1 - $p2', name: 'screensPlayerChapterText', desc: '', args: [p1, p2]);
  }

  /// `No chapters available`
  String get screensPlayerChapterNoChaptersAvailable {
    return Intl.message('No chapters available', name: 'screensPlayerChapterNoChaptersAvailable', desc: '', args: []);
  }

  /// `Create bookmark`
  String get screensPlayerComponentsBookmarkTitleDialogCreateBookmark {
    return Intl.message(
      'Create bookmark',
      name: 'screensPlayerComponentsBookmarkTitleDialogCreateBookmark',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get screensPlayerComponentsBookmarkTitleDialogCancel {
    return Intl.message('Cancel', name: 'screensPlayerComponentsBookmarkTitleDialogCancel', desc: '', args: []);
  }

  /// `Create`
  String get screensPlayerComponentsBookmarkTitleDialogCreate {
    return Intl.message('Create', name: 'screensPlayerComponentsBookmarkTitleDialogCreate', desc: '', args: []);
  }

  /// `Bookmark text`
  String get screensPlayerComponentsBookmarkTitleDialogBookmarkText {
    return Intl.message(
      'Bookmark text',
      name: 'screensPlayerComponentsBookmarkTitleDialogBookmarkText',
      desc: '',
      args: [],
    );
  }

  /// `Enter bookmark`
  String get screensPlayerComponentsBookmarkTitleDialogEnterBookmark {
    return Intl.message(
      'Enter bookmark',
      name: 'screensPlayerComponentsBookmarkTitleDialogEnterBookmark',
      desc: '',
      args: [],
    );
  }

  /// `{p1} settings`
  String screensPlayerLayoutPlayerComponentSettingsSheetSettings(Object p1) {
    return Intl.message(
      '$p1 settings',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetSettings',
      desc: '',
      args: [p1],
    );
  }

  /// `Use card style`
  String get screensPlayerLayoutPlayerComponentSettingsSheetUseCardStyle {
    return Intl.message(
      'Use card style',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetUseCardStyle',
      desc: '',
      args: [],
    );
  }

  /// `Scale {p1}x`
  String screensPlayerLayoutPlayerComponentSettingsSheetScaleX(Object p1) {
    return Intl.message(
      'Scale ${p1}x',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetScaleX',
      desc: '',
      args: [p1],
    );
  }

  /// `Show author`
  String get screensPlayerLayoutPlayerComponentSettingsSheetShowAuthor {
    return Intl.message(
      'Show author',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetShowAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Show narrator`
  String get screensPlayerLayoutPlayerComponentSettingsSheetShowNarrator {
    return Intl.message(
      'Show narrator',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetShowNarrator',
      desc: '',
      args: [],
    );
  }

  /// `Show series`
  String get screensPlayerLayoutPlayerComponentSettingsSheetShowSeries {
    return Intl.message(
      'Show series',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetShowSeries',
      desc: '',
      args: [],
    );
  }

  /// `Font scale {p1}x`
  String screensPlayerLayoutPlayerComponentSettingsSheetFontScaleX(Object p1) {
    return Intl.message(
      'Font scale ${p1}x',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetFontScaleX',
      desc: '',
      args: [p1],
    );
  }

  /// `Seek bar height {p1}`
  String screensPlayerLayoutPlayerComponentSettingsSheetSeekBarHeight(Object p1) {
    return Intl.message(
      'Seek bar height $p1',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetSeekBarHeight',
      desc: '',
      args: [p1],
    );
  }

  /// `Time font size {p1}`
  String screensPlayerLayoutPlayerComponentSettingsSheetTimeFontSize(Object p1) {
    return Intl.message(
      'Time font size $p1',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetTimeFontSize',
      desc: '',
      args: [p1],
    );
  }

  /// `Move up`
  String get screensPlayerLayoutPlayerComponentSettingsSheetMoveUp {
    return Intl.message('Move up', name: 'screensPlayerLayoutPlayerComponentSettingsSheetMoveUp', desc: '', args: []);
  }

  /// `Move down`
  String get screensPlayerLayoutPlayerComponentSettingsSheetMoveDown {
    return Intl.message(
      'Move down',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetMoveDown',
      desc: '',
      args: [],
    );
  }

  /// `Text alignment`
  String get screensPlayerLayoutPlayerComponentSettingsSheetTextAlignment {
    return Intl.message(
      'Text alignment',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetTextAlignment',
      desc: '',
      args: [],
    );
  }

  /// `Cover fit mode`
  String get screensPlayerLayoutPlayerComponentSettingsSheetCoverFitMode {
    return Intl.message(
      'Cover fit mode',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetCoverFitMode',
      desc: '',
      args: [],
    );
  }

  /// `Time labels position`
  String get screensPlayerLayoutPlayerComponentSettingsSheetTimeLabelsPosition {
    return Intl.message(
      'Time labels position',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetTimeLabelsPosition',
      desc: '',
      args: [],
    );
  }

  /// `When this component has no data`
  String get screensPlayerLayoutPlayerComponentSettingsSheetWhenThisComponentHasNoData {
    return Intl.message(
      'When this component has no data',
      name: 'screensPlayerLayoutPlayerComponentSettingsSheetWhenThisComponentHasNoData',
      desc: '',
      args: [],
    );
  }

  /// `No components are visible for this layout.`
  String get screensPlayerLayoutPlayerGridCanvasNoComponentsAreVisibleForThis {
    return Intl.message(
      'No components are visible for this layout.',
      name: 'screensPlayerLayoutPlayerGridCanvasNoComponentsAreVisibleForThis',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get screensPlayerLayoutPlayerGridCanvasSettings {
    return Intl.message('Settings', name: 'screensPlayerLayoutPlayerGridCanvasSettings', desc: '', args: []);
  }

  /// `Remove from layout`
  String get screensPlayerLayoutPlayerGridCanvasRemoveFromLayout {
    return Intl.message(
      'Remove from layout',
      name: 'screensPlayerLayoutPlayerGridCanvasRemoveFromLayout',
      desc: '',
      args: [],
    );
  }

  /// `Component actions`
  String get screensPlayerLayoutPlayerGridCanvasComponentActions {
    return Intl.message(
      'Component actions',
      name: 'screensPlayerLayoutPlayerGridCanvasComponentActions',
      desc: '',
      args: [],
    );
  }

  /// `Move left`
  String get screensPlayerLayoutPlayerGridCanvasMoveLeft {
    return Intl.message('Move left', name: 'screensPlayerLayoutPlayerGridCanvasMoveLeft', desc: '', args: []);
  }

  /// `Move up`
  String get screensPlayerLayoutPlayerGridCanvasMoveUp {
    return Intl.message('Move up', name: 'screensPlayerLayoutPlayerGridCanvasMoveUp', desc: '', args: []);
  }

  /// `Move down`
  String get screensPlayerLayoutPlayerGridCanvasMoveDown {
    return Intl.message('Move down', name: 'screensPlayerLayoutPlayerGridCanvasMoveDown', desc: '', args: []);
  }

  /// `Move right`
  String get screensPlayerLayoutPlayerGridCanvasMoveRight {
    return Intl.message('Move right', name: 'screensPlayerLayoutPlayerGridCanvasMoveRight', desc: '', args: []);
  }

  /// `Narrower`
  String get screensPlayerLayoutPlayerGridCanvasNarrower {
    return Intl.message('Narrower', name: 'screensPlayerLayoutPlayerGridCanvasNarrower', desc: '', args: []);
  }

  /// `Wider`
  String get screensPlayerLayoutPlayerGridCanvasWider {
    return Intl.message('Wider', name: 'screensPlayerLayoutPlayerGridCanvasWider', desc: '', args: []);
  }

  /// `Shorter`
  String get screensPlayerLayoutPlayerGridCanvasShorter {
    return Intl.message('Shorter', name: 'screensPlayerLayoutPlayerGridCanvasShorter', desc: '', args: []);
  }

  /// `Taller`
  String get screensPlayerLayoutPlayerGridCanvasTaller {
    return Intl.message('Taller', name: 'screensPlayerLayoutPlayerGridCanvasTaller', desc: '', args: []);
  }

  /// `Loading next item...`
  String get screensPlayerPlayBarLoadingNextItem {
    return Intl.message('Loading next item...', name: 'screensPlayerPlayBarLoadingNextItem', desc: '', args: []);
  }

  /// `No active media to bookmark.`
  String get screensPlayerPlayerNoActiveMediaToBookmark {
    return Intl.message(
      'No active media to bookmark.',
      name: 'screensPlayerPlayerNoActiveMediaToBookmark',
      desc: '',
      args: [],
    );
  }

  /// `No free grid space available for {p1}.`
  String screensPlayerPlayerNoFreeGridSpaceAvailableFor(Object p1) {
    return Intl.message(
      'No free grid space available for $p1.',
      name: 'screensPlayerPlayerNoFreeGridSpaceAvailableFor',
      desc: '',
      args: [p1],
    );
  }

  /// `Layout config copied to clipboard.`
  String get screensPlayerPlayerLayoutConfigCopiedToClipboard {
    return Intl.message(
      'Layout config copied to clipboard.',
      name: 'screensPlayerPlayerLayoutConfigCopiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Edit {p1} Layout`
  String screensPlayerPlayerEditLayout(Object p1) {
    return Intl.message('Edit $p1 Layout', name: 'screensPlayerPlayerEditLayout', desc: '', args: [p1]);
  }

  /// `Player`
  String get screensPlayerPlayerPlayer {
    return Intl.message('Player', name: 'screensPlayerPlayerPlayer', desc: '', args: []);
  }

  /// `Loading next item...`
  String get screensPlayerPlayerLoadingNextItem {
    return Intl.message('Loading next item...', name: 'screensPlayerPlayerLoadingNextItem', desc: '', args: []);
  }

  /// `Queue`
  String get screensPlayerPlayerQueue {
    return Intl.message('Queue', name: 'screensPlayerPlayerQueue', desc: '', args: []);
  }

  /// `Quick Player Settings`
  String get screensPlayerPlayerQuickPlayerSettings {
    return Intl.message('Quick Player Settings', name: 'screensPlayerPlayerQuickPlayerSettings', desc: '', args: []);
  }

  /// `Timeline mode`
  String get screensPlayerPlayerTimelineMode {
    return Intl.message('Timeline mode', name: 'screensPlayerPlayerTimelineMode', desc: '', args: []);
  }

  /// `Exit edit mode`
  String get screensPlayerPlayerExitEditMode {
    return Intl.message('Exit edit mode', name: 'screensPlayerPlayerExitEditMode', desc: '', args: []);
  }

  /// `Add component`
  String get screensPlayerPlayerAddComponent {
    return Intl.message('Add component', name: 'screensPlayerPlayerAddComponent', desc: '', args: []);
  }

  /// `Copy layout config`
  String get screensPlayerPlayerCopyLayoutConfig {
    return Intl.message('Copy layout config', name: 'screensPlayerPlayerCopyLayoutConfig', desc: '', args: []);
  }

  /// `Reset active screen layout`
  String get screensPlayerPlayerResetActiveScreenLayout {
    return Intl.message(
      'Reset active screen layout',
      name: 'screensPlayerPlayerResetActiveScreenLayout',
      desc: '',
      args: [],
    );
  }

  /// `Done editing`
  String get screensPlayerPlayerDoneEditing {
    return Intl.message('Done editing', name: 'screensPlayerPlayerDoneEditing', desc: '', args: []);
  }

  /// `Unlocked overlap mode`
  String get screensPlayerPlayerUnlockedOverlapMode {
    return Intl.message('Unlocked overlap mode', name: 'screensPlayerPlayerUnlockedOverlapMode', desc: '', args: []);
  }

  /// `Locked mode (prevent overlap)`
  String get screensPlayerPlayerLockedModePreventOverlap {
    return Intl.message(
      'Locked mode (prevent overlap)',
      name: 'screensPlayerPlayerLockedModePreventOverlap',
      desc: '',
      args: [],
    );
  }

  /// `Enter layout edit mode`
  String get screensPlayerPlayerEnterLayoutEditMode {
    return Intl.message('Enter layout edit mode', name: 'screensPlayerPlayerEnterLayoutEditMode', desc: '', args: []);
  }

  /// `Quick Settings`
  String get screensPlayerPlayerQuickSettings {
    return Intl.message('Quick Settings', name: 'screensPlayerPlayerQuickSettings', desc: '', args: []);
  }

  /// `More options`
  String get screensPlayerPlayerMoreOptions {
    return Intl.message('More options', name: 'screensPlayerPlayerMoreOptions', desc: '', args: []);
  }

  /// `No active user.`
  String get screensPlayerPlayHistoryLocalTabNoActiveUser {
    return Intl.message('No active user.', name: 'screensPlayerPlayHistoryLocalTabNoActiveUser', desc: '', args: []);
  }

  /// `Error: {p1}`
  String screensPlayerPlayHistoryLocalTabError(Object p1) {
    return Intl.message('Error: $p1', name: 'screensPlayerPlayHistoryLocalTabError', desc: '', args: [p1]);
  }

  /// `No play history available`
  String get screensPlayerPlayHistoryLocalTabNoPlayHistoryAvailable {
    return Intl.message(
      'No play history available',
      name: 'screensPlayerPlayHistoryLocalTabNoPlayHistoryAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Position: {timeText}`
  String screensPlayerPlayHistoryLocalTabPosition(Object timeText) {
    return Intl.message(
      'Position: $timeText',
      name: 'screensPlayerPlayHistoryLocalTabPosition',
      desc: '',
      args: [timeText],
    );
  }

  /// `Play History`
  String get screensPlayerPlayHistoryViewPlayHistory {
    return Intl.message('Play History', name: 'screensPlayerPlayHistoryViewPlayHistory', desc: '', args: []);
  }

  /// `No user or media item available`
  String get screensPlayerPlayHistoryViewNoUserOrMediaItemAvailable {
    return Intl.message(
      'No user or media item available',
      name: 'screensPlayerPlayHistoryViewNoUserOrMediaItemAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load item sessions: {error}`
  String screensPlayerPlayHistoryViewFailedToLoadItemSessions(Object error) {
    return Intl.message(
      'Failed to load item sessions: $error',
      name: 'screensPlayerPlayHistoryViewFailedToLoadItemSessions',
      desc: '',
      args: [error],
    );
  }

  /// `Queue is empty`
  String get screensPlayerQueueQueueIsEmpty {
    return Intl.message('Queue is empty', name: 'screensPlayerQueueQueueIsEmpty', desc: '', args: []);
  }

  /// `Loading title...`
  String get screensPlayerQueueLoadingTitle {
    return Intl.message('Loading title...', name: 'screensPlayerQueueLoadingTitle', desc: '', args: []);
  }

  /// `and {remaining} more to load`
  String screensPlayerQueueAndMoreToLoad(Object remaining) {
    return Intl.message(
      'and $remaining more to load',
      name: 'screensPlayerQueueAndMoreToLoad',
      desc: '',
      args: [remaining],
    );
  }

  /// `Load more`
  String get screensPlayerQueueLoadMore {
    return Intl.message('Load more', name: 'screensPlayerQueueLoadMore', desc: '', args: []);
  }

  /// `Remove from queue`
  String get screensPlayerQueueRemoveFromQueue {
    return Intl.message('Remove from queue', name: 'screensPlayerQueueRemoveFromQueue', desc: '', args: []);
  }

  /// `Subtitles are disabled in player settings.`
  String get screensPlayerSubtitleReadingModeSubtitlesAreDisabledInPlayerSettings {
    return Intl.message(
      'Subtitles are disabled in player settings.',
      name: 'screensPlayerSubtitleReadingModeSubtitlesAreDisabledInPlayerSettings',
      desc: '',
      args: [],
    );
  }

  /// `Start playback to use continuous subtitle reading mode.`
  String get screensPlayerSubtitleReadingModeStartPlaybackToUseContinuousSubtitle {
    return Intl.message(
      'Start playback to use continuous subtitle reading mode.',
      name: 'screensPlayerSubtitleReadingModeStartPlaybackToUseContinuousSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `No subtitles available for this title.`
  String get screensPlayerSubtitleReadingModeNoSubtitlesAvailableForThisTitle {
    return Intl.message(
      'No subtitles available for this title.',
      name: 'screensPlayerSubtitleReadingModeNoSubtitlesAvailableForThisTitle',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for subtitle cue...`
  String get screensPlayerSubtitleReadingModeWaitingForSubtitleCue {
    return Intl.message(
      'Waiting for subtitle cue...',
      name: 'screensPlayerSubtitleReadingModeWaitingForSubtitleCue',
      desc: '',
      args: [],
    );
  }

  /// `Ebook Reader`
  String get screensReaderReaderBuildersEbookReader {
    return Intl.message('Ebook Reader', name: 'screensReaderReaderBuildersEbookReader', desc: '', args: []);
  }

  /// `Highlight`
  String get screensReaderReaderBuildersHighlight {
    return Intl.message('Highlight', name: 'screensReaderReaderBuildersHighlight', desc: '', args: []);
  }

  /// `Underline`
  String get screensReaderReaderBuildersUnderline {
    return Intl.message('Underline', name: 'screensReaderReaderBuildersUnderline', desc: '', args: []);
  }

  /// `Bookmark`
  String get screensReaderReaderBuildersBookmark {
    return Intl.message('Bookmark', name: 'screensReaderReaderBuildersBookmark', desc: '', args: []);
  }

  /// `View Annotations`
  String get screensReaderReaderBuildersViewAnnotations {
    return Intl.message('View Annotations', name: 'screensReaderReaderBuildersViewAnnotations', desc: '', args: []);
  }

  /// `No authenticated user available.`
  String get screensReaderReaderNoAuthenticatedUserAvailable {
    return Intl.message(
      'No authenticated user available.',
      name: 'screensReaderReaderNoAuthenticatedUserAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Missing authentication token for ebook loading.`
  String get screensReaderReaderMissingAuthenticationTokenForEbookLoading {
    return Intl.message(
      'Missing authentication token for ebook loading.',
      name: 'screensReaderReaderMissingAuthenticationTokenForEbookLoading',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user profile: {error}`
  String screensReaderReaderFailedToLoadUserProfile(Object error) {
    return Intl.message(
      'Failed to load user profile: $error',
      name: 'screensReaderReaderFailedToLoadUserProfile',
      desc: '',
      args: [error],
    );
  }

  /// `Failed to load ebook metadata: {error}`
  String screensReaderReaderFailedToLoadEbookMetadata(Object error) {
    return Intl.message(
      'Failed to load ebook metadata: $error',
      name: 'screensReaderReaderFailedToLoadEbookMetadata',
      desc: '',
      args: [error],
    );
  }

  /// `Cancel`
  String get screensReaderReaderPdfHelpersCancel {
    return Intl.message('Cancel', name: 'screensReaderReaderPdfHelpersCancel', desc: '', args: []);
  }

  /// `Save`
  String get screensReaderReaderPdfHelpersSave {
    return Intl.message('Save', name: 'screensReaderReaderPdfHelpersSave', desc: '', args: []);
  }

  /// `Edit bookmark`
  String get screensReaderReaderPdfHelpersEditBookmark {
    return Intl.message('Edit bookmark', name: 'screensReaderReaderPdfHelpersEditBookmark', desc: '', args: []);
  }

  /// `Delete annotation`
  String get screensReaderReaderPdfHelpersDeleteAnnotation {
    return Intl.message('Delete annotation', name: 'screensReaderReaderPdfHelpersDeleteAnnotation', desc: '', args: []);
  }

  /// `Text`
  String get screensReaderReaderPdfHelpersText {
    return Intl.message('Text', name: 'screensReaderReaderPdfHelpersText', desc: '', args: []);
  }

  /// `Add an optional note`
  String get screensReaderReaderPdfHelpersAddAnOptionalNote {
    return Intl.message(
      'Add an optional note',
      name: 'screensReaderReaderPdfHelpersAddAnOptionalNote',
      desc: '',
      args: [],
    );
  }

  /// `Highlight removed`
  String get screensReaderWidgetsReaderEpubAnnotationsListViewHighlightRemoved {
    return Intl.message(
      'Highlight removed',
      name: 'screensReaderWidgetsReaderEpubAnnotationsListViewHighlightRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Error removing highlight: {e}`
  String screensReaderWidgetsReaderEpubAnnotationsListViewErrorRemovingHighlight(Object e) {
    return Intl.message(
      'Error removing highlight: $e',
      name: 'screensReaderWidgetsReaderEpubAnnotationsListViewErrorRemovingHighlight',
      desc: '',
      args: [e],
    );
  }

  /// `Underline removed`
  String get screensReaderWidgetsReaderEpubAnnotationsListViewUnderlineRemoved {
    return Intl.message(
      'Underline removed',
      name: 'screensReaderWidgetsReaderEpubAnnotationsListViewUnderlineRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Error removing underline: {e}`
  String screensReaderWidgetsReaderEpubAnnotationsListViewErrorRemovingUnderline(Object e) {
    return Intl.message(
      'Error removing underline: $e',
      name: 'screensReaderWidgetsReaderEpubAnnotationsListViewErrorRemovingUnderline',
      desc: '',
      args: [e],
    );
  }

  /// `Bookmark removed`
  String get screensReaderWidgetsReaderEpubAnnotationsListViewBookmarkRemoved {
    return Intl.message(
      'Bookmark removed',
      name: 'screensReaderWidgetsReaderEpubAnnotationsListViewBookmarkRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Error removing bookmark: {e}`
  String screensReaderWidgetsReaderEpubAnnotationsListViewErrorRemovingBookmark(Object e) {
    return Intl.message(
      'Error removing bookmark: $e',
      name: 'screensReaderWidgetsReaderEpubAnnotationsListViewErrorRemovingBookmark',
      desc: '',
      args: [e],
    );
  }

  /// `Annotations`
  String get screensReaderWidgetsReaderEpubAnnotationsListViewAnnotations {
    return Intl.message(
      'Annotations',
      name: 'screensReaderWidgetsReaderEpubAnnotationsListViewAnnotations',
      desc: '',
      args: [],
    );
  }

  /// `No annotations found`
  String get screensReaderWidgetsReaderEpubAnnotationsListViewNoAnnotationsFound {
    return Intl.message(
      'No annotations found',
      name: 'screensReaderWidgetsReaderEpubAnnotationsListViewNoAnnotationsFound',
      desc: '',
      args: [],
    );
  }

  /// `Annotations`
  String get screensReaderWidgetsReaderPdfAnnotationsListViewAnnotations {
    return Intl.message(
      'Annotations',
      name: 'screensReaderWidgetsReaderPdfAnnotationsListViewAnnotations',
      desc: '',
      args: [],
    );
  }

  /// `No annotations found`
  String get screensReaderWidgetsReaderPdfAnnotationsListViewNoAnnotationsFound {
    return Intl.message(
      'No annotations found',
      name: 'screensReaderWidgetsReaderPdfAnnotationsListViewNoAnnotationsFound',
      desc: '',
      args: [],
    );
  }

  /// `Page {p1}`
  String screensReaderWidgetsReaderPdfAnnotationsListViewPage(Object p1) {
    return Intl.message('Page $p1', name: 'screensReaderWidgetsReaderPdfAnnotationsListViewPage', desc: '', args: [p1]);
  }

  /// `Range {p1}-{p2}`
  String screensReaderWidgetsReaderPdfAnnotationsListViewRange(Object p1, Object p2) {
    return Intl.message(
      'Range $p1-$p2',
      name: 'screensReaderWidgetsReaderPdfAnnotationsListViewRange',
      desc: '',
      args: [p1, p2],
    );
  }

  /// `Page {p1} ({p2}px)`
  String screensReaderWidgetsReaderPdfAnnotationsListViewPagePx(Object p1, Object p2) {
    return Intl.message(
      'Page $p1 (${p2}px)',
      name: 'screensReaderWidgetsReaderPdfAnnotationsListViewPagePx',
      desc: '',
      args: [p1, p2],
    );
  }

  /// `Edit bookmark`
  String get screensReaderWidgetsReaderPdfAnnotationsListViewEditBookmark {
    return Intl.message(
      'Edit bookmark',
      name: 'screensReaderWidgetsReaderPdfAnnotationsListViewEditBookmark',
      desc: '',
      args: [],
    );
  }

  /// `Delete annotation`
  String get screensReaderWidgetsReaderPdfAnnotationsListViewDeleteAnnotation {
    return Intl.message(
      'Delete annotation',
      name: 'screensReaderWidgetsReaderPdfAnnotationsListViewDeleteAnnotation',
      desc: '',
      args: [],
    );
  }

  /// `Select Underline Thickness`
  String get screensReaderWidgetsReaderThicknessPickerSheetSelectUnderlineThickness {
    return Intl.message(
      'Select Underline Thickness',
      name: 'screensReaderWidgetsReaderThicknessPickerSheetSelectUnderlineThickness',
      desc: '',
      args: [],
    );
  }

  /// `{p1}px`
  String screensReaderWidgetsReaderThicknessPickerSheetPx(Object p1) {
    return Intl.message('${p1}px', name: 'screensReaderWidgetsReaderThicknessPickerSheetPx', desc: '', args: [p1]);
  }

  /// `Item Metadata Utils`
  String get screensSettingsAdminItemMetadataUtilsSettingsItemMetadataUtils {
    return Intl.message(
      'Item Metadata Utils',
      name: 'screensSettingsAdminItemMetadataUtilsSettingsItemMetadataUtils',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get screensSettingsAdminItemMetadataUtilsSettingsBack {
    return Intl.message('Back', name: 'screensSettingsAdminItemMetadataUtilsSettingsBack', desc: '', args: []);
  }

  /// `Listening Sessions`
  String get screensSettingsAdminServerSessionsSettingsListeningSessions {
    return Intl.message(
      'Listening Sessions',
      name: 'screensSettingsAdminServerSessionsSettingsListeningSessions',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get screensSettingsAdminServerSessionsSettingsBack {
    return Intl.message('Back', name: 'screensSettingsAdminServerSessionsSettingsBack', desc: '', args: []);
  }

  /// `No active user. Sign in to open admin server settings.`
  String get screensSettingsAdminServerSettingsNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to open admin server settings.',
      name: 'screensSettingsAdminServerSettingsNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `You currently are managing the server {managedServer}`
  String screensSettingsAdminServerSettingsYouCurrentlyAreManagingTheServer(Object managedServer) {
    return Intl.message(
      'You currently are managing the server $managedServer',
      name: 'screensSettingsAdminServerSettingsYouCurrentlyAreManagingTheServer',
      desc: '',
      args: [managedServer],
    );
  }

  /// `Failed to load user settings: {error}`
  String screensSettingsAdminServerSettingsFailedToLoadUserSettings(Object error) {
    return Intl.message(
      'Failed to load user settings: $error',
      name: 'screensSettingsAdminServerSettingsFailedToLoadUserSettings',
      desc: '',
      args: [error],
    );
  }

  /// `Failed to update sort field: {e}`
  String screensSettingsAndroidAutoAndroidAutoLibrarySettingsFailedToUpdateSortField(Object e) {
    return Intl.message(
      'Failed to update sort field: $e',
      name: 'screensSettingsAndroidAutoAndroidAutoLibrarySettingsFailedToUpdateSortField',
      desc: '',
      args: [e],
    );
  }

  /// `No active user. Sign in to configure Android Auto library settings.`
  String get screensSettingsAndroidAutoAndroidAutoLibrarySettingsNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to configure Android Auto library settings.',
      name: 'screensSettingsAndroidAutoAndroidAutoLibrarySettingsNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get screensSettingsAndroidAutoAndroidAutoLibrarySettingsTitle {
    return Intl.message('Title', name: 'screensSettingsAndroidAutoAndroidAutoLibrarySettingsTitle', desc: '', args: []);
  }

  /// `Author`
  String get screensSettingsAndroidAutoAndroidAutoLibrarySettingsAuthor {
    return Intl.message(
      'Author',
      name: 'screensSettingsAndroidAutoAndroidAutoLibrarySettingsAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Date Added`
  String get screensSettingsAndroidAutoAndroidAutoLibrarySettingsDateAdded {
    return Intl.message(
      'Date Added',
      name: 'screensSettingsAndroidAutoAndroidAutoLibrarySettingsDateAdded',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user settings: {error}`
  String screensSettingsAndroidAutoAndroidAutoLibrarySettingsFailedToLoadUserSettings(Object error) {
    return Intl.message(
      'Failed to load user settings: $error',
      name: 'screensSettingsAndroidAutoAndroidAutoLibrarySettingsFailedToLoadUserSettings',
      desc: '',
      args: [error],
    );
  }

  /// `Sort By`
  String get screensSettingsAndroidAutoAndroidAutoLibrarySettingsSortBy {
    return Intl.message(
      'Sort By',
      name: 'screensSettingsAndroidAutoAndroidAutoLibrarySettingsSortBy',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update sort field: {e}`
  String screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsFailedToUpdateSortField(Object e) {
    return Intl.message(
      'Failed to update sort field: $e',
      name: 'screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsFailedToUpdateSortField',
      desc: '',
      args: [e],
    );
  }

  /// `No active user. Sign in to configure Android Auto podcast settings.`
  String get screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to configure Android Auto podcast settings.',
      name: 'screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsTitle {
    return Intl.message(
      'Title',
      name: 'screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Author`
  String get screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsAuthor {
    return Intl.message(
      'Author',
      name: 'screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Date Added`
  String get screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsDateAdded {
    return Intl.message(
      'Date Added',
      name: 'screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsDateAdded',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user settings: {error}`
  String screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsFailedToLoadUserSettings(Object error) {
    return Intl.message(
      'Failed to load user settings: $error',
      name: 'screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsFailedToLoadUserSettings',
      desc: '',
      args: [error],
    );
  }

  /// `Sort By`
  String get screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsSortBy {
    return Intl.message(
      'Sort By',
      name: 'screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsSortBy',
      desc: '',
      args: [],
    );
  }

  /// `AAOS mode active`
  String get screensSettingsAndroidAutoSettingsAaosModeActive {
    return Intl.message(
      'AAOS mode active',
      name: 'screensSettingsAndroidAutoSettingsAaosModeActive',
      desc: '',
      args: [],
    );
  }

  /// `AAOS Settings`
  String get screensSettingsAndroidAutoSettingsAaosSettings {
    return Intl.message('AAOS Settings', name: 'screensSettingsAndroidAutoSettingsAaosSettings', desc: '', args: []);
  }

  /// `Android Auto Settings`
  String get screensSettingsAndroidAutoSettingsAndroidAutoSettings {
    return Intl.message(
      'Android Auto Settings',
      name: 'screensSettingsAndroidAutoSettingsAndroidAutoSettings',
      desc: '',
      args: [],
    );
  }

  /// `For now there are no additional AAOS-specific settings.`
  String get screensSettingsAndroidAutoSettingsForNowThereAreNoAdditional {
    return Intl.message(
      'For now there are no additional AAOS-specific settings.',
      name: 'screensSettingsAndroidAutoSettingsForNowThereAreNoAdditional',
      desc: '',
      args: [],
    );
  }

  /// `No active user. Sign in to configure Android Auto browse settings.`
  String get screensSettingsAndroidAutoSettingsNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to configure Android Auto browse settings.',
      name: 'screensSettingsAndroidAutoSettingsNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user settings: {error}`
  String screensSettingsAndroidAutoSettingsFailedToLoadUserSettings(Object error) {
    return Intl.message(
      'Failed to load user settings: $error',
      name: 'screensSettingsAndroidAutoSettingsFailedToLoadUserSettings',
      desc: '',
      args: [error],
    );
  }

  /// `Download location updated.`
  String get screensSettingsLibrarySettingsDownloadLocationUpdated {
    return Intl.message(
      'Download location updated.',
      name: 'screensSettingsLibrarySettingsDownloadLocationUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update location: {e}`
  String screensSettingsLibrarySettingsFailedToUpdateLocation(Object e) {
    return Intl.message(
      'Failed to update location: $e',
      name: 'screensSettingsLibrarySettingsFailedToUpdateLocation',
      desc: '',
      args: [e],
    );
  }

  /// `Using default download location.`
  String get screensSettingsLibrarySettingsUsingDefaultDownloadLocation {
    return Intl.message(
      'Using default download location.',
      name: 'screensSettingsLibrarySettingsUsingDefaultDownloadLocation',
      desc: '',
      args: [],
    );
  }

  /// `Choose folder`
  String get screensSettingsLibrarySettingsChooseFolder {
    return Intl.message('Choose folder', name: 'screensSettingsLibrarySettingsChooseFolder', desc: '', args: []);
  }

  /// `Use default location`
  String get screensSettingsLibrarySettingsUseDefaultLocation {
    return Intl.message(
      'Use default location',
      name: 'screensSettingsLibrarySettingsUseDefaultLocation',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update collapse series setting: {e}`
  String screensSettingsLibrarySettingsFailedToUpdateCollapseSeriesSetting(Object e) {
    return Intl.message(
      'Failed to update collapse series setting: $e',
      name: 'screensSettingsLibrarySettingsFailedToUpdateCollapseSeriesSetting',
      desc: '',
      args: [e],
    );
  }

  /// `No active user. Sign in to configure download settings.`
  String get screensSettingsLibrarySettingsNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to configure download settings.',
      name: 'screensSettingsLibrarySettingsNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `Collapse Series`
  String get screensSettingsLibrarySettingsCollapseSeries {
    return Intl.message('Collapse Series', name: 'screensSettingsLibrarySettingsCollapseSeries', desc: '', args: []);
  }

  /// `Failed to load user settings: {error}`
  String screensSettingsLibrarySettingsFailedToLoadUserSettings(Object error) {
    return Intl.message(
      'Failed to load user settings: $error',
      name: 'screensSettingsLibrarySettingsFailedToLoadUserSettings',
      desc: '',
      args: [error],
    );
  }

  /// `No logs to copy.`
  String get screensSettingsLogViewNoLogsToCopy {
    return Intl.message('No logs to copy.', name: 'screensSettingsLogViewNoLogsToCopy', desc: '', args: []);
  }

  /// `Raw logs copied to clipboard!`
  String get screensSettingsLogViewRawLogsCopiedToClipboard {
    return Intl.message(
      'Raw logs copied to clipboard!',
      name: 'screensSettingsLogViewRawLogsCopiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `GitHub formatted logs copied to clipboard!`
  String get screensSettingsLogViewGithubFormattedLogsCopiedToClipboard {
    return Intl.message(
      'GitHub formatted logs copied to clipboard!',
      name: 'screensSettingsLogViewGithubFormattedLogsCopiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `No logs to export.`
  String get screensSettingsLogViewNoLogsToExport {
    return Intl.message('No logs to export.', name: 'screensSettingsLogViewNoLogsToExport', desc: '', args: []);
  }

  /// `Logs exported to .log file ({destinationDescription}): {p1}`
  String screensSettingsLogViewLogsExportedToLogFile(Object destinationDescription, Object p1) {
    return Intl.message(
      'Logs exported to .log file ($destinationDescription): $p1',
      name: 'screensSettingsLogViewLogsExportedToLogFile',
      desc: '',
      args: [destinationDescription, p1],
    );
  }

  /// `Failed to export logs: {error}`
  String screensSettingsLogViewFailedToExportLogs(Object error) {
    return Intl.message(
      'Failed to export logs: $error',
      name: 'screensSettingsLogViewFailedToExportLogs',
      desc: '',
      args: [error],
    );
  }

  /// `Loading logs...`
  String get screensSettingsLogViewLoadingLogs {
    return Intl.message('Loading logs...', name: 'screensSettingsLogViewLoadingLogs', desc: '', args: []);
  }

  /// `No logs yet`
  String get screensSettingsLogViewNoLogsYet {
    return Intl.message('No logs yet', name: 'screensSettingsLogViewNoLogsYet', desc: '', args: []);
  }

  /// `Logs will appear here as they are generated.`
  String get screensSettingsLogViewLogsWillAppearHereAsThey {
    return Intl.message(
      'Logs will appear here as they are generated.',
      name: 'screensSettingsLogViewLogsWillAppearHereAsThey',
      desc: '',
      args: [],
    );
  }

  /// `Copy Raw`
  String get screensSettingsLogViewCopyRaw {
    return Intl.message('Copy Raw', name: 'screensSettingsLogViewCopyRaw', desc: '', args: []);
  }

  /// `Copy GitHub`
  String get screensSettingsLogViewCopyGitHub {
    return Intl.message('Copy GitHub', name: 'screensSettingsLogViewCopyGitHub', desc: '', args: []);
  }

  /// `Auto-scroll`
  String get screensSettingsLogViewAutoScroll {
    return Intl.message('Auto-scroll', name: 'screensSettingsLogViewAutoScroll', desc: '', args: []);
  }

  /// `Scroll to top`
  String get screensSettingsLogViewScrollToTop {
    return Intl.message('Scroll to top', name: 'screensSettingsLogViewScrollToTop', desc: '', args: []);
  }

  /// `Scroll to bottom`
  String get screensSettingsLogViewScrollToBottom {
    return Intl.message('Scroll to bottom', name: 'screensSettingsLogViewScrollToBottom', desc: '', args: []);
  }

  /// `Shake Controls`
  String get screensSettingsPlayerWidgetsShakeSettingsSectionShakeControls {
    return Intl.message(
      'Shake Controls',
      name: 'screensSettingsPlayerWidgetsShakeSettingsSectionShakeControls',
      desc: '',
      args: [],
    );
  }

  /// `No active user. Sign in to configure subtitle settings.`
  String get screensSettingsPlayerWidgetsSubtitleSettingsSectionNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to configure subtitle settings.',
      name: 'screensSettingsPlayerWidgetsSubtitleSettingsSectionNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `Subtitles`
  String get screensSettingsPlayerWidgetsSubtitleSettingsSectionSubtitles {
    return Intl.message(
      'Subtitles',
      name: 'screensSettingsPlayerWidgetsSubtitleSettingsSectionSubtitles',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load subtitle settings: {error}`
  String screensSettingsPlayerWidgetsSubtitleSettingsSectionUnableToLoadSubtitleSettings(Object error) {
    return Intl.message(
      'Unable to load subtitle settings: $error',
      name: 'screensSettingsPlayerWidgetsSubtitleSettingsSectionUnableToLoadSubtitleSettings',
      desc: '',
      args: [error],
    );
  }

  /// `Reader-specific settings will appear here.`
  String get screensSettingsReaderSettingsReaderSpecificSettingsWillAppearHere {
    return Intl.message(
      'Reader-specific settings will appear here.',
      name: 'screensSettingsReaderSettingsReaderSpecificSettingsWillAppearHere',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid external server URL.`
  String get screensSettingsServerConnectionSettingsPleaseEnterAValidExternalServer {
    return Intl.message(
      'Please enter a valid external server URL.',
      name: 'screensSettingsServerConnectionSettingsPleaseEnterAValidExternalServer',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid local server URL or leave it blank.`
  String get screensSettingsServerConnectionSettingsPleaseEnterAValidLocalServer {
    return Intl.message(
      'Please enter a valid local server URL or leave it blank.',
      name: 'screensSettingsServerConnectionSettingsPleaseEnterAValidLocalServer',
      desc: '',
      args: [],
    );
  }

  /// `Enter password to update username or credentials.`
  String get screensSettingsServerConnectionSettingsEnterPasswordToUpdateUsernameOr {
    return Intl.message(
      'Enter password to update username or credentials.',
      name: 'screensSettingsServerConnectionSettingsEnterPasswordToUpdateUsernameOr',
      desc: '',
      args: [],
    );
  }

  /// `Credential validation returned no data.`
  String get screensSettingsServerConnectionSettingsCredentialValidationReturnedNoData {
    return Intl.message(
      'Credential validation returned no data.',
      name: 'screensSettingsServerConnectionSettingsCredentialValidationReturnedNoData',
      desc: '',
      args: [],
    );
  }

  /// `Credentials belong to a different account. Use Add Account instead.`
  String get screensSettingsServerConnectionSettingsCredentialsBelongToDifferentAccountUseAddAccount {
    return Intl.message(
      'Credentials belong to a different account. Use Add Account instead.',
      name: 'screensSettingsServerConnectionSettingsCredentialsBelongToDifferentAccountUseAddAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid external URL.`
  String get screensSettingsServerConnectionSettingsEnterAValidExternalUrl {
    return Intl.message(
      'Enter a valid external URL.',
      name: 'screensSettingsServerConnectionSettingsEnterAValidExternalUrl',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid local URL or leave blank.`
  String get screensSettingsServerConnectionSettingsEnterAValidLocalUrlOrLeaveBlank {
    return Intl.message(
      'Enter a valid local URL or leave blank.',
      name: 'screensSettingsServerConnectionSettingsEnterAValidLocalUrlOrLeaveBlank',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be empty.`
  String get screensSettingsServerConnectionSettingsUsernameCannotBeEmpty {
    return Intl.message(
      'Username cannot be empty.',
      name: 'screensSettingsServerConnectionSettingsUsernameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Server settings saved.`
  String get screensSettingsServerConnectionSettingsServerSettingsSaved {
    return Intl.message(
      'Server settings saved.',
      name: 'screensSettingsServerConnectionSettingsServerSettingsSaved',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save server settings: {e}`
  String screensSettingsServerConnectionSettingsFailedToSaveServerSettings(Object e) {
    return Intl.message(
      'Failed to save server settings: $e',
      name: 'screensSettingsServerConnectionSettingsFailedToSaveServerSettings',
      desc: '',
      args: [e],
    );
  }

  /// `Failed to save server settings.`
  String get screensSettingsServerConnectionSettingsFailedToSaveServerSettingsPlain {
    return Intl.message(
      'Failed to save server settings.',
      name: 'screensSettingsServerConnectionSettingsFailedToSaveServerSettingsPlain',
      desc: '',
      args: [],
    );
  }

  /// `No active user. Sign in before editing server settings.`
  String get screensSettingsServerConnectionSettingsNoActiveUserSignInBefore {
    return Intl.message(
      'No active user. Sign in before editing server settings.',
      name: 'screensSettingsServerConnectionSettingsNoActiveUserSignInBefore',
      desc: '',
      args: [],
    );
  }

  /// `Server Connection`
  String get screensSettingsServerConnectionSettingsTitle {
    return Intl.message('Server Connection', name: 'screensSettingsServerConnectionSettingsTitle', desc: '', args: []);
  }

  /// `Server Endpoints`
  String get screensSettingsServerConnectionSettingsServerEndpoints {
    return Intl.message(
      'Server Endpoints',
      name: 'screensSettingsServerConnectionSettingsServerEndpoints',
      desc: '',
      args: [],
    );
  }

  /// `The app will try local first and fall back to external when local is unreachable.`
  String get screensSettingsServerConnectionSettingsTheAppWillTryLocalFirst {
    return Intl.message(
      'The app will try local first and fall back to external when local is unreachable.',
      name: 'screensSettingsServerConnectionSettingsTheAppWillTryLocalFirst',
      desc: '',
      args: [],
    );
  }

  /// `Credentials`
  String get screensSettingsServerConnectionSettingsCredentials {
    return Intl.message('Credentials', name: 'screensSettingsServerConnectionSettingsCredentials', desc: '', args: []);
  }

  /// `Leave password empty to keep current credentials and update only server URLs.`
  String get screensSettingsServerConnectionSettingsLeavePasswordEmptyToKeepCurrent {
    return Intl.message(
      'Leave password empty to keep current credentials and update only server URLs.',
      name: 'screensSettingsServerConnectionSettingsLeavePasswordEmptyToKeepCurrent',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user: {error}`
  String screensSettingsServerConnectionSettingsFailedToLoadUser(Object error) {
    return Intl.message(
      'Failed to load user: $error',
      name: 'screensSettingsServerConnectionSettingsFailedToLoadUser',
      desc: '',
      args: [error],
    );
  }

  /// `External Server URL`
  String get screensSettingsServerConnectionSettingsExternalServerURL {
    return Intl.message(
      'External Server URL',
      name: 'screensSettingsServerConnectionSettingsExternalServerURL',
      desc: '',
      args: [],
    );
  }

  /// `https://your-audiobookshelf.example`
  String get screensSettingsServerConnectionSettingsHttpsYourAudiobookshelfExample {
    return Intl.message(
      'https://your-audiobookshelf.example',
      name: 'screensSettingsServerConnectionSettingsHttpsYourAudiobookshelfExample',
      desc: '',
      args: [],
    );
  }

  /// `Local Server URL (Optional)`
  String get screensSettingsServerConnectionSettingsLocalServerURLOptional {
    return Intl.message(
      'Local Server URL (Optional)',
      name: 'screensSettingsServerConnectionSettingsLocalServerURLOptional',
      desc: '',
      args: [],
    );
  }

  /// `http://192.168.1.25:13378`
  String get screensSettingsServerConnectionSettingsHttp19216812513378 {
    return Intl.message(
      'http://192.168.1.25:13378',
      name: 'screensSettingsServerConnectionSettingsHttp19216812513378',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get screensSettingsServerConnectionSettingsUsername {
    return Intl.message('Username', name: 'screensSettingsServerConnectionSettingsUsername', desc: '', args: []);
  }

  /// `Password`
  String get screensSettingsServerConnectionSettingsPassword {
    return Intl.message('Password', name: 'screensSettingsServerConnectionSettingsPassword', desc: '', args: []);
  }

  /// `Required only when changing credentials`
  String get screensSettingsServerConnectionSettingsRequiredOnlyWhenChangingCredentials {
    return Intl.message(
      'Required only when changing credentials',
      name: 'screensSettingsServerConnectionSettingsRequiredOnlyWhenChangingCredentials',
      desc: '',
      args: [],
    );
  }

  /// `No active user. Sign in to manage server management visibility settings.`
  String get screensSettingsServerManagementSettingsNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to manage server management visibility settings.',
      name: 'screensSettingsServerManagementSettingsNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user settings: {error}`
  String screensSettingsServerManagementSettingsFailedToLoadUserSettings(Object error) {
    return Intl.message(
      'Failed to load user settings: $error',
      name: 'screensSettingsServerManagementSettingsFailedToLoadUserSettings',
      desc: '',
      args: [error],
    );
  }

  /// `Back`
  String get screensSettingsSettingsPageScaffoldBack {
    return Intl.message('Back', name: 'screensSettingsSettingsPageScaffoldBack', desc: '', args: []);
  }

  /// `Deleted user {p1}`
  String screensSettingsSettingsScreenDeletedUser(Object p1) {
    return Intl.message('Deleted user $p1', name: 'screensSettingsSettingsScreenDeletedUser', desc: '', args: [p1]);
  }

  /// `Failed to delete user {p1}: {e}`
  String screensSettingsSettingsScreenFailedToDeleteUser(Object e, Object p1) {
    return Intl.message(
      'Failed to delete user $p1: $e',
      name: 'screensSettingsSettingsScreenFailedToDeleteUser',
      desc: '',
      args: [e, p1],
    );
  }

  /// `Switched to {p1}`
  String screensSettingsSettingsScreenSwitchedTo(Object p1) {
    return Intl.message('Switched to $p1', name: 'screensSettingsSettingsScreenSwitchedTo', desc: '', args: [p1]);
  }

  /// `Delete User?`
  String get screensSettingsSettingsScreenDeleteUser {
    return Intl.message('Delete User?', name: 'screensSettingsSettingsScreenDeleteUser', desc: '', args: []);
  }

  /// `Are you sure you want to delete "{p1}"? This action cannot be undone.`
  String screensSettingsSettingsScreenAreYouSureYouWantTo(Object p1) {
    return Intl.message(
      'Are you sure you want to delete "$p1"? This action cannot be undone.',
      name: 'screensSettingsSettingsScreenAreYouSureYouWantTo',
      desc: '',
      args: [p1],
    );
  }

  /// `Cancel`
  String get screensSettingsSettingsScreenCancel {
    return Intl.message('Cancel', name: 'screensSettingsSettingsScreenCancel', desc: '', args: []);
  }

  /// `Delete`
  String get screensSettingsSettingsScreenDelete {
    return Intl.message('Delete', name: 'screensSettingsSettingsScreenDelete', desc: '', args: []);
  }

  /// `Sign Out Current Account?`
  String get screensSettingsSettingsScreenSignOutCurrentAccount {
    return Intl.message(
      'Sign Out Current Account?',
      name: 'screensSettingsSettingsScreenSignOutCurrentAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign out from "{p1}" on this device?`
  String screensSettingsSettingsScreenSignOutFromOnThisDevice(Object p1) {
    return Intl.message(
      'Sign out from "$p1" on this device?',
      name: 'screensSettingsSettingsScreenSignOutFromOnThisDevice',
      desc: '',
      args: [p1],
    );
  }

  /// `Sign Out`
  String get screensSettingsSettingsScreenSignOut {
    return Intl.message('Sign Out', name: 'screensSettingsSettingsScreenSignOut', desc: '', args: []);
  }

  /// `ACTIVE ACCOUNT`
  String get screensSettingsSettingsScreenActiveACCOUNT {
    return Intl.message('ACTIVE ACCOUNT', name: 'screensSettingsSettingsScreenActiveACCOUNT', desc: '', args: []);
  }

  /// `No active user.`
  String get screensSettingsSettingsScreenNoActiveUser {
    return Intl.message('No active user.', name: 'screensSettingsSettingsScreenNoActiveUser', desc: '', args: []);
  }

  /// `Manage Accounts`
  String get screensSettingsSettingsScreenManageAccounts {
    return Intl.message('Manage Accounts', name: 'screensSettingsSettingsScreenManageAccounts', desc: '', args: []);
  }

  /// `Add Account`
  String get screensSettingsSettingsScreenAddAccount {
    return Intl.message('Add Account', name: 'screensSettingsSettingsScreenAddAccount', desc: '', args: []);
  }

  /// `Error loading user data: {e}`
  String screensSettingsSettingsScreenErrorLoadingUserData(Object e) {
    return Intl.message(
      'Error loading user data: $e',
      name: 'screensSettingsSettingsScreenErrorLoadingUserData',
      desc: '',
      args: [e],
    );
  }

  /// `Current Account`
  String get screensSettingsSettingsScreenCurrentAccount {
    return Intl.message('Current Account', name: 'screensSettingsSettingsScreenCurrentAccount', desc: '', args: []);
  }

  /// `Other Accounts`
  String get screensSettingsSettingsScreenOtherAccounts {
    return Intl.message('Other Accounts', name: 'screensSettingsSettingsScreenOtherAccounts', desc: '', args: []);
  }

  /// `No other accounts available.`
  String get screensSettingsSettingsScreenNoOtherAccountsAvailable {
    return Intl.message(
      'No other accounts available.',
      name: 'screensSettingsSettingsScreenNoOtherAccountsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No server`
  String get screensSettingsSettingsScreenNoServer {
    return Intl.message('No server', name: 'screensSettingsSettingsScreenNoServer', desc: '', args: []);
  }

  /// `Car Integration`
  String get screensSettingsSettingsScreenCarIntegration {
    return Intl.message('Car Integration', name: 'screensSettingsSettingsScreenCarIntegration', desc: '', args: []);
  }

  /// `Open Car Library`
  String get screensSettingsSettingsScreenOpenCarLibrary {
    return Intl.message('Open Car Library', name: 'screensSettingsSettingsScreenOpenCarLibrary', desc: '', args: []);
  }

  /// `Switch to the system Media Center`
  String get screensSettingsSettingsScreenSwitchToTheSystemMediaCenter {
    return Intl.message(
      'Switch to the system Media Center',
      name: 'screensSettingsSettingsScreenSwitchToTheSystemMediaCenter',
      desc: '',
      args: [],
    );
  }

  /// `Application Settings`
  String get screensSettingsSettingsScreenApplicationSettings {
    return Intl.message(
      'Application Settings',
      name: 'screensSettingsSettingsScreenApplicationSettings',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get screensSettingsSettingsScreenAppearance {
    return Intl.message('Appearance', name: 'screensSettingsSettingsScreenAppearance', desc: '', args: []);
  }

  /// `Global Player`
  String get screensSettingsSettingsScreenGlobalPlayer {
    return Intl.message('Global Player', name: 'screensSettingsSettingsScreenGlobalPlayer', desc: '', args: []);
  }

  /// `Ebook-Reader Settings`
  String get screensSettingsSettingsScreenEbookReaderSettings {
    return Intl.message(
      'Ebook-Reader Settings',
      name: 'screensSettingsSettingsScreenEbookReaderSettings',
      desc: '',
      args: [],
    );
  }

  /// `Library Behaviour`
  String get screensSettingsSettingsScreenLibraryBehaviour {
    return Intl.message('Library Behaviour', name: 'screensSettingsSettingsScreenLibraryBehaviour', desc: '', args: []);
  }

  /// `Caching`
  String get screensSettingsSettingsScreenCaching {
    return Intl.message('Caching', name: 'screensSettingsSettingsScreenCaching', desc: '', args: []);
  }

  /// `About & Support`
  String get screensSettingsSettingsScreenAboutAndSupport {
    return Intl.message('About & Support', name: 'screensSettingsSettingsScreenAboutAndSupport', desc: '', args: []);
  }

  /// `View on GitHub`
  String get screensSettingsSettingsScreenViewOnGitHub {
    return Intl.message('View on GitHub', name: 'screensSettingsSettingsScreenViewOnGitHub', desc: '', args: []);
  }

  /// `Report an Issue`
  String get screensSettingsSettingsScreenReportAnIssue {
    return Intl.message('Report an Issue', name: 'screensSettingsSettingsScreenReportAnIssue', desc: '', args: []);
  }

  /// `Logs`
  String get screensSettingsSettingsScreenLogs {
    return Intl.message('Logs', name: 'screensSettingsSettingsScreenLogs', desc: '', args: []);
  }

  /// `Information & Attribution`
  String get screensSettingsSettingsScreenInformationAndAttribution {
    return Intl.message(
      'Information & Attribution',
      name: 'screensSettingsSettingsScreenInformationAndAttribution',
      desc: '',
      args: [],
    );
  }

  /// `Licenses, app version, and attribution details.`
  String get screensSettingsSettingsScreenLicensesAppVersionAndAttribution {
    return Intl.message(
      'Licenses, app version, and attribution details.',
      name: 'screensSettingsSettingsScreenLicensesAppVersionAndAttribution',
      desc: '',
      args: [],
    );
  }

  /// `Navigate to View on GitHub`
  String get screensSettingsSettingsScreenNavigateToViewOnGitHub {
    return Intl.message(
      'Navigate to View on GitHub',
      name: 'screensSettingsSettingsScreenNavigateToViewOnGitHub',
      desc: '',
      args: [],
    );
  }

  /// `Navigate to Report an Issue`
  String get screensSettingsSettingsScreenNavigateToReportAnIssue {
    return Intl.message(
      'Navigate to Report an Issue',
      name: 'screensSettingsSettingsScreenNavigateToReportAnIssue',
      desc: '',
      args: [],
    );
  }

  /// `Sign out this account`
  String get screensSettingsSettingsScreenSignOutThisAccount {
    return Intl.message(
      'Sign out this account',
      name: 'screensSettingsSettingsScreenSignOutThisAccount',
      desc: '',
      args: [],
    );
  }

  /// `Switch to this user`
  String get screensSettingsSettingsScreenSwitchToThisUser {
    return Intl.message(
      'Switch to this user',
      name: 'screensSettingsSettingsScreenSwitchToThisUser',
      desc: '',
      args: [],
    );
  }

  /// `Delete this user`
  String get screensSettingsSettingsScreenDeleteThisUser {
    return Intl.message('Delete this user', name: 'screensSettingsSettingsScreenDeleteThisUser', desc: '', args: []);
  }

  /// `No active user. Sign in to configure tools.`
  String get screensSettingsToolsSettingsNoActiveUserSignInTo {
    return Intl.message(
      'No active user. Sign in to configure tools.',
      name: 'screensSettingsToolsSettingsNoActiveUserSignInTo',
      desc: '',
      args: [],
    );
  }

  /// `These tools add functionality beyond standard ABS behavior. They coordinate multiple API calls to accomplish a task, so edge cases can happen. All tools are disabled by default. Enabling a tool can add controls to the UI, while other tools live only in subpages below.`
  String get screensSettingsToolsSettingsTheseToolsAddFunctionalityBeyondStandard {
    return Intl.message(
      'These tools add functionality beyond standard ABS behavior. They coordinate multiple API calls to accomplish a task, so edge cases can happen. All tools are disabled by default. Enabling a tool can add controls to the UI, while other tools live only in subpages below.',
      name: 'screensSettingsToolsSettingsTheseToolsAddFunctionalityBeyondStandard',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load user settings: {error}`
  String screensSettingsToolsSettingsFailedToLoadUserSettings(Object error) {
    return Intl.message(
      'Failed to load user settings: $error',
      name: 'screensSettingsToolsSettingsFailedToLoadUserSettings',
      desc: '',
      args: [error],
    );
  }

  /// `{splitType, select, tags{Split Tags} genres{Split Genres} other{Split Metadata Terms}}`
  String adminSplitMetadataTermsToolLabel(String splitType) {
    return Intl.select(
      splitType,
      {'tags': 'Split Tags', 'genres': 'Split Genres', 'other': 'Split Metadata Terms'},
      name: 'adminSplitMetadataTermsToolLabel',
      desc: '',
      args: [splitType],
    );
  }

  /// `Split {termsSplit} composite {noun} value(s), touched {itemsChanged} item(s), and applied {itemsUpdated} update(s) across {librariesProcessed, plural, =1{1 library} other{{librariesProcessed} libraries}}.`
  String adminSplitMetadataTermsToolResultSummary(
    Object itemsChanged,
    Object itemsUpdated,
    int librariesProcessed,
    Object noun,
    Object termsSplit,
  ) {
    return Intl.message(
      'Split $termsSplit composite $noun value(s), touched $itemsChanged item(s), and applied $itemsUpdated update(s) across ${Intl.plural(librariesProcessed, one: '1 library', other: '$librariesProcessed libraries')}.',
      name: 'adminSplitMetadataTermsToolResultSummary',
      desc: '',
      args: [itemsChanged, itemsUpdated, librariesProcessed, noun, termsSplit],
    );
  }

  /// `Failed to load libraries: {error}`
  String adminSplitMetadataTermsToolFailedToLoadLibraries(Object error) {
    return Intl.message(
      'Failed to load libraries: $error',
      name: 'adminSplitMetadataTermsToolFailedToLoadLibraries',
      desc: '',
      args: [error],
    );
  }

  /// `Select at least one library.`
  String get adminSplitMetadataTermsToolSelectAtLeastOneLibrary {
    return Intl.message(
      'Select at least one library.',
      name: 'adminSplitMetadataTermsToolSelectAtLeastOneLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Delimiter cannot be empty.`
  String get adminSplitMetadataTermsToolDelimiterCannotBeEmpty {
    return Intl.message(
      'Delimiter cannot be empty.',
      name: 'adminSplitMetadataTermsToolDelimiterCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Failed to split {noun}: {error}`
  String adminSplitMetadataTermsToolFailedToSplit(Object error, Object noun) {
    return Intl.message(
      'Failed to split $noun: $error',
      name: 'adminSplitMetadataTermsToolFailedToSplit',
      desc: '',
      args: [error, noun],
    );
  }

  /// `Running...`
  String get adminSplitMetadataTermsToolRunning {
    return Intl.message('Running...', name: 'adminSplitMetadataTermsToolRunning', desc: '', args: []);
  }

  /// `Run Tool`
  String get adminSplitMetadataTermsToolRunTool {
    return Intl.message('Run Tool', name: 'adminSplitMetadataTermsToolRunTool', desc: '', args: []);
  }

  /// `Processed {libraries, plural, =1{1 library} other{{libraries} libraries}} and tagged {tagged} item(s). Server reported {updated} updated item(s).`
  String adminForceMetadataRefreshToolResultSummary(int libraries, Object tagged, Object updated) {
    return Intl.message(
      'Processed ${Intl.plural(libraries, one: '1 library', other: '$libraries libraries')} and tagged $tagged item(s). Server reported $updated updated item(s).',
      name: 'adminForceMetadataRefreshToolResultSummary',
      desc: '',
      args: [libraries, tagged, updated],
    );
  }

  /// `Failed to load libraries: {error}`
  String adminForceMetadataRefreshToolFailedToLoadLibraries(Object error) {
    return Intl.message(
      'Failed to load libraries: $error',
      name: 'adminForceMetadataRefreshToolFailedToLoadLibraries',
      desc: '',
      args: [error],
    );
  }

  /// `Select at least one library.`
  String get adminForceMetadataRefreshToolSelectAtLeastOneLibrary {
    return Intl.message(
      'Select at least one library.',
      name: 'adminForceMetadataRefreshToolSelectAtLeastOneLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Force metadata refresh failed: {error}`
  String adminForceMetadataRefreshToolFailed(Object error) {
    return Intl.message(
      'Force metadata refresh failed: $error',
      name: 'adminForceMetadataRefreshToolFailed',
      desc: '',
      args: [error],
    );
  }

  /// `Running...`
  String get adminForceMetadataRefreshToolRunning {
    return Intl.message('Running...', name: 'adminForceMetadataRefreshToolRunning', desc: '', args: []);
  }

  /// `Run Tool`
  String get adminForceMetadataRefreshToolRunTool {
    return Intl.message('Run Tool', name: 'adminForceMetadataRefreshToolRunTool', desc: '', args: []);
  }

  /// `Series`
  String get authorDetailSeriesTitle {
    return Intl.message('Series', name: 'authorDetailSeriesTitle', desc: '', args: []);
  }

  /// `{count, plural, =1{1 series} other{{count} series groups}}`
  String authorDetailSeriesCount(int count) {
    return Intl.plural(
      count,
      one: '1 series',
      other: '$count series groups',
      name: 'authorDetailSeriesCount',
      desc: '',
      args: [count],
    );
  }

  /// `No series found for this author.`
  String get authorDetailNoSeriesFoundForThisAuthor {
    return Intl.message(
      'No series found for this author.',
      name: 'authorDetailNoSeriesFoundForThisAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Books`
  String get authorDetailBooksTitle {
    return Intl.message('Books', name: 'authorDetailBooksTitle', desc: '', args: []);
  }

  /// `{count, plural, =1{1 book} other{{count} books}}`
  String authorDetailBookCount(int count) {
    return Intl.plural(
      count,
      one: '1 book',
      other: '$count books',
      name: 'authorDetailBookCount',
      desc: '',
      args: [count],
    );
  }

  /// `No books found for this author.`
  String get authorDetailNoBooksFoundForThisAuthor {
    return Intl.message(
      'No books found for this author.',
      name: 'authorDetailNoBooksFoundForThisAuthor',
      desc: '',
      args: [],
    );
  }

  /// `Open series`
  String get authorDetailOpenSeries {
    return Intl.message('Open series', name: 'authorDetailOpenSeries', desc: '', args: []);
  }

  /// `{missingCount, plural, =1{1 playlist entry is not directly displayable.} other{{missingCount} playlist entries are not directly displayable.}}`
  String playlistDetailMissingEntriesMessage(int missingCount) {
    return Intl.plural(
      missingCount,
      one: '1 playlist entry is not directly displayable.',
      other: '$missingCount playlist entries are not directly displayable.',
      name: 'playlistDetailMissingEntriesMessage',
      desc: '',
      args: [missingCount],
    );
  }

  /// `<summary>Logs ({count, plural, =1{1 entry} other{{count} entries}})</summary>`
  String settingsLogViewSummaryLogs(int count) {
    return Intl.message(
      '<summary>Logs (${Intl.plural(count, one: '1 entry', other: '$count entries')})</summary>',
      name: 'settingsLogViewSummaryLogs',
      desc: '',
      args: [count],
    );
  }

  /// `selected location`
  String get settingsLogViewSelectedLocation {
    return Intl.message('selected location', name: 'settingsLogViewSelectedLocation', desc: '', args: []);
  }

  /// `app storage fallback location`
  String get settingsLogViewAppStorageFallbackLocation {
    return Intl.message(
      'app storage fallback location',
      name: 'settingsLogViewAppStorageFallbackLocation',
      desc: '',
      args: [],
    );
  }

  /// `Logs`
  String get settingsLogViewTitle {
    return Intl.message('Logs', name: 'settingsLogViewTitle', desc: '', args: []);
  }

  /// `Exporting .log...`
  String get settingsLogViewExportingLog {
    return Intl.message('Exporting .log...', name: 'settingsLogViewExportingLog', desc: '', args: []);
  }

  /// `Export .log`
  String get settingsLogViewExportLog {
    return Intl.message('Export .log', name: 'settingsLogViewExportLog', desc: '', args: []);
  }

  /// `{count, plural, =1{1 entry} other{{count} entries}}`
  String settingsLogViewEntriesCount(int count) {
    return Intl.plural(
      count,
      one: '1 entry',
      other: '$count entries',
      name: 'settingsLogViewEntriesCount',
      desc: '',
      args: [count],
    );
  }

  /// `Highlights`
  String get readerEpubAnnotationsHighlights {
    return Intl.message('Highlights', name: 'readerEpubAnnotationsHighlights', desc: '', args: []);
  }

  /// `Highlight`
  String get readerEpubAnnotationsTypeHighlight {
    return Intl.message('Highlight', name: 'readerEpubAnnotationsTypeHighlight', desc: '', args: []);
  }

  /// `Underlines`
  String get readerEpubAnnotationsUnderlines {
    return Intl.message('Underlines', name: 'readerEpubAnnotationsUnderlines', desc: '', args: []);
  }

  /// `Underline`
  String get readerEpubAnnotationsTypeUnderline {
    return Intl.message('Underline', name: 'readerEpubAnnotationsTypeUnderline', desc: '', args: []);
  }

  /// `Bookmarks`
  String get readerEpubAnnotationsBookmarks {
    return Intl.message('Bookmarks', name: 'readerEpubAnnotationsBookmarks', desc: '', args: []);
  }

  /// `Untitled bookmark`
  String get readerEpubAnnotationsUntitledBookmark {
    return Intl.message('Untitled bookmark', name: 'readerEpubAnnotationsUntitledBookmark', desc: '', args: []);
  }

  /// `CFI: {cfi}`
  String readerEpubAnnotationsCfi(Object cfi) {
    return Intl.message('CFI: $cfi', name: 'readerEpubAnnotationsCfi', desc: '', args: [cfi]);
  }

  /// `Current position: {position}`
  String playerBookmarksSheetCurrentPosition(Object position) {
    return Intl.message(
      'Current position: $position',
      name: 'playerBookmarksSheetCurrentPosition',
      desc: '',
      args: [position],
    );
  }

  /// `Adding bookmark...`
  String get playerBookmarksSheetAddingBookmark {
    return Intl.message('Adding bookmark...', name: 'playerBookmarksSheetAddingBookmark', desc: '', args: []);
  }

  /// `Create bookmark`
  String get playerBookmarksSheetCreateBookmark {
    return Intl.message('Create bookmark', name: 'playerBookmarksSheetCreateBookmark', desc: '', args: []);
  }

  /// `Untitled bookmark`
  String get playerBookmarksSheetUntitledBookmark {
    return Intl.message('Untitled bookmark', name: 'playerBookmarksSheetUntitledBookmark', desc: '', args: []);
  }

  /// `{count, plural, =1{1 file remaining} other{{count} files remaining}}`
  String downloadStatusFilesRemaining(int count) {
    return Intl.plural(
      count,
      one: '1 file remaining',
      other: '$count files remaining',
      name: 'downloadStatusFilesRemaining',
      desc: '',
      args: [count],
    );
  }

  /// `Checking Authors...`
  String get authorCleanupCheckingAuthors {
    return Intl.message('Checking Authors...', name: 'authorCleanupCheckingAuthors', desc: '', args: []);
  }

  /// `Remove Authors Without Books`
  String get authorCleanupRemoveAuthorsWithoutBooks {
    return Intl.message(
      'Remove Authors Without Books',
      name: 'authorCleanupRemoveAuthorsWithoutBooks',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{Delete 1 Author?} other{Delete {count} Authors?}}`
  String authorCleanupDeleteAuthorsTitle(int count) {
    return Intl.plural(
      count,
      one: 'Delete 1 Author?',
      other: 'Delete $count Authors?',
      name: 'authorCleanupDeleteAuthorsTitle',
      desc: '',
      args: [count],
    );
  }

  /// `{completed}/{total}`
  String authorCleanupProgressCount(Object completed, Object total) {
    return Intl.message('$completed/$total', name: 'authorCleanupProgressCount', desc: '', args: [completed, total]);
  }

  /// `{count, plural, =1{this download} other{these {count} downloads}}`
  String downloadsDeleteConfirmTarget(int count) {
    return Intl.plural(
      count,
      one: 'this download',
      other: 'these $count downloads',
      name: 'downloadsDeleteConfirmTarget',
      desc: '',
      args: [count],
    );
  }

  /// `{deletedItems, plural, =0{Deleted no items} =1{Deleted 1 item} other{Deleted {deletedItems} items}}, {deletedFiles, plural, =0{removed no files} =1{removed 1 file} other{removed {deletedFiles} files}}.{failedFiles, plural, =0{ } =1{ 1 file could not be removed.} other{ {failedFiles} files could not be removed.}}{failedItems, plural, =0{ } =1{ 1 item failed to delete.} other{ {failedItems} items failed to delete.}}`
  String downloadsDeleteSummary(int deletedFiles, int deletedItems, int failedFiles, int failedItems) {
    return Intl.message(
      '${Intl.plural(deletedItems, zero: 'Deleted no items', one: 'Deleted 1 item', other: 'Deleted $deletedItems items')}, ${Intl.plural(deletedFiles, zero: 'removed no files', one: 'removed 1 file', other: 'removed $deletedFiles files')}.${Intl.plural(failedFiles, zero: ' ', one: ' 1 file could not be removed.', other: ' $failedFiles files could not be removed.')}${Intl.plural(failedItems, zero: ' ', one: ' 1 item failed to delete.', other: ' $failedItems items failed to delete.')}',
      name: 'downloadsDeleteSummary',
      desc: '',
      args: [deletedFiles, deletedItems, failedFiles, failedItems],
    );
  }

  /// `Unknown error`
  String get commonUnknownError {
    return Intl.message('Unknown error', name: 'commonUnknownError', desc: '', args: []);
  }

  /// `Loading...`
  String get commonLoading {
    return Intl.message('Loading...', name: 'commonLoading', desc: '', args: []);
  }

  /// `Saving...`
  String get commonSaving {
    return Intl.message('Saving...', name: 'commonSaving', desc: '', args: []);
  }

  /// `Save changes`
  String get commonSaveChanges {
    return Intl.message('Save changes', name: 'commonSaveChanges', desc: '', args: []);
  }

  /// `Search`
  String get commonSearch {
    return Intl.message('Search', name: 'commonSearch', desc: '', args: []);
  }

  /// `Searching...`
  String get commonSearching {
    return Intl.message('Searching...', name: 'commonSearching', desc: '', args: []);
  }

  /// `Play`
  String get commonPlay {
    return Intl.message('Play', name: 'commonPlay', desc: '', args: []);
  }

  /// `Pause`
  String get commonPause {
    return Intl.message('Pause', name: 'commonPause', desc: '', args: []);
  }

  /// `Resume`
  String get commonResume {
    return Intl.message('Resume', name: 'commonResume', desc: '', args: []);
  }

  /// `Replay`
  String get commonReplay {
    return Intl.message('Replay', name: 'commonReplay', desc: '', args: []);
  }

  /// `Sign In`
  String get commonSignIn {
    return Intl.message('Sign In', name: 'commonSignIn', desc: '', args: []);
  }

  /// `Signing in...`
  String get commonSigningIn {
    return Intl.message('Signing in...', name: 'commonSigningIn', desc: '', args: []);
  }

  /// `Connect with API Key`
  String get commonConnectWithApiKey {
    return Intl.message('Connect with API Key', name: 'commonConnectWithApiKey', desc: '', args: []);
  }

  /// `Show password`
  String get commonShowPassword {
    return Intl.message('Show password', name: 'commonShowPassword', desc: '', args: []);
  }

  /// `Hide password`
  String get commonHidePassword {
    return Intl.message('Hide password', name: 'commonHidePassword', desc: '', args: []);
  }

  /// `Change`
  String get commonChange {
    return Intl.message('Change', name: 'commonChange', desc: '', args: []);
  }

  /// `Choose`
  String get commonChoose {
    return Intl.message('Choose', name: 'commonChoose', desc: '', args: []);
  }

  /// `Task Activity`
  String get commonTaskActivity {
    return Intl.message('Task Activity', name: 'commonTaskActivity', desc: '', args: []);
  }

  /// `Tasks`
  String get commonTasks {
    return Intl.message('Tasks', name: 'commonTasks', desc: '', args: []);
  }

  /// `Activities`
  String get commonActivities {
    return Intl.message('Activities', name: 'commonActivities', desc: '', args: []);
  }

  /// `User enabled.`
  String get commonUserEnabled {
    return Intl.message('User enabled.', name: 'commonUserEnabled', desc: '', args: []);
  }

  /// `User disabled.`
  String get commonUserDisabled {
    return Intl.message('User disabled.', name: 'commonUserDisabled', desc: '', args: []);
  }

  /// `OpenID link removed.`
  String get commonOpenIdLinkRemoved {
    return Intl.message('OpenID link removed.', name: 'commonOpenIdLinkRemoved', desc: '', args: []);
  }

  /// `Could not unlink OpenID.`
  String get commonCouldNotUnlinkOpenId {
    return Intl.message('Could not unlink OpenID.', name: 'commonCouldNotUnlinkOpenId', desc: '', args: []);
  }

  /// `AAOS`
  String get commonAaos {
    return Intl.message('AAOS', name: 'commonAaos', desc: '', args: []);
  }

  /// `Android Auto`
  String get commonAndroidAuto {
    return Intl.message('Android Auto', name: 'commonAndroidAuto', desc: '', args: []);
  }

  /// `Unable to load downloads`
  String get downloadsUnableToLoad {
    return Intl.message('Unable to load downloads', name: 'downloadsUnableToLoad', desc: '', args: []);
  }

  /// `{count, plural, =1{1 selected} other{{count} selected}}`
  String downloadsSelectedCount(int count) {
    return Intl.plural(
      count,
      one: '1 selected',
      other: '$count selected',
      name: 'downloadsSelectedCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{1 downloaded item} other{{count} downloaded items}}`
  String downloadsDownloadedItemsCount(int count) {
    return Intl.plural(
      count,
      one: '1 downloaded item',
      other: '$count downloaded items',
      name: 'downloadsDownloadedItemsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Scanning Authors`
  String get authorCleanupScanningAuthorsTitle {
    return Intl.message('Scanning Authors', name: 'authorCleanupScanningAuthorsTitle', desc: '', args: []);
  }

  /// `Preparing to load authors...`
  String get authorCleanupPreparingToLoadAuthors {
    return Intl.message(
      'Preparing to load authors...',
      name: 'authorCleanupPreparingToLoadAuthors',
      desc: '',
      args: [],
    );
  }

  /// `Deleting Authors`
  String get authorCleanupDeletingAuthorsTitle {
    return Intl.message('Deleting Authors', name: 'authorCleanupDeletingAuthorsTitle', desc: '', args: []);
  }

  /// `Deleting {authorName} ({current}/{total})...`
  String authorCleanupDeletingAuthorProgress(Object authorName, Object current, Object total) {
    return Intl.message(
      'Deleting $authorName ($current/$total)...',
      name: 'authorCleanupDeletingAuthorProgress',
      desc: '',
      args: [authorName, current, total],
    );
  }

  /// `{deletedCount, plural, =0{Deleted no authors without books.} =1{Deleted 1 author without books.} other{Deleted {deletedCount} authors without books.}}{failedCount, plural, =0{ } =1{ 1 author failed: {failedPreview}} other{ {failedCount} authors failed: {failedPreview}}}`
  String authorCleanupDeletionResultSummary(int deletedCount, int failedCount, Object failedPreview) {
    return Intl.message(
      '${Intl.plural(deletedCount, zero: 'Deleted no authors without books.', one: 'Deleted 1 author without books.', other: 'Deleted $deletedCount authors without books.')}${Intl.plural(failedCount, zero: ' ', one: ' 1 author failed: $failedPreview', other: ' $failedCount authors failed: $failedPreview')}',
      name: 'authorCleanupDeletionResultSummary',
      desc: '',
      args: [deletedCount, failedCount, failedPreview],
    );
  }

  /// `Loading page {page} (size {pageSize})...`
  String authorCleanupLoadingPage(Object page, Object pageSize) {
    return Intl.message(
      'Loading page $page (size $pageSize)...',
      name: 'authorCleanupLoadingPage',
      desc: '',
      args: [page, pageSize],
    );
  }

  /// `Checked {scannedAuthors} authors, found {authorsWithoutBooks} with 0 books.`
  String authorCleanupCheckedAuthorsSummary(Object authorsWithoutBooks, Object scannedAuthors) {
    return Intl.message(
      'Checked $scannedAuthors authors, found $authorsWithoutBooks with 0 books.',
      name: 'authorCleanupCheckedAuthorsSummary',
      desc: '',
      args: [authorsWithoutBooks, scannedAuthors],
    );
  }

  /// `{count, plural, =1{1 book} other{{count} books}}`
  String authorCleanupBookCount(int count) {
    return Intl.plural(
      count,
      one: '1 book',
      other: '$count books',
      name: 'authorCleanupBookCount',
      desc: '',
      args: [count],
    );
  }

  /// `Add to playlist`
  String get libraryMultiSelectAddToPlaylistTitle {
    return Intl.message('Add to playlist', name: 'libraryMultiSelectAddToPlaylistTitle', desc: '', args: []);
  }

  /// `No editable playlists found.`
  String get libraryMultiSelectNoEditablePlaylistsFound {
    return Intl.message(
      'No editable playlists found.',
      name: 'libraryMultiSelectNoEditablePlaylistsFound',
      desc: '',
      args: [],
    );
  }

  /// `Could not load playlists.`
  String get libraryMultiSelectCouldNotLoadPlaylists {
    return Intl.message(
      'Could not load playlists.',
      name: 'libraryMultiSelectCouldNotLoadPlaylists',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{Added 1 book to "{targetTitle}".} other{Added {count} books to "{targetTitle}".}}`
  String libraryMultiSelectAddedBooksToPlaylist(int count, Object targetTitle) {
    return Intl.plural(
      count,
      one: 'Added 1 book to "$targetTitle".',
      other: 'Added $count books to "$targetTitle".',
      name: 'libraryMultiSelectAddedBooksToPlaylist',
      desc: '',
      args: [count, targetTitle],
    );
  }

  /// `Could not add books to playlist.`
  String get libraryMultiSelectCouldNotAddBooksToPlaylist {
    return Intl.message(
      'Could not add books to playlist.',
      name: 'libraryMultiSelectCouldNotAddBooksToPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Add to collection`
  String get libraryMultiSelectAddToCollectionTitle {
    return Intl.message('Add to collection', name: 'libraryMultiSelectAddToCollectionTitle', desc: '', args: []);
  }

  /// `No collections found.`
  String get libraryMultiSelectNoCollectionsFound {
    return Intl.message('No collections found.', name: 'libraryMultiSelectNoCollectionsFound', desc: '', args: []);
  }

  /// `Could not load collections.`
  String get libraryMultiSelectCouldNotLoadCollections {
    return Intl.message(
      'Could not load collections.',
      name: 'libraryMultiSelectCouldNotLoadCollections',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{Added 1 book to "{targetTitle}".} other{Added {count} books to "{targetTitle}".}}`
  String libraryMultiSelectAddedBooksToCollection(int count, Object targetTitle) {
    return Intl.plural(
      count,
      one: 'Added 1 book to "$targetTitle".',
      other: 'Added $count books to "$targetTitle".',
      name: 'libraryMultiSelectAddedBooksToCollection',
      desc: '',
      args: [count, targetTitle],
    );
  }

  /// `Could not add books to collection.`
  String get libraryMultiSelectCouldNotAddBooksToCollection {
    return Intl.message(
      'Could not add books to collection.',
      name: 'libraryMultiSelectCouldNotAddBooksToCollection',
      desc: '',
      args: [],
    );
  }

  /// `Quick match selected books`
  String get libraryMultiSelectQuickMatchSelectedBooksTitle {
    return Intl.message(
      'Quick match selected books',
      name: 'libraryMultiSelectQuickMatchSelectedBooksTitle',
      desc: '',
      args: [],
    );
  }

  /// `Pick a provider and choose whether cover/details should overwrite current metadata.`
  String get libraryMultiSelectQuickMatchSelectedBooksDescription {
    return Intl.message(
      'Pick a provider and choose whether cover/details should overwrite current metadata.',
      name: 'libraryMultiSelectQuickMatchSelectedBooksDescription',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{Run for 1} other{Run for {count}}}`
  String libraryMultiSelectQuickMatchRunFor(int count) {
    return Intl.plural(
      count,
      one: 'Run for 1',
      other: 'Run for $count',
      name: 'libraryMultiSelectQuickMatchRunFor',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{Metadata change request sent for 1 book.} other{Metadata change request sent for {count} books.}}`
  String libraryMultiSelectMetadataChangeRequestSentForBooks(int count) {
    return Intl.plural(
      count,
      one: 'Metadata change request sent for 1 book.',
      other: 'Metadata change request sent for $count books.',
      name: 'libraryMultiSelectMetadataChangeRequestSentForBooks',
      desc: '',
      args: [count],
    );
  }

  /// `Metadata change request sent.`
  String get libraryMultiSelectMetadataChangeRequestSent {
    return Intl.message(
      'Metadata change request sent.',
      name: 'libraryMultiSelectMetadataChangeRequestSent',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{Metadata change request completed. 1 book updated.} other{Metadata change request completed. {count} books updated.}}`
  String libraryMultiSelectMetadataChangeCompletedWithUpdates(int count) {
    return Intl.plural(
      count,
      one: 'Metadata change request completed. 1 book updated.',
      other: 'Metadata change request completed. $count books updated.',
      name: 'libraryMultiSelectMetadataChangeCompletedWithUpdates',
      desc: '',
      args: [count],
    );
  }

  /// `Metadata change request completed.`
  String get libraryMultiSelectMetadataChangeCompleted {
    return Intl.message(
      'Metadata change request completed.',
      name: 'libraryMultiSelectMetadataChangeCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Deleted "{title}" from Audiobookshelf and file system.`
  String itemDeleteDeletedTitleFromAbsAndFileSystem(Object title) {
    return Intl.message(
      'Deleted "$title" from Audiobookshelf and file system.',
      name: 'itemDeleteDeletedTitleFromAbsAndFileSystem',
      desc: '',
      args: [title],
    );
  }

  /// `Deleted "{title}" from Audiobookshelf.`
  String itemDeleteDeletedTitleFromAbs(Object title) {
    return Intl.message(
      'Deleted "$title" from Audiobookshelf.',
      name: 'itemDeleteDeletedTitleFromAbs',
      desc: '',
      args: [title],
    );
  }

  /// `Could not delete audiobook.`
  String get itemDeleteCouldNotDeleteAudiobook {
    return Intl.message('Could not delete audiobook.', name: 'itemDeleteCouldNotDeleteAudiobook', desc: '', args: []);
  }

  /// `{count, plural, =1{Deleted 1 audiobook from Audiobookshelf and file system.} other{Deleted {count} audiobooks from Audiobookshelf and file system.}}`
  String itemDeleteBulkDeletedFromAbsAndFileSystem(int count) {
    return Intl.plural(
      count,
      one: 'Deleted 1 audiobook from Audiobookshelf and file system.',
      other: 'Deleted $count audiobooks from Audiobookshelf and file system.',
      name: 'itemDeleteBulkDeletedFromAbsAndFileSystem',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{Deleted 1 audiobook from Audiobookshelf.} other{Deleted {count} audiobooks from Audiobookshelf.}}`
  String itemDeleteBulkDeletedFromAbs(int count) {
    return Intl.plural(
      count,
      one: 'Deleted 1 audiobook from Audiobookshelf.',
      other: 'Deleted $count audiobooks from Audiobookshelf.',
      name: 'itemDeleteBulkDeletedFromAbs',
      desc: '',
      args: [count],
    );
  }

  /// `Could not delete selected audiobooks.`
  String get itemDeleteCouldNotDeleteSelectedAudiobooks {
    return Intl.message(
      'Could not delete selected audiobooks.',
      name: 'itemDeleteCouldNotDeleteSelectedAudiobooks',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{Added 1 upload item.} other{Added {count} upload items.}}`
  String libraryUploadPanelAddedUploadItems(int count) {
    return Intl.plural(
      count,
      one: 'Added 1 upload item.',
      other: 'Added $count upload items.',
      name: 'libraryUploadPanelAddedUploadItems',
      desc: '',
      args: [count],
    );
  }

  /// `{attempt, plural, =1{Uploading...} other{Retrying upload ({attempt}/{maxAttempts})...}}`
  String libraryUploadPanelUploadAttemptMessage(int attempt, Object maxAttempts) {
    return Intl.plural(
      attempt,
      one: 'Uploading...',
      other: 'Retrying upload ($attempt/$maxAttempts)...',
      name: 'libraryUploadPanelUploadAttemptMessage',
      desc: '',
      args: [attempt, maxAttempts],
    );
  }

  /// `{failedFiles, plural, =0{ } =1{ 1 file could not be removed.} other{ {failedFiles} files could not be removed.}}`
  String downloadDeleteFailedSuffix(int failedFiles) {
    return Intl.plural(
      failedFiles,
      zero: ' ',
      one: ' 1 file could not be removed.',
      other: ' $failedFiles files could not be removed.',
      name: 'downloadDeleteFailedSuffix',
      desc: '',
      args: [failedFiles],
    );
  }

  /// `Error loading author details`
  String get authorDetailErrorLoadingDetails {
    return Intl.message('Error loading author details', name: 'authorDetailErrorLoadingDetails', desc: '', args: []);
  }

  /// `Error loading authors`
  String get authorsViewErrorLoadingAuthors {
    return Intl.message('Error loading authors', name: 'authorsViewErrorLoadingAuthors', desc: '', args: []);
  }

  /// `Error loading series books`
  String get seriesDetailErrorLoadingSeriesBooks {
    return Intl.message('Error loading series books', name: 'seriesDetailErrorLoadingSeriesBooks', desc: '', args: []);
  }

  /// `Expand sidebar`
  String get layoutHomeExpandSidebar {
    return Intl.message('Expand sidebar', name: 'layoutHomeExpandSidebar', desc: '', args: []);
  }

  /// `Collapse sidebar`
  String get layoutHomeCollapseSidebar {
    return Intl.message('Collapse sidebar', name: 'layoutHomeCollapseSidebar', desc: '', args: []);
  }

  /// `{count, plural, =1{1 selected} other{{count} selected}}`
  String layoutHomeSelectedCount(int count) {
    return Intl.plural(
      count,
      one: '1 selected',
      other: '$count selected',
      name: 'layoutHomeSelectedCount',
      desc: '',
      args: [count],
    );
  }

  /// `{days, plural, =1{1 day} other{{days} days}}`
  String statsAdvancedLongestStreakDays(int days) {
    return Intl.plural(
      days,
      one: '1 day',
      other: '$days days',
      name: 'statsAdvancedLongestStreakDays',
      desc: '',
      args: [days],
    );
  }

  /// `{count, plural, =1{1 book in series} other{{count} books in series}}`
  String libraryItemWidgetBooksInSeries(int count) {
    return Intl.plural(
      count,
      one: '1 book in series',
      other: '$count books in series',
      name: 'libraryItemWidgetBooksInSeries',
      desc: '',
      args: [count],
    );
  }

  /// `Marked "{itemTitle}" as {state, select, finished{finished} unfinished{unfinished} other{{state}}}.`
  String itemProgressMarkedItemAs(String state, Object itemTitle) {
    return Intl.message(
      'Marked "$itemTitle" as ${Intl.select(state, {'finished': 'finished', 'unfinished': 'unfinished', 'other': '$state'})}.',
      name: 'itemProgressMarkedItemAs',
      desc: '',
      args: [state, itemTitle],
    );
  }

  /// `Could not mark item as {state, select, finished{finished} unfinished{unfinished} other{{state}}}.`
  String itemProgressCouldNotMarkItemAs(String state) {
    return Intl.message(
      'Could not mark item as ${Intl.select(state, {'finished': 'finished', 'unfinished': 'unfinished', 'other': '$state'})}.',
      name: 'itemProgressCouldNotMarkItemAs',
      desc: '',
      args: [state],
    );
  }

  /// `Episode`
  String get commonEpisode {
    return Intl.message('Episode', name: 'commonEpisode', desc: '', args: []);
  }

  /// `Marked "{episodeTitle}" as {state, select, finished{finished} unfinished{unfinished} other{{state}}}.`
  String itemProgressMarkedEpisodeAs(String state, Object episodeTitle) {
    return Intl.message(
      'Marked "$episodeTitle" as ${Intl.select(state, {'finished': 'finished', 'unfinished': 'unfinished', 'other': '$state'})}.',
      name: 'itemProgressMarkedEpisodeAs',
      desc: '',
      args: [state, episodeTitle],
    );
  }

  /// `Could not mark episode as {state, select, finished{finished} unfinished{unfinished} other{{state}}}.`
  String itemProgressCouldNotMarkEpisodeAs(String state) {
    return Intl.message(
      'Could not mark episode as ${Intl.select(state, {'finished': 'finished', 'unfinished': 'unfinished', 'other': '$state'})}.',
      name: 'itemProgressCouldNotMarkEpisodeAs',
      desc: '',
      args: [state],
    );
  }

  /// `{count, plural, =1{Marked 1 selected item as {state, select, finished{finished} unfinished{unfinished} other{{state}}}.} other{Marked {count} selected items as {state, select, finished{finished} unfinished{unfinished} other{{state}}}.}}`
  String itemProgressMarkedSelectedItemsAs(int count, String state) {
    return Intl.plural(
      count,
      one: 'Marked 1 selected item as {state, select, finished{finished} unfinished{unfinished} other{{state}}}.',
      other:
          'Marked {count} selected items as {state, select, finished{finished} unfinished{unfinished} other{{state}}}.',
      name: 'itemProgressMarkedSelectedItemsAs',
      desc: '',
      args: [count, state],
    );
  }

  /// `Could not mark selected items as {state, select, finished{finished} unfinished{unfinished} other{{state}}}.`
  String itemProgressCouldNotMarkSelectedItemsAs(String state) {
    return Intl.message(
      'Could not mark selected items as ${Intl.select(state, {'finished': 'finished', 'unfinished': 'unfinished', 'other': '$state'})}.',
      name: 'itemProgressCouldNotMarkSelectedItemsAs',
      desc: '',
      args: [state],
    );
  }

  /// `No tasks are currently running.`
  String get taskNotificationNoTasksRunning {
    return Intl.message('No tasks are currently running.', name: 'taskNotificationNoTasksRunning', desc: '', args: []);
  }

  /// `{count, plural, =1{1 task running} other{{count} tasks running}}`
  String taskNotificationTasksRunning(int count) {
    return Intl.plural(
      count,
      one: '1 task running',
      other: '$count tasks running',
      name: 'taskNotificationTasksRunning',
      desc: '',
      args: [count],
    );
  }

  /// `{channels, plural, =1{Mono} other{Stereo}}`
  String libraryItemEncoderChannelDisplay(int channels) {
    return Intl.plural(
      channels,
      one: 'Mono',
      other: 'Stereo',
      name: 'libraryItemEncoderChannelDisplay',
      desc: '',
      args: [channels],
    );
  }

  /// `{count, plural, =1{1 provider} other{{count} providers}}`
  String manualMatchCollapsedProvidersCount(int count) {
    return Intl.plural(
      count,
      one: '1 provider',
      other: '$count providers',
      name: 'manualMatchCollapsedProvidersCount',
      desc: '',
      args: [count],
    );
  }

  /// `Title: {title}`
  String manualMatchCollapsedTitleSummary(Object title) {
    return Intl.message('Title: $title', name: 'manualMatchCollapsedTitleSummary', desc: '', args: [title]);
  }

  /// `Author: {author}`
  String manualMatchCollapsedAuthorSummary(Object author) {
    return Intl.message('Author: $author', name: 'manualMatchCollapsedAuthorSummary', desc: '', args: [author]);
  }

  /// `Tap to edit search filters`
  String get manualMatchCollapsedTapToEditFilters {
    return Intl.message('Tap to edit search filters', name: 'manualMatchCollapsedTapToEditFilters', desc: '', args: []);
  }

  /// `No results yet`
  String get manualMatchResultsNoResultsYet {
    return Intl.message('No results yet', name: 'manualMatchResultsNoResultsYet', desc: '', args: []);
  }

  /// `{count, plural, =1{1 result} other{{count} results}}`
  String manualMatchResultsCount(int count) {
    return Intl.plural(
      count,
      one: '1 result',
      other: '$count results',
      name: 'manualMatchResultsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Canceled {taskTitle}.`
  String componentsAppDownloadStatusCanceledDownloadTask(Object taskTitle) {
    return Intl.message(
      'Canceled $taskTitle.',
      name: 'componentsAppDownloadStatusCanceledDownloadTask',
      desc: '',
      args: [taskTitle],
    );
  }

  /// `Could not cancel {taskTitle}.`
  String componentsAppDownloadStatusCouldNotCancelDownloadTask(Object taskTitle) {
    return Intl.message(
      'Could not cancel $taskTitle.',
      name: 'componentsAppDownloadStatusCouldNotCancelDownloadTask',
      desc: '',
      args: [taskTitle],
    );
  }

  /// `Metadata To Embed`
  String get componentsAppItemEditorLibraryItemEmbeddingViewMetadataToEmbed {
    return Intl.message(
      'Metadata To Embed',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewMetadataToEmbed',
      desc: '',
      args: [],
    );
  }

  /// `Chapters To Embed`
  String get componentsAppItemEditorLibraryItemEmbeddingViewChaptersToEmbed {
    return Intl.message(
      'Chapters To Embed',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewChaptersToEmbed',
      desc: '',
      args: [],
    );
  }

  /// `Submitting...`
  String get componentsAppItemEditorLibraryItemEmbeddingViewSubmitting {
    return Intl.message(
      'Submitting...',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewSubmitting',
      desc: '',
      args: [],
    );
  }

  /// `Running...`
  String get componentsAppItemEditorLibraryItemEmbeddingViewRunning {
    return Intl.message(
      'Running...',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewRunning',
      desc: '',
      args: [],
    );
  }

  /// `Queued`
  String get componentsAppItemEditorLibraryItemEmbeddingViewQueued {
    return Intl.message('Queued', name: 'componentsAppItemEditorLibraryItemEmbeddingViewQueued', desc: '', args: []);
  }

  /// `Start Embed`
  String get componentsAppItemEditorLibraryItemEmbeddingViewStartEmbed {
    return Intl.message(
      'Start Embed',
      name: 'componentsAppItemEditorLibraryItemEmbeddingViewStartEmbed',
      desc: '',
      args: [],
    );
  }

  /// `Start, end and listened time must be non-negative.`
  String get componentsSessionsListeningSessionEditorDialogStartEndAndListenedTimeMustBeNonNegative {
    return Intl.message(
      'Start, end and listened time must be non-negative.',
      name: 'componentsSessionsListeningSessionEditorDialogStartEndAndListenedTimeMustBeNonNegative',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save listening session changes.`
  String get componentsSessionsListeningSessionEditorDialogFailedToSaveListeningSessionChanges {
    return Intl.message(
      'Failed to save listening session changes.',
      name: 'componentsSessionsListeningSessionEditorDialogFailedToSaveListeningSessionChanges',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save listening session changes: {error}`
  String componentsSessionsListeningSessionEditorDialogFailedToSaveListeningSessionChangesError(Object error) {
    return Intl.message(
      'Failed to save listening session changes: $error',
      name: 'componentsSessionsListeningSessionEditorDialogFailedToSaveListeningSessionChangesError',
      desc: '',
      args: [error],
    );
  }

  /// `Failed to delete listening session.`
  String get componentsSessionsListeningSessionEditorDialogFailedToDeleteListeningSession {
    return Intl.message(
      'Failed to delete listening session.',
      name: 'componentsSessionsListeningSessionEditorDialogFailedToDeleteListeningSession',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete listening session: {error}`
  String componentsSessionsListeningSessionEditorDialogFailedToDeleteListeningSessionError(Object error) {
    return Intl.message(
      'Failed to delete listening session: $error',
      name: 'componentsSessionsListeningSessionEditorDialogFailedToDeleteListeningSessionError',
      desc: '',
      args: [error],
    );
  }

  /// `Unknown`
  String get componentsSessionsListeningSessionEditorDialogUnknown {
    return Intl.message('Unknown', name: 'componentsSessionsListeningSessionEditorDialogUnknown', desc: '', args: []);
  }

  /// `Direct Play`
  String get componentsSessionsListeningSessionEditorDialogDirectPlay {
    return Intl.message(
      'Direct Play',
      name: 'componentsSessionsListeningSessionEditorDialogDirectPlay',
      desc: '',
      args: [],
    );
  }

  /// `Direct Stream`
  String get componentsSessionsListeningSessionEditorDialogDirectStream {
    return Intl.message(
      'Direct Stream',
      name: 'componentsSessionsListeningSessionEditorDialogDirectStream',
      desc: '',
      args: [],
    );
  }

  /// `Transcode`
  String get componentsSessionsListeningSessionEditorDialogTranscode {
    return Intl.message(
      'Transcode',
      name: 'componentsSessionsListeningSessionEditorDialogTranscode',
      desc: '',
      args: [],
    );
  }

  /// `Author`
  String get componentsSessionsListeningSessionEditorDialogAuthor {
    return Intl.message('Author', name: 'componentsSessionsListeningSessionEditorDialogAuthor', desc: '', args: []);
  }

  /// `User`
  String get componentsSessionsListeningSessionEditorDialogUser {
    return Intl.message('User', name: 'componentsSessionsListeningSessionEditorDialogUser', desc: '', args: []);
  }

  /// `Date`
  String get componentsSessionsListeningSessionEditorDialogDate {
    return Intl.message('Date', name: 'componentsSessionsListeningSessionEditorDialogDate', desc: '', args: []);
  }

  /// `Started`
  String get componentsSessionsListeningSessionEditorDialogStarted {
    return Intl.message('Started', name: 'componentsSessionsListeningSessionEditorDialogStarted', desc: '', args: []);
  }

  /// `Updated`
  String get componentsSessionsListeningSessionEditorDialogUpdated {
    return Intl.message('Updated', name: 'componentsSessionsListeningSessionEditorDialogUpdated', desc: '', args: []);
  }

  /// `Duration`
  String get componentsSessionsListeningSessionEditorDialogDuration {
    return Intl.message('Duration', name: 'componentsSessionsListeningSessionEditorDialogDuration', desc: '', args: []);
  }

  /// `Listened`
  String get componentsSessionsListeningSessionEditorDialogListened {
    return Intl.message('Listened', name: 'componentsSessionsListeningSessionEditorDialogListened', desc: '', args: []);
  }

  /// `Current Position`
  String get componentsSessionsListeningSessionEditorDialogCurrentPosition {
    return Intl.message(
      'Current Position',
      name: 'componentsSessionsListeningSessionEditorDialogCurrentPosition',
      desc: '',
      args: [],
    );
  }

  /// `Start Position`
  String get componentsSessionsListeningSessionEditorDialogStartPosition {
    return Intl.message(
      'Start Position',
      name: 'componentsSessionsListeningSessionEditorDialogStartPosition',
      desc: '',
      args: [],
    );
  }

  /// `Play Method`
  String get componentsSessionsListeningSessionEditorDialogPlayMethod {
    return Intl.message(
      'Play Method',
      name: 'componentsSessionsListeningSessionEditorDialogPlayMethod',
      desc: '',
      args: [],
    );
  }

  /// `Device`
  String get componentsSessionsListeningSessionEditorDialogDevice {
    return Intl.message('Device', name: 'componentsSessionsListeningSessionEditorDialogDevice', desc: '', args: []);
  }

  /// `Player`
  String get componentsSessionsListeningSessionEditorDialogPlayer {
    return Intl.message('Player', name: 'componentsSessionsListeningSessionEditorDialogPlayer', desc: '', args: []);
  }

  /// `Server Version`
  String get componentsSessionsListeningSessionEditorDialogServerVersion {
    return Intl.message(
      'Server Version',
      name: 'componentsSessionsListeningSessionEditorDialogServerVersion',
      desc: '',
      args: [],
    );
  }

  /// `User ID`
  String get componentsSessionsListeningSessionEditorDialogUserId {
    return Intl.message('User ID', name: 'componentsSessionsListeningSessionEditorDialogUserId', desc: '', args: []);
  }

  /// `Item ID`
  String get componentsSessionsListeningSessionEditorDialogItemId {
    return Intl.message('Item ID', name: 'componentsSessionsListeningSessionEditorDialogItemId', desc: '', args: []);
  }

  /// `Episode ID`
  String get componentsSessionsListeningSessionEditorDialogEpisodeId {
    return Intl.message(
      'Episode ID',
      name: 'componentsSessionsListeningSessionEditorDialogEpisodeId',
      desc: '',
      args: [],
    );
  }

  /// `Session ID`
  String get componentsSessionsListeningSessionEditorDialogSessionId {
    return Intl.message(
      'Session ID',
      name: 'componentsSessionsListeningSessionEditorDialogSessionId',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get componentsSessionsListeningSessionEditorDialogStart {
    return Intl.message('Start', name: 'componentsSessionsListeningSessionEditorDialogStart', desc: '', args: []);
  }

  /// `End`
  String get componentsSessionsListeningSessionEditorDialogEnd {
    return Intl.message('End', name: 'componentsSessionsListeningSessionEditorDialogEnd', desc: '', args: []);
  }

  /// `Time Listened`
  String get componentsSessionsListeningSessionEditorDialogTimeListened {
    return Intl.message(
      'Time Listened',
      name: 'componentsSessionsListeningSessionEditorDialogTimeListened',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get componentsSessionsSessionDurationPickerFieldHours {
    return Intl.message('Hours', name: 'componentsSessionsSessionDurationPickerFieldHours', desc: '', args: []);
  }

  /// `Minutes`
  String get componentsSessionsSessionDurationPickerFieldMinutes {
    return Intl.message('Minutes', name: 'componentsSessionsSessionDurationPickerFieldMinutes', desc: '', args: []);
  }

  /// `Seconds`
  String get componentsSessionsSessionDurationPickerFieldSeconds {
    return Intl.message('Seconds', name: 'componentsSessionsSessionDurationPickerFieldSeconds', desc: '', args: []);
  }

  /// `Unknown`
  String get componentsSettingsAdminUsersAdminUserListTileUnknown {
    return Intl.message('Unknown', name: 'componentsSettingsAdminUsersAdminUserListTileUnknown', desc: '', args: []);
  }

  /// `Disable user`
  String get componentsSettingsAdminUsersAdminUserListTileDisableUser {
    return Intl.message(
      'Disable user',
      name: 'componentsSettingsAdminUsersAdminUserListTileDisableUser',
      desc: '',
      args: [],
    );
  }

  /// `Enable user`
  String get componentsSettingsAdminUsersAdminUserListTileEnableUser {
    return Intl.message(
      'Enable user',
      name: 'componentsSettingsAdminUsersAdminUserListTileEnableUser',
      desc: '',
      args: [],
    );
  }

  /// `Disable`
  String get componentsSettingsAdminUsersAdminUserListTileDisable {
    return Intl.message('Disable', name: 'componentsSettingsAdminUsersAdminUserListTileDisable', desc: '', args: []);
  }

  /// `Enable`
  String get componentsSettingsAdminUsersAdminUserListTileEnable {
    return Intl.message('Enable', name: 'componentsSettingsAdminUsersAdminUserListTileEnable', desc: '', args: []);
  }

  /// `No email`
  String get componentsSettingsAdminUsersAdminUserListTileNoEmail {
    return Intl.message('No email', name: 'componentsSettingsAdminUsersAdminUserListTileNoEmail', desc: '', args: []);
  }

  /// `Created: {value}`
  String componentsSettingsAdminUsersAdminUserListTileCreated(Object value) {
    return Intl.message(
      'Created: $value',
      name: 'componentsSettingsAdminUsersAdminUserListTileCreated',
      desc: '',
      args: [value],
    );
  }

  /// `Last seen: {value}`
  String componentsSettingsAdminUsersAdminUserListTileLastSeen(Object value) {
    return Intl.message(
      'Last seen: $value',
      name: 'componentsSettingsAdminUsersAdminUserListTileLastSeen',
      desc: '',
      args: [value],
    );
  }

  /// `ACTIVE`
  String get componentsSettingsAdminUsersAdminUserListTileActive {
    return Intl.message('ACTIVE', name: 'componentsSettingsAdminUsersAdminUserListTileActive', desc: '', args: []);
  }

  /// `DISABLED`
  String get componentsSettingsAdminUsersAdminUserListTileDisabled {
    return Intl.message('DISABLED', name: 'componentsSettingsAdminUsersAdminUserListTileDisabled', desc: '', args: []);
  }

  /// `OPENID`
  String get componentsSettingsAdminUsersAdminUserListTileOpenId {
    return Intl.message('OPENID', name: 'componentsSettingsAdminUsersAdminUserListTileOpenId', desc: '', args: []);
  }

  /// `Untitled episode`
  String get screensItemPodcastPodcastEpisodeUtilsUntitledEpisode {
    return Intl.message(
      'Untitled episode',
      name: 'screensItemPodcastPodcastEpisodeUtilsUntitledEpisode',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get screensItemPodcastPodcastEpisodeUtilsAll {
    return Intl.message('All', name: 'screensItemPodcastPodcastEpisodeUtilsAll', desc: '', args: []);
  }

  /// `Incomplete`
  String get screensItemPodcastPodcastEpisodeUtilsIncomplete {
    return Intl.message('Incomplete', name: 'screensItemPodcastPodcastEpisodeUtilsIncomplete', desc: '', args: []);
  }

  /// `In Progress`
  String get screensItemPodcastPodcastEpisodeUtilsInProgress {
    return Intl.message('In Progress', name: 'screensItemPodcastPodcastEpisodeUtilsInProgress', desc: '', args: []);
  }

  /// `Complete`
  String get screensItemPodcastPodcastEpisodeUtilsComplete {
    return Intl.message('Complete', name: 'screensItemPodcastPodcastEpisodeUtilsComplete', desc: '', args: []);
  }

  /// `Newest`
  String get screensItemPodcastPodcastEpisodeUtilsNewest {
    return Intl.message('Newest', name: 'screensItemPodcastPodcastEpisodeUtilsNewest', desc: '', args: []);
  }

  /// `Oldest`
  String get screensItemPodcastPodcastEpisodeUtilsOldest {
    return Intl.message('Oldest', name: 'screensItemPodcastPodcastEpisodeUtilsOldest', desc: '', args: []);
  }

  /// `Title A-Z`
  String get screensItemPodcastPodcastEpisodeUtilsTitleAZ {
    return Intl.message('Title A-Z', name: 'screensItemPodcastPodcastEpisodeUtilsTitleAZ', desc: '', args: []);
  }

  /// `Title Z-A`
  String get screensItemPodcastPodcastEpisodeUtilsTitleZA {
    return Intl.message('Title Z-A', name: 'screensItemPodcastPodcastEpisodeUtilsTitleZA', desc: '', args: []);
  }

  /// `Loaded Pages`
  String get screensMainStatsStatsAdvancedDashboardLoadedPages {
    return Intl.message('Loaded Pages', name: 'screensMainStatsStatsAdvancedDashboardLoadedPages', desc: '', args: []);
  }

  /// `Loaded Sessions`
  String get screensMainStatsStatsAdvancedDashboardLoadedSessions {
    return Intl.message(
      'Loaded Sessions',
      name: 'screensMainStatsStatsAdvancedDashboardLoadedSessions',
      desc: '',
      args: [],
    );
  }

  /// `Total Sessions`
  String get screensMainStatsStatsAdvancedDashboardTotalSessions {
    return Intl.message(
      'Total Sessions',
      name: 'screensMainStatsStatsAdvancedDashboardTotalSessions',
      desc: '',
      args: [],
    );
  }

  /// `Total Listening`
  String get screensMainStatsStatsAdvancedDashboardTotalListening {
    return Intl.message(
      'Total Listening',
      name: 'screensMainStatsStatsAdvancedDashboardTotalListening',
      desc: '',
      args: [],
    );
  }

  /// `Book Listening`
  String get screensMainStatsStatsAdvancedDashboardBookListening {
    return Intl.message(
      'Book Listening',
      name: 'screensMainStatsStatsAdvancedDashboardBookListening',
      desc: '',
      args: [],
    );
  }

  /// `Podcast Listening`
  String get screensMainStatsStatsAdvancedDashboardPodcastListening {
    return Intl.message(
      'Podcast Listening',
      name: 'screensMainStatsStatsAdvancedDashboardPodcastListening',
      desc: '',
      args: [],
    );
  }

  /// `Average Session`
  String get screensMainStatsStatsAdvancedDashboardAverageSession {
    return Intl.message(
      'Average Session',
      name: 'screensMainStatsStatsAdvancedDashboardAverageSession',
      desc: '',
      args: [],
    );
  }

  /// `Median Session`
  String get screensMainStatsStatsAdvancedDashboardMedianSession {
    return Intl.message(
      'Median Session',
      name: 'screensMainStatsStatsAdvancedDashboardMedianSession',
      desc: '',
      args: [],
    );
  }

  /// `Longest Session`
  String get screensMainStatsStatsAdvancedDashboardLongestSession {
    return Intl.message(
      'Longest Session',
      name: 'screensMainStatsStatsAdvancedDashboardLongestSession',
      desc: '',
      args: [],
    );
  }

  /// `Unique Items`
  String get screensMainStatsStatsAdvancedDashboardUniqueItems {
    return Intl.message('Unique Items', name: 'screensMainStatsStatsAdvancedDashboardUniqueItems', desc: '', args: []);
  }

  /// `Unique Authors`
  String get screensMainStatsStatsAdvancedDashboardUniqueAuthors {
    return Intl.message(
      'Unique Authors',
      name: 'screensMainStatsStatsAdvancedDashboardUniqueAuthors',
      desc: '',
      args: [],
    );
  }

  /// `Longest Streak`
  String get screensMainStatsStatsAdvancedDashboardLongestStreak {
    return Intl.message(
      'Longest Streak',
      name: 'screensMainStatsStatsAdvancedDashboardLongestStreak',
      desc: '',
      args: [],
    );
  }

  /// `Favorite Weekday`
  String get screensMainStatsStatsAdvancedDashboardFavoriteWeekday {
    return Intl.message(
      'Favorite Weekday',
      name: 'screensMainStatsStatsAdvancedDashboardFavoriteWeekday',
      desc: '',
      args: [],
    );
  }

  /// `Favorite Hour`
  String get screensMainStatsStatsAdvancedDashboardFavoriteHour {
    return Intl.message(
      'Favorite Hour',
      name: 'screensMainStatsStatsAdvancedDashboardFavoriteHour',
      desc: '',
      args: [],
    );
  }

  /// `First Session`
  String get screensMainStatsStatsAdvancedDashboardFirstSession {
    return Intl.message(
      'First Session',
      name: 'screensMainStatsStatsAdvancedDashboardFirstSession',
      desc: '',
      args: [],
    );
  }

  /// `Last Session`
  String get screensMainStatsStatsAdvancedDashboardLastSession {
    return Intl.message('Last Session', name: 'screensMainStatsStatsAdvancedDashboardLastSession', desc: '', args: []);
  }

  /// `Top Items`
  String get screensMainStatsStatsAdvancedDashboardTopItems {
    return Intl.message('Top Items', name: 'screensMainStatsStatsAdvancedDashboardTopItems', desc: '', args: []);
  }

  /// `No top items available.`
  String get screensMainStatsStatsAdvancedDashboardNoTopItemsAvailable {
    return Intl.message(
      'No top items available.',
      name: 'screensMainStatsStatsAdvancedDashboardNoTopItemsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Top Authors`
  String get screensMainStatsStatsAdvancedDashboardTopAuthors {
    return Intl.message('Top Authors', name: 'screensMainStatsStatsAdvancedDashboardTopAuthors', desc: '', args: []);
  }

  /// `No top authors available.`
  String get screensMainStatsStatsAdvancedDashboardNoTopAuthorsAvailable {
    return Intl.message(
      'No top authors available.',
      name: 'screensMainStatsStatsAdvancedDashboardNoTopAuthorsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Weekday Breakdown`
  String get screensMainStatsStatsAdvancedDashboardWeekdayBreakdown {
    return Intl.message(
      'Weekday Breakdown',
      name: 'screensMainStatsStatsAdvancedDashboardWeekdayBreakdown',
      desc: '',
      args: [],
    );
  }

  /// `No weekday data available.`
  String get screensMainStatsStatsAdvancedDashboardNoWeekdayDataAvailable {
    return Intl.message(
      'No weekday data available.',
      name: 'screensMainStatsStatsAdvancedDashboardNoWeekdayDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Busiest Hours`
  String get screensMainStatsStatsAdvancedDashboardBusiestHours {
    return Intl.message(
      'Busiest Hours',
      name: 'screensMainStatsStatsAdvancedDashboardBusiestHours',
      desc: '',
      args: [],
    );
  }

  /// `No hourly data available.`
  String get screensMainStatsStatsAdvancedDashboardNoHourlyDataAvailable {
    return Intl.message(
      'No hourly data available.',
      name: 'screensMainStatsStatsAdvancedDashboardNoHourlyDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Top Months`
  String get screensMainStatsStatsAdvancedDashboardTopMonths {
    return Intl.message('Top Months', name: 'screensMainStatsStatsAdvancedDashboardTopMonths', desc: '', args: []);
  }

  /// `No monthly data available.`
  String get screensMainStatsStatsAdvancedDashboardNoMonthlyDataAvailable {
    return Intl.message(
      'No monthly data available.',
      name: 'screensMainStatsStatsAdvancedDashboardNoMonthlyDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get screensMainStatsStatsFormattersUnknown {
    return Intl.message('Unknown', name: 'screensMainStatsStatsFormattersUnknown', desc: '', args: []);
  }

  /// `0:00`
  String get screensMainStatsStatsFormattersZeroClock {
    return Intl.message('0:00', name: 'screensMainStatsStatsFormattersZeroClock', desc: '', args: []);
  }

  /// `0 min`
  String get screensMainStatsStatsFormattersZeroMinutes {
    return Intl.message('0 min', name: 'screensMainStatsStatsFormattersZeroMinutes', desc: '', args: []);
  }

  /// `Visible`
  String get screensPlayerLayoutPlayerComponentSettingsSheetVisible {
    return Intl.message('Visible', name: 'screensPlayerLayoutPlayerComponentSettingsSheetVisible', desc: '', args: []);
  }

  /// `Hidden`
  String get screensPlayerLayoutPlayerComponentSettingsSheetHidden {
    return Intl.message('Hidden', name: 'screensPlayerLayoutPlayerComponentSettingsSheetHidden', desc: '', args: []);
  }

  /// `Today`
  String get screensPlayerPlayHistoryLocalTabToday {
    return Intl.message('Today', name: 'screensPlayerPlayHistoryLocalTabToday', desc: '', args: []);
  }

  /// `Yesterday`
  String get screensPlayerPlayHistoryLocalTabYesterday {
    return Intl.message('Yesterday', name: 'screensPlayerPlayHistoryLocalTabYesterday', desc: '', args: []);
  }

  /// `Player - Sleep Timer`
  String get screensSettingsPlayerPlayerSettingsSleepTimerTitle {
    return Intl.message(
      'Player - Sleep Timer',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sleep timer end action`
  String get screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerEndAction {
    return Intl.message(
      'Sleep timer end action',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerEndAction',
      desc: '',
      args: [],
    );
  }

  /// `Choose whether playback is stopped or paused when the sleep timer expires.`
  String get screensSettingsPlayerPlayerSettingsSleepTimerChooseWhetherPlaybackIsStoppedOrPausedWhen {
    return Intl.message(
      'Choose whether playback is stopped or paused when the sleep timer expires.',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerChooseWhetherPlaybackIsStoppedOrPausedWhen',
      desc: '',
      args: [],
    );
  }

  /// `Sleep timer end rewind`
  String get screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerEndRewind {
    return Intl.message(
      'Sleep timer end rewind',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerEndRewind',
      desc: '',
      args: [],
    );
  }

  /// `After sleep timer stops playback, rewind this much when the same item is played again.`
  String get screensSettingsPlayerPlayerSettingsSleepTimerAfterSleepTimerStopsPlaybackRewindThis {
    return Intl.message(
      'After sleep timer stops playback, rewind this much when the same item is played again.',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerAfterSleepTimerStopsPlaybackRewindThis',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get screensSettingsPlayerPlayerSettingsSleepTimerOff {
    return Intl.message('Off', name: 'screensSettingsPlayerPlayerSettingsSleepTimerOff', desc: '', args: []);
  }

  /// `5 min`
  String get screensSettingsPlayerPlayerSettingsSleepTimerM005 {
    return Intl.message('5 min', name: 'screensSettingsPlayerPlayerSettingsSleepTimerM005', desc: '', args: []);
  }

  /// `10 min`
  String get screensSettingsPlayerPlayerSettingsSleepTimerM010 {
    return Intl.message('10 min', name: 'screensSettingsPlayerPlayerSettingsSleepTimerM010', desc: '', args: []);
  }

  /// `15 min`
  String get screensSettingsPlayerPlayerSettingsSleepTimerM015 {
    return Intl.message('15 min', name: 'screensSettingsPlayerPlayerSettingsSleepTimerM015', desc: '', args: []);
  }

  /// `30 min`
  String get screensSettingsPlayerPlayerSettingsSleepTimerM030 {
    return Intl.message('30 min', name: 'screensSettingsPlayerPlayerSettingsSleepTimerM030', desc: '', args: []);
  }

  /// `Auto-restart timer on playback start`
  String get screensSettingsPlayerPlayerSettingsSleepTimerAutorestartTimerOnPlaybackStart {
    return Intl.message(
      'Auto-restart timer on playback start',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerAutorestartTimerOnPlaybackStart',
      desc: '',
      args: [],
    );
  }

  /// `When playback starts and no timer is active, automatically start a new sleep timer using your last duration.`
  String get screensSettingsPlayerPlayerSettingsSleepTimerWhenPlaybackStartsAndNoTimerIs {
    return Intl.message(
      'When playback starts and no timer is active, automatically start a new sleep timer using your last duration.',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerWhenPlaybackStartsAndNoTimerIs',
      desc: '',
      args: [],
    );
  }

  /// `Only auto-restart during a time range`
  String get screensSettingsPlayerPlayerSettingsSleepTimerOnlyAutorestartDuringATimeRange {
    return Intl.message(
      'Only auto-restart during a time range',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerOnlyAutorestartDuringATimeRange',
      desc: '',
      args: [],
    );
  }

  /// `Limit automatic sleep timer restart to specific hours.`
  String get screensSettingsPlayerPlayerSettingsSleepTimerLimitAutomaticSleepTimerRestartToSpecific {
    return Intl.message(
      'Limit automatic sleep timer restart to specific hours.',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerLimitAutomaticSleepTimerRestartToSpecific',
      desc: '',
      args: [],
    );
  }

  /// `Enable auto-restart to configure this option.`
  String get screensSettingsPlayerPlayerSettingsSleepTimerEnableAutorestartToConfigureThisOption {
    return Intl.message(
      'Enable auto-restart to configure this option.',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerEnableAutorestartToConfigureThisOption',
      desc: '',
      args: [],
    );
  }

  /// `Auto-restart range start`
  String get screensSettingsPlayerPlayerSettingsSleepTimerAutorestartRangeStart {
    return Intl.message(
      'Auto-restart range start',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerAutorestartRangeStart',
      desc: '',
      args: [],
    );
  }

  /// `Sleep timer auto-restart becomes active at this time.`
  String get screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerAutorestartBecomesActiveAt {
    return Intl.message(
      'Sleep timer auto-restart becomes active at this time.',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerAutorestartBecomesActiveAt',
      desc: '',
      args: [],
    );
  }

  /// `Enable auto-restart and time range to configure this option.`
  String get screensSettingsPlayerPlayerSettingsSleepTimerEnableAutorestartAndTimeRangeTo {
    return Intl.message(
      'Enable auto-restart and time range to configure this option.',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerEnableAutorestartAndTimeRangeTo',
      desc: '',
      args: [],
    );
  }

  /// `Auto-restart range end`
  String get screensSettingsPlayerPlayerSettingsSleepTimerAutorestartRangeEnd {
    return Intl.message(
      'Auto-restart range end',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerAutorestartRangeEnd',
      desc: '',
      args: [],
    );
  }

  /// `Sleep timer auto-restart remains active until this time.`
  String get screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerAutorestartRemainsActiveUntil {
    return Intl.message(
      'Sleep timer auto-restart remains active until this time.',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerAutorestartRemainsActiveUntil',
      desc: '',
      args: [],
    );
  }

  /// `{state, select, reachable{Server is reachable} unreachable{Server is unreachable} other{Server status unknown}}`
  String serverStatusReachability(String state) {
    return Intl.select(
      state,
      {'reachable': 'Server is reachable', 'unreachable': 'Server is unreachable', 'other': 'Server status unknown'},
      name: 'serverStatusReachability',
      desc: '',
      args: [state],
    );
  }

  /// `No server connection available`
  String get componentsCommonConnectionIssueViewNoServerConnectionAvailable {
    return Intl.message(
      'No server connection available',
      name: 'componentsCommonConnectionIssueViewNoServerConnectionAvailable',
      desc: '',
      args: [],
    );
  }

  /// `This section requires an active server connection. Reconnect and try again.`
  String get componentsCommonConnectionIssueViewRequiresActiveServerConnection {
    return Intl.message(
      'This section requires an active server connection. Reconnect and try again.',
      name: 'componentsCommonConnectionIssueViewRequiresActiveServerConnection',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load content`
  String get componentsCommonConnectionIssueViewUnableToLoadContent {
    return Intl.message(
      'Unable to load content',
      name: 'componentsCommonConnectionIssueViewUnableToLoadContent',
      desc: '',
      args: [],
    );
  }

  /// `Please try again. If the issue persists, check your server connection.`
  String get componentsCommonConnectionIssueViewTryAgainAndCheckServerConnection {
    return Intl.message(
      'Please try again. If the issue persists, check your server connection.',
      name: 'componentsCommonConnectionIssueViewTryAgainAndCheckServerConnection',
      desc: '',
      args: [],
    );
  }

  /// `Open Downloads`
  String get componentsCommonConnectionIssueViewOpenDownloads {
    return Intl.message('Open Downloads', name: 'componentsCommonConnectionIssueViewOpenDownloads', desc: '', args: []);
  }

  /// `Retry`
  String get componentsCommonConnectionIssueViewRetry {
    return Intl.message('Retry', name: 'componentsCommonConnectionIssueViewRetry', desc: '', args: []);
  }

  /// `Create`
  String get componentsCommonListManagementHeaderCreate {
    return Intl.message('Create', name: 'componentsCommonListManagementHeaderCreate', desc: '', args: []);
  }

  /// `Next`
  String get componentsCommonManagedListOperationsNext {
    return Intl.message('Next', name: 'componentsCommonManagedListOperationsNext', desc: '', args: []);
  }

  /// `Save`
  String get componentsCommonManagedListOperationsSave {
    return Intl.message('Save', name: 'componentsCommonManagedListOperationsSave', desc: '', args: []);
  }

  /// `Now playing`
  String get componentsPlayerCommonChapterTextNowPlaying {
    return Intl.message('Now playing', name: 'componentsPlayerCommonChapterTextNowPlaying', desc: '', args: []);
  }

  /// `Management`
  String get componentsSettingsManagementSettingsSectionManagement {
    return Intl.message(
      'Management',
      name: 'componentsSettingsManagementSettingsSectionManagement',
      desc: '',
      args: [],
    );
  }

  /// `Admin Server Settings`
  String get componentsSettingsManagementSettingsSectionAdminServerSettings {
    return Intl.message(
      'Admin Server Settings',
      name: 'componentsSettingsManagementSettingsSectionAdminServerSettings',
      desc: '',
      args: [],
    );
  }

  /// `Tools`
  String get componentsSettingsManagementSettingsSectionTools {
    return Intl.message('Tools', name: 'componentsSettingsManagementSettingsSectionTools', desc: '', args: []);
  }

  /// `Unable to load item`
  String get screensItemLibraryItemViewUnableToLoadItem {
    return Intl.message('Unable to load item', name: 'screensItemLibraryItemViewUnableToLoadItem', desc: '', args: []);
  }

  /// `Library Stats`
  String get screensSettingsAdminServerLibraryStatsSettingsTitle {
    return Intl.message(
      'Library Stats',
      name: 'screensSettingsAdminServerLibraryStatsSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Admin Logs`
  String get screensSettingsAdminServerLogsSettingsTitle {
    return Intl.message('Admin Logs', name: 'screensSettingsAdminServerLogsSettingsTitle', desc: '', args: []);
  }

  /// `Manage Users`
  String get screensSettingsAdminServerUsersSettingsTitle {
    return Intl.message('Manage Users', name: 'screensSettingsAdminServerUsersSettingsTitle', desc: '', args: []);
  }

  /// `Path Tag and Genre Update`
  String get screensSettingsPathTagGenreUpdateSettingsTitle {
    return Intl.message(
      'Path Tag and Genre Update',
      name: 'screensSettingsPathTagGenreUpdateSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Player - Subtitles`
  String get screensSettingsPlayerPlayerSettingsSubtitlesTitle {
    return Intl.message(
      'Player - Subtitles',
      name: 'screensSettingsPlayerPlayerSettingsSubtitlesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get screensSettingsThemeSettingsTitle {
    return Intl.message('Theme', name: 'screensSettingsThemeSettingsTitle', desc: '', args: []);
  }

  /// `Appearance Settings`
  String get screensSettingsAppearanceSettingsTitle {
    return Intl.message('Appearance Settings', name: 'screensSettingsAppearanceSettingsTitle', desc: '', args: []);
  }

  /// `Display`
  String get screensSettingsAppearanceSettingsDisplay {
    return Intl.message('Display', name: 'screensSettingsAppearanceSettingsDisplay', desc: '', args: []);
  }

  /// `Theme`
  String get screensSettingsAppearanceSettingsTheme {
    return Intl.message('Theme', name: 'screensSettingsAppearanceSettingsTheme', desc: '', args: []);
  }

  /// `Theme mode, preset palette, and custom accent color.`
  String get screensSettingsAppearanceSettingsThemeSubtitle {
    return Intl.message(
      'Theme mode, preset palette, and custom accent color.',
      name: 'screensSettingsAppearanceSettingsThemeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get screensSettingsAppearanceSettingsGeneral {
    return Intl.message('General', name: 'screensSettingsAppearanceSettingsGeneral', desc: '', args: []);
  }

  /// `Language and diagnostics.`
  String get screensSettingsAppearanceSettingsGeneralDescription {
    return Intl.message(
      'Language and diagnostics.',
      name: 'screensSettingsAppearanceSettingsGeneralDescription',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get screensSettingsAppearanceSettingsLanguage {
    return Intl.message('Language', name: 'screensSettingsAppearanceSettingsLanguage', desc: '', args: []);
  }

  /// `English`
  String get screensSettingsAppearanceSettingsEnglish {
    return Intl.message('English', name: 'screensSettingsAppearanceSettingsEnglish', desc: '', args: []);
  }

  /// `Deutsch`
  String get screensSettingsAppearanceSettingsGerman {
    return Intl.message('Deutsch', name: 'screensSettingsAppearanceSettingsGerman', desc: '', args: []);
  }

  /// `Log Level`
  String get screensSettingsAppearanceSettingsLogLevel {
    return Intl.message('Log Level', name: 'screensSettingsAppearanceSettingsLogLevel', desc: '', args: []);
  }

  /// `Caching Settings`
  String get screensSettingsCachingSettingsTitle {
    return Intl.message('Caching Settings', name: 'screensSettingsCachingSettingsTitle', desc: '', args: []);
  }

  /// `Caching Subsettings`
  String get screensSettingsCachingSettingsSubsettings {
    return Intl.message('Caching Subsettings', name: 'screensSettingsCachingSettingsSubsettings', desc: '', args: []);
  }

  /// `General`
  String get screensSettingsCachingSettingsGeneral {
    return Intl.message('General', name: 'screensSettingsCachingSettingsGeneral', desc: '', args: []);
  }

  /// `Enable/disable caching and configure speedup mode behavior.`
  String get screensSettingsCachingSettingsGeneralSubtitle {
    return Intl.message(
      'Enable/disable caching and configure speedup mode behavior.',
      name: 'screensSettingsCachingSettingsGeneralSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Route Rules`
  String get screensSettingsCachingSettingsRouteRules {
    return Intl.message('Route Rules', name: 'screensSettingsCachingSettingsRouteRules', desc: '', args: []);
  }

  /// `Configure endpoint-level cache behavior.`
  String get screensSettingsCachingSettingsRouteRulesEnabledSubtitle {
    return Intl.message(
      'Configure endpoint-level cache behavior.',
      name: 'screensSettingsCachingSettingsRouteRulesEnabledSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Open route rules (editing is disabled until caching is enabled).`
  String get screensSettingsCachingSettingsRouteRulesDisabledSubtitle {
    return Intl.message(
      'Open route rules (editing is disabled until caching is enabled).',
      name: 'screensSettingsCachingSettingsRouteRulesDisabledSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Caching - General`
  String get screensSettingsCachingGeneralSettingsTitle {
    return Intl.message('Caching - General', name: 'screensSettingsCachingGeneralSettingsTitle', desc: '', args: []);
  }

  /// `Enable caching`
  String get screensSettingsCachingGeneralSettingsEnableCaching {
    return Intl.message(
      'Enable caching',
      name: 'screensSettingsCachingGeneralSettingsEnableCaching',
      desc: '',
      args: [],
    );
  }

  /// `Speedup mode`
  String get screensSettingsCachingGeneralSettingsSpeedupMode {
    return Intl.message('Speedup mode', name: 'screensSettingsCachingGeneralSettingsSpeedupMode', desc: '', args: []);
  }

  /// `Combines caching with refreshing the cache after each request. This can briefly show stale data until a refresh finishes.`
  String get screensSettingsCachingGeneralSettingsSpeedupModeDescription {
    return Intl.message(
      'Combines caching with refreshing the cache after each request. This can briefly show stale data until a refresh finishes.',
      name: 'screensSettingsCachingGeneralSettingsSpeedupModeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enable response caching to use speedup mode.`
  String get screensSettingsCachingGeneralSettingsEnableCachingDisabledReason {
    return Intl.message(
      'Enable response caching to use speedup mode.',
      name: 'screensSettingsCachingGeneralSettingsEnableCachingDisabledReason',
      desc: '',
      args: [],
    );
  }

  /// `Caching - Routes`
  String get screensSettingsCachingRouteSettingsTitle {
    return Intl.message('Caching - Routes', name: 'screensSettingsCachingRouteSettingsTitle', desc: '', args: []);
  }

  /// `Configure per-endpoint cache behavior. Route settings remain accessible even when global caching is off.`
  String get screensSettingsCachingRouteSettingsDescription {
    return Intl.message(
      'Configure per-endpoint cache behavior. Route settings remain accessible even when global caching is off.',
      name: 'screensSettingsCachingRouteSettingsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Warning: Enabling this could lead to odd behavior with multiple devices.`
  String get screensSettingsCachingRouteSettingsWarningOddBehaviorMultipleDevices {
    return Intl.message(
      'Warning: Enabling this could lead to odd behavior with multiple devices.',
      name: 'screensSettingsCachingRouteSettingsWarningOddBehaviorMultipleDevices',
      desc: '',
      args: [],
    );
  }

  /// `Enable response caching to change route-level cache behavior.`
  String get screensSettingsCachingRouteSettingsEnableCachingDisabledReason {
    return Intl.message(
      'Enable response caching to change route-level cache behavior.',
      name: 'screensSettingsCachingRouteSettingsEnableCachingDisabledReason',
      desc: '',
      args: [],
    );
  }

  /// `Global Player Settings`
  String get screensSettingsPlayerGlobalPlayerSettingsTitle {
    return Intl.message(
      'Global Player Settings',
      name: 'screensSettingsPlayerGlobalPlayerSettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Max buffer size`
  String get screensSettingsPlayerGlobalPlayerSettingsMaxBufferSize {
    return Intl.message(
      'Max buffer size',
      name: 'screensSettingsPlayerGlobalPlayerSettingsMaxBufferSize',
      desc: '',
      args: [],
    );
  }

  /// `Maximum size of the buffer in bytes. This is just a hint for the player and may not be respected by the OS. No more than 5 minutes should be cached.`
  String get screensSettingsPlayerGlobalPlayerSettingsMaxBufferSizeTooltip {
    return Intl.message(
      'Maximum size of the buffer in bytes. This is just a hint for the player and may not be respected by the OS. No more than 5 minutes should be cached.',
      name: 'screensSettingsPlayerGlobalPlayerSettingsMaxBufferSizeTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Lock Media Notification`
  String get screensSettingsPlayerGlobalPlayerSettingsLockMediaNotification {
    return Intl.message(
      'Lock Media Notification',
      name: 'screensSettingsPlayerGlobalPlayerSettingsLockMediaNotification',
      desc: '',
      args: [],
    );
  }

  /// `Show notification More button`
  String get screensSettingsPlayerGlobalPlayerSettingsShowNotificationMoreButton {
    return Intl.message(
      'Show notification More button',
      name: 'screensSettingsPlayerGlobalPlayerSettingsShowNotificationMoreButton',
      desc: '',
      args: [],
    );
  }

  /// `When enabled, a More button will be shown, giving more quick actions`
  String get screensSettingsPlayerGlobalPlayerSettingsShowNotificationMoreButtonDescription {
    return Intl.message(
      'When enabled, a More button will be shown, giving more quick actions',
      name: 'screensSettingsPlayerGlobalPlayerSettingsShowNotificationMoreButtonDescription',
      desc: '',
      args: [],
    );
  }

  /// `Auto-play last played on app start`
  String get screensSettingsPlayerGlobalPlayerSettingsAutoPlayLastPlayedOnAppStart {
    return Intl.message(
      'Auto-play last played on app start',
      name: 'screensSettingsPlayerGlobalPlayerSettingsAutoPlayLastPlayedOnAppStart',
      desc: '',
      args: [],
    );
  }

  /// `When enabled and nothing is currently playing, app launch will resume the last played item if it is not finished.`
  String get screensSettingsPlayerGlobalPlayerSettingsAutoPlayLastPlayedOnAppStartDescription {
    return Intl.message(
      'When enabled and nothing is currently playing, app launch will resume the last played item if it is not finished.',
      name: 'screensSettingsPlayerGlobalPlayerSettingsAutoPlayLastPlayedOnAppStartDescription',
      desc: '',
      args: [],
    );
  }

  /// `Keep Screen On`
  String get screensSettingsPlayerGlobalPlayerSettingsKeepScreenOn {
    return Intl.message(
      'Keep Screen On',
      name: 'screensSettingsPlayerGlobalPlayerSettingsKeepScreenOn',
      desc: '',
      args: [],
    );
  }

  /// `Player Settings`
  String get screensSettingsPlayerPlayerSettingsTitle {
    return Intl.message('Player Settings', name: 'screensSettingsPlayerPlayerSettingsTitle', desc: '', args: []);
  }

  /// `Playback`
  String get screensSettingsPlayerPlayerSettingsPlayback {
    return Intl.message('Playback', name: 'screensSettingsPlayerPlayerSettingsPlayback', desc: '', args: []);
  }

  /// `General`
  String get screensSettingsPlayerPlayerSettingsGeneral {
    return Intl.message('General', name: 'screensSettingsPlayerPlayerSettingsGeneral', desc: '', args: []);
  }

  /// `Timeline mode, seek intervals, and auto queue behavior.`
  String get screensSettingsPlayerPlayerSettingsGeneralSubtitle {
    return Intl.message(
      'Timeline mode, seek intervals, and auto queue behavior.',
      name: 'screensSettingsPlayerPlayerSettingsGeneralSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Smart rewind`
  String get screensSettingsPlayerPlayerSettingsSmartRewind {
    return Intl.message('Smart rewind', name: 'screensSettingsPlayerPlayerSettingsSmartRewind', desc: '', args: []);
  }

  /// `Control how much playback rewinds after pauses.`
  String get screensSettingsPlayerPlayerSettingsSmartRewindSubtitle {
    return Intl.message(
      'Control how much playback rewinds after pauses.',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Sleep timer`
  String get screensSettingsPlayerPlayerSettingsSleepTimer {
    return Intl.message('Sleep timer', name: 'screensSettingsPlayerPlayerSettingsSleepTimer', desc: '', args: []);
  }

  /// `Choose timer end behavior and optional automatic restart.`
  String get screensSettingsPlayerPlayerSettingsSleepTimerSubtitle {
    return Intl.message(
      'Choose timer end behavior and optional automatic restart.',
      name: 'screensSettingsPlayerPlayerSettingsSleepTimerSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Accessibility & Device`
  String get screensSettingsPlayerPlayerSettingsAccessibilityAndDevice {
    return Intl.message(
      'Accessibility & Device',
      name: 'screensSettingsPlayerPlayerSettingsAccessibilityAndDevice',
      desc: '',
      args: [],
    );
  }

  /// `Subtitles`
  String get screensSettingsPlayerPlayerSettingsSubtitles {
    return Intl.message('Subtitles', name: 'screensSettingsPlayerPlayerSettingsSubtitles', desc: '', args: []);
  }

  /// `Enable subtitles and reading support behavior.`
  String get screensSettingsPlayerPlayerSettingsSubtitlesSubtitle {
    return Intl.message(
      'Enable subtitles and reading support behavior.',
      name: 'screensSettingsPlayerPlayerSettingsSubtitlesSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Shake controls`
  String get screensSettingsPlayerPlayerSettingsShakeControls {
    return Intl.message('Shake controls', name: 'screensSettingsPlayerPlayerSettingsShakeControls', desc: '', args: []);
  }

  /// `Configure shake gestures and sensitivity.`
  String get screensSettingsPlayerPlayerSettingsShakeControlsSupportedSubtitle {
    return Intl.message(
      'Configure shake gestures and sensitivity.',
      name: 'screensSettingsPlayerPlayerSettingsShakeControlsSupportedSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Available on devices with motion sensors.`
  String get screensSettingsPlayerPlayerSettingsShakeControlsUnsupportedSubtitle {
    return Intl.message(
      'Available on devices with motion sensors.',
      name: 'screensSettingsPlayerPlayerSettingsShakeControlsUnsupportedSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `This device does not support shake controls.`
  String get screensSettingsPlayerPlayerSettingsShakeControlsUnsupportedReason {
    return Intl.message(
      'This device does not support shake controls.',
      name: 'screensSettingsPlayerPlayerSettingsShakeControlsUnsupportedReason',
      desc: '',
      args: [],
    );
  }

  /// `Player - General`
  String get screensSettingsPlayerPlayerSettingsGeneralTitle {
    return Intl.message(
      'Player - General',
      name: 'screensSettingsPlayerPlayerSettingsGeneralTitle',
      desc: '',
      args: [],
    );
  }

  /// `Timeline mode`
  String get screensSettingsPlayerPlayerSettingsGeneralTimelineMode {
    return Intl.message(
      'Timeline mode',
      name: 'screensSettingsPlayerPlayerSettingsGeneralTimelineMode',
      desc: '',
      args: [],
    );
  }

  /// `Choose whether the seek bar tracks a chapter, the full audiobook, or both.`
  String get screensSettingsPlayerPlayerSettingsGeneralTimelineModeDescription {
    return Intl.message(
      'Choose whether the seek bar tracks a chapter, the full audiobook, or both.',
      name: 'screensSettingsPlayerPlayerSettingsGeneralTimelineModeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Timeline markers`
  String get screensSettingsPlayerPlayerSettingsGeneralTimelineMarkers {
    return Intl.message(
      'Timeline markers',
      name: 'screensSettingsPlayerPlayerSettingsGeneralTimelineMarkers',
      desc: '',
      args: [],
    );
  }

  /// `Choose whether the full timeline displays chapter markers, bookmark markers, both, or none.`
  String get screensSettingsPlayerPlayerSettingsGeneralTimelineMarkersDescription {
    return Intl.message(
      'Choose whether the full timeline displays chapter markers, bookmark markers, both, or none.',
      name: 'screensSettingsPlayerPlayerSettingsGeneralTimelineMarkersDescription',
      desc: '',
      args: [],
    );
  }

  /// `Fast forward interval`
  String get screensSettingsPlayerPlayerSettingsGeneralFastForwardInterval {
    return Intl.message(
      'Fast forward interval',
      name: 'screensSettingsPlayerPlayerSettingsGeneralFastForwardInterval',
      desc: '',
      args: [],
    );
  }

  /// `How many seconds to skip when jumping forward.`
  String get screensSettingsPlayerPlayerSettingsGeneralFastForwardIntervalDescription {
    return Intl.message(
      'How many seconds to skip when jumping forward.',
      name: 'screensSettingsPlayerPlayerSettingsGeneralFastForwardIntervalDescription',
      desc: '',
      args: [],
    );
  }

  /// `Rewind interval`
  String get screensSettingsPlayerPlayerSettingsGeneralRewindInterval {
    return Intl.message(
      'Rewind interval',
      name: 'screensSettingsPlayerPlayerSettingsGeneralRewindInterval',
      desc: '',
      args: [],
    );
  }

  /// `How many seconds to skip when rewinding.`
  String get screensSettingsPlayerPlayerSettingsGeneralRewindIntervalDescription {
    return Intl.message(
      'How many seconds to skip when rewinding.',
      name: 'screensSettingsPlayerPlayerSettingsGeneralRewindIntervalDescription',
      desc: '',
      args: [],
    );
  }

  /// `Auto queue`
  String get screensSettingsPlayerPlayerSettingsGeneralAutoQueue {
    return Intl.message('Auto queue', name: 'screensSettingsPlayerPlayerSettingsGeneralAutoQueue', desc: '', args: []);
  }

  /// `Automatically queue upcoming books when playback starts from library, series, playlist, or collection views.`
  String get screensSettingsPlayerPlayerSettingsGeneralAutoQueueDescription {
    return Intl.message(
      'Automatically queue upcoming books when playback starts from library, series, playlist, or collection views.',
      name: 'screensSettingsPlayerPlayerSettingsGeneralAutoQueueDescription',
      desc: '',
      args: [],
    );
  }

  /// `Auto queue first series outside source views`
  String get screensSettingsPlayerPlayerSettingsGeneralAutoQueueFirstSeriesOutsideSourceViews {
    return Intl.message(
      'Auto queue first series outside source views',
      name: 'screensSettingsPlayerPlayerSettingsGeneralAutoQueueFirstSeriesOutsideSourceViews',
      desc: '',
      args: [],
    );
  }

  /// `When Auto queue is enabled, also auto queue books from the first linked series even when playback starts outside a series view.`
  String get screensSettingsPlayerPlayerSettingsGeneralAutoQueueFirstSeriesOutsideSourceViewsDescription {
    return Intl.message(
      'When Auto queue is enabled, also auto queue books from the first linked series even when playback starts outside a series view.',
      name: 'screensSettingsPlayerPlayerSettingsGeneralAutoQueueFirstSeriesOutsideSourceViewsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enable Auto queue to use this option.`
  String get screensSettingsPlayerPlayerSettingsGeneralEnableAutoQueueDisabledReason {
    return Intl.message(
      'Enable Auto queue to use this option.',
      name: 'screensSettingsPlayerPlayerSettingsGeneralEnableAutoQueueDisabledReason',
      desc: '',
      args: [],
    );
  }

  /// `Player - Shake Controls`
  String get screensSettingsPlayerPlayerSettingsShakeControlsTitle {
    return Intl.message(
      'Player - Shake Controls',
      name: 'screensSettingsPlayerPlayerSettingsShakeControlsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Shake controls are not available on this device.`
  String get screensSettingsPlayerPlayerSettingsShakeControlsUnavailableOnThisDevice {
    return Intl.message(
      'Shake controls are not available on this device.',
      name: 'screensSettingsPlayerPlayerSettingsShakeControlsUnavailableOnThisDevice',
      desc: '',
      args: [],
    );
  }

  /// `Player - Smart Rewind`
  String get screensSettingsPlayerPlayerSettingsSmartRewindTitle {
    return Intl.message(
      'Player - Smart Rewind',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindTitle',
      desc: '',
      args: [],
    );
  }

  /// `Smart rewind`
  String get screensSettingsPlayerPlayerSettingsSmartRewindSmartRewind {
    return Intl.message(
      'Smart rewind',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindSmartRewind',
      desc: '',
      args: [],
    );
  }

  /// `When playback is resumed after a pause, rewind by an amount based on how long playback was paused.`
  String get screensSettingsPlayerPlayerSettingsSmartRewindSmartRewindDescription {
    return Intl.message(
      'When playback is resumed after a pause, rewind by an amount based on how long playback was paused.',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindSmartRewindDescription',
      desc: '',
      args: [],
    );
  }

  /// `Short-pause threshold`
  String get screensSettingsPlayerPlayerSettingsSmartRewindShortPauseThreshold {
    return Intl.message(
      'Short-pause threshold',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindShortPauseThreshold',
      desc: '',
      args: [],
    );
  }

  /// `If paused up to this amount, the short smart rewind value is used.`
  String get screensSettingsPlayerPlayerSettingsSmartRewindShortPauseThresholdDescription {
    return Intl.message(
      'If paused up to this amount, the short smart rewind value is used.',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindShortPauseThresholdDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enable Smart rewind to configure this option.`
  String get screensSettingsPlayerPlayerSettingsSmartRewindEnableSmartRewindDisabledReason {
    return Intl.message(
      'Enable Smart rewind to configure this option.',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindEnableSmartRewindDisabledReason',
      desc: '',
      args: [],
    );
  }

  /// `Long-pause threshold`
  String get screensSettingsPlayerPlayerSettingsSmartRewindLongPauseThreshold {
    return Intl.message(
      'Long-pause threshold',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindLongPauseThreshold',
      desc: '',
      args: [],
    );
  }

  /// `If paused longer than the short threshold and up to this amount, the medium smart rewind value is used. Longer pauses use the long smart rewind value.`
  String get screensSettingsPlayerPlayerSettingsSmartRewindLongPauseThresholdDescription {
    return Intl.message(
      'If paused longer than the short threshold and up to this amount, the medium smart rewind value is used. Longer pauses use the long smart rewind value.',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindLongPauseThresholdDescription',
      desc: '',
      args: [],
    );
  }

  /// `Short rewind amount`
  String get screensSettingsPlayerPlayerSettingsSmartRewindShortRewindAmount {
    return Intl.message(
      'Short rewind amount',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindShortRewindAmount',
      desc: '',
      args: [],
    );
  }

  /// `Rewind amount used for short pauses.`
  String get screensSettingsPlayerPlayerSettingsSmartRewindShortRewindAmountDescription {
    return Intl.message(
      'Rewind amount used for short pauses.',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindShortRewindAmountDescription',
      desc: '',
      args: [],
    );
  }

  /// `Medium rewind amount`
  String get screensSettingsPlayerPlayerSettingsSmartRewindMediumRewindAmount {
    return Intl.message(
      'Medium rewind amount',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindMediumRewindAmount',
      desc: '',
      args: [],
    );
  }

  /// `Rewind amount used for medium pauses.`
  String get screensSettingsPlayerPlayerSettingsSmartRewindMediumRewindAmountDescription {
    return Intl.message(
      'Rewind amount used for medium pauses.',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindMediumRewindAmountDescription',
      desc: '',
      args: [],
    );
  }

  /// `Long rewind amount`
  String get screensSettingsPlayerPlayerSettingsSmartRewindLongRewindAmount {
    return Intl.message(
      'Long rewind amount',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindLongRewindAmount',
      desc: '',
      args: [],
    );
  }

  /// `Rewind amount used for long pauses.`
  String get screensSettingsPlayerPlayerSettingsSmartRewindLongRewindAmountDescription {
    return Intl.message(
      'Rewind amount used for long pauses.',
      name: 'screensSettingsPlayerPlayerSettingsSmartRewindLongRewindAmountDescription',
      desc: '',
      args: [],
    );
  }

  /// `Requires upload permission.`
  String get componentsSettingsServerManagementUploadModeButtonRequiresUploadPermission {
    return Intl.message(
      'Requires upload permission.',
      name: 'componentsSettingsServerManagementUploadModeButtonRequiresUploadPermission',
      desc: '',
      args: [],
    );
  }

  /// `Enable "Upload items" first.`
  String get componentsSettingsServerManagementUploadModeButtonEnableUploadItemsFirst {
    return Intl.message(
      'Enable "Upload items" first.',
      name: 'componentsSettingsServerManagementUploadModeButtonEnableUploadItemsFirst',
      desc: '',
      args: [],
    );
  }

  /// `Select a library before opening upload mode.`
  String get componentsSettingsServerManagementUploadModeButtonSelectLibraryBeforeOpeningUploadMode {
    return Intl.message(
      'Select a library before opening upload mode.',
      name: 'componentsSettingsServerManagementUploadModeButtonSelectLibraryBeforeOpeningUploadMode',
      desc: '',
      args: [],
    );
  }

  /// `Open upload`
  String get componentsSettingsServerManagementUploadModeButtonOpenUpload {
    return Intl.message(
      'Open upload',
      name: 'componentsSettingsServerManagementUploadModeButtonOpenUpload',
      desc: '',
      args: [],
    );
  }

  /// `Upload mode requires upload permission and enabled upload actions.`
  String
  get componentsSettingsServerManagementUploadModeButtonUploadModeRequiresUploadPermissionAndEnabledUploadActions {
    return Intl.message(
      'Upload mode requires upload permission and enabled upload actions.',
      name:
          'componentsSettingsServerManagementUploadModeButtonUploadModeRequiresUploadPermissionAndEnabledUploadActions',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get componentsSettingsServerManagementUploadModeButtonOpen {
    return Intl.message('Open', name: 'componentsSettingsServerManagementUploadModeButtonOpen', desc: '', args: []);
  }

  /// `This application is provided "as is" without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement.`
  String get screensSettingsLicenseSettingsProvidedAsIsWithoutWarranty {
    return Intl.message(
      'This application is provided "as is" without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement.',
      name: 'screensSettingsLicenseSettingsProvidedAsIsWithoutWarranty',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'en')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
