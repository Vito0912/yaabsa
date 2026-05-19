// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(error) => "Force metadata refresh failed: ${error}";

  static String m1(error) => "Failed to load libraries: ${error}";

  static String m2(libraries, tagged, updated) =>
      "Processed ${Intl.plural(libraries, one: '1 library', other: '${libraries} libraries')} and tagged ${tagged} item(s). Server reported ${updated} updated item(s).";

  static String m3(error) => "Failed to load libraries: ${error}";

  static String m4(error, noun) => "Failed to split ${noun}: ${error}";

  static String m5(splitType) =>
      "${Intl.select(splitType, {'tags': 'Split Tags', 'genres': 'Split Genres', 'other': 'Split Metadata Terms'})}";

  static String m6(itemsChanged, itemsUpdated, librariesProcessed, noun, termsSplit) =>
      "Split ${termsSplit} composite ${noun} value(s), touched ${itemsChanged} item(s), and applied ${itemsUpdated} update(s) across ${Intl.plural(librariesProcessed, one: '1 library', other: '${librariesProcessed} libraries')}.";

  static String m7(count) => "${Intl.plural(count, one: '1 book', other: '${count} books')}";

  static String m8(authorsWithoutBooks, scannedAuthors) =>
      "Checked ${scannedAuthors} authors, found ${authorsWithoutBooks} with 0 books.";

  static String m9(count) => "${Intl.plural(count, one: 'Delete 1 Author?', other: 'Delete ${count} Authors?')}";

  static String m10(authorName, current, total) => "Deleting ${authorName} (${current}/${total})...";

  static String m11(deletedCount, failedCount, failedPreview) =>
      "${Intl.plural(deletedCount, zero: 'Deleted no authors without books.', one: 'Deleted 1 author without books.', other: 'Deleted ${deletedCount} authors without books.')}${Intl.plural(failedCount, zero: ' ', one: ' 1 author failed: ${failedPreview}', other: ' ${failedCount} authors failed: ${failedPreview}')}";

  static String m12(page, pageSize) => "Loading page ${page} (size ${pageSize})...";

  static String m13(completed, total) => "${completed}/${total}";

  static String m14(count) => "${Intl.plural(count, one: '1 book', other: '${count} books')}";

  static String m15(count) => "${Intl.plural(count, one: '1 series', other: '${count} series groups')}";

  static String m16(taskTitle) => "Canceled ${taskTitle}.";

  static String m17(e) => "Could not cancel download: ${e}";

  static String m18(taskTitle) => "Could not cancel ${taskTitle}.";

  static String m19(p1) => "Could not load active downloads: ${p1}";

  static String m20(error) => "Error: ${error}";

  static String m21(p1, p2) => "${p1} | ${p2}%";

  static String m22(downloadedFiles, totalFiles) => "Downloaded files: ${downloadedFiles}/${totalFiles}";

  static String m23(error) => "Could not load item details for editing.\n${error}";

  static String m24(error) => "Failed to cancel encoding: ${error}";

  static String m25(error) => "Failed to load metadata object: ${error}";

  static String m26(error) => "Failed to start embedding: ${error}";

  static String m27(error) => "Failed to start M4B encoding: ${error}";

  static String m28(statusCode) => "Request failed (${statusCode}).";

  static String m29(value) => "${value}k";

  static String m30(value) => "${value}ch";

  static String m31(p1) => "Progress: ${p1}";

  static String m32(p1) => "${p1}.";

  static String m33(bitrate, channels, codec, duration, size) =>
      "${codec} • ${bitrate} • ${channels} • ${duration} • ${size}";

  static String m34(count) => "Audio files (${count})";

  static String m35(count) => "Chapters (${count})";

  static String m36(error) => "Could not run quick match: ${error}";

  static String m37(error) => "Failed to save manual match: ${error}";

  static String m38(currentLabel) => "Current: ${currentLabel}";

  static String m39(error) => "${error}";

  static String m40(error) => "Could not load metadata providers: ${error}";

  static String m41(error) => "Could not remove authors without books: ${error}";

  static String m42(p1) => "Delete ${p1}";

  static String m43(p1, p2) => "${p1}/${p2}";

  static String m44(count) => "${count} options";

  static String m45(label) => "Selected: ${label}";

  static String m46(error) => "Could not quick match selected books: ${error}";

  static String m47(p1) => "Files (${p1})";

  static String m48(p1, p2, p3) => "Suggested: ${p1} | ${p2} | ${p3}";

  static String m49(p1, p2) => "${p1} | ${p2}";

  static String m50(p1) => "- ${p1}";

  static String m51(p1) => "Upload to ${p1}";

  static String m52(error) => "Error loading current user: ${error}";

  static String m53(error) => "Error loading users: ${error}";

  static String m54(p1) => "Selected (${p1})";

  static String m55(count) => "${Intl.plural(count, one: 'Delete audiobook?', other: 'Delete audiobooks?')}";

  static String m56(count) =>
      "${Intl.plural(count, one: 'This action will remove the audiobook from Audiobookshelf and cannot be undone.', other: 'This action will remove ${count} audiobooks from Audiobookshelf and cannot be undone.')}";

  static String m57(skippedCount) => "${skippedCount} selected item(s) are not audiobooks and will be skipped.";

  static String m58(hiddenBookCount) => "+${hiddenBookCount}";

  static String m59(deviceName) => "Casting to ${deviceName}.";

  static String m60(error) => "Failed to cast: ${error}";

  static String m61(error) => "Failed to disconnect: ${error}";

  static String m62(deviceName) => "Unable to connect to ${deviceName}.";

  static String m63(p1) => "Remaining ${p1}";

  static String m64(p1) => "${p1}x";

  static String m65(p1) => "${p1}%";

  static String m66(p1) => "Volume ${p1}%";

  static String m67(p1) => "Delete ${p1} selected session(s)? This cannot be undone.";

  static String m68(deletedCount) => "Deleted ${deletedCount} session(s).";

  static String m69(p1) => "Failed to delete ${p1} session(s). Check logs for details.";

  static String m70(error) => "Failed to load user: ${error}";

  static String m71(p1) => "${p1} selected";

  static String m72(p1) => "Delete ${p1} selected session(s)? This cannot be undone.";

  static String m73(deletedCount) => "Deleted ${deletedCount} session(s).";

  static String m74(p1) => "Failed to delete ${p1} session(s). Check logs for details.";

  static String m75(error) => "Failed to load user: ${error}";

  static String m76(p1) => "${p1} selected";

  static String m77(error) => "Failed to delete listening session: ${error}";

  static String m78(error) => "Failed to save listening session changes: ${error}";

  static String m79(clampedPages, currentPage) => "Page ${currentPage} / ${clampedPages}";

  static String m80(total) => "Total: ${total}";

  static String m81(name) => "Added provider \"${name}\".";

  static String m82(p1) => "Deleted provider \"${p1}\".";

  static String m83(name) => "Updated provider \"${name}\".";

  static String m84(error) => "Failed to load user data: ${error}";

  static String m85(rank) => "${rank}.";

  static String m86(p1) => "Delete ${p1}";

  static String m87(p1) => "Refresh ${p1}s";

  static String m88(p1) => "Rename ${p1}";

  static String m89(mergeMessage, updatedCount) => "Updated ${updatedCount} item(s).${mergeMessage}";

  static String m90(p1) => "Updated ${p1} item(s).";

  static String m91(error) => "Failed to load user data: ${error}";

  static String m92(error) => "Failed to load user data: ${error}";

  static String m93(p1) => "Delete ${p1} selected session(s)? This cannot be undone.";

  static String m94(deletedCount) => "Deleted ${deletedCount} session(s).";

  static String m95(p1) => "Failed to delete ${p1} session(s). Check logs for details.";

  static String m96(error) => "Failed to load user data: ${error}";

  static String m97(p1) => "${p1} selected";

  static String m98(p1) => "Delete user \"${p1}\"? This cannot be undone.";

  static String m99(error) => "Failed to load user data: ${error}";

  static String m100(_noun) =>
      "This tool splits combined {_noun} values using the delimiter below and updates affected items in the selected libraries.";

  static String m101(p1, p2) => "${p1}/${p2}";

  static String m102(value) => "Created: ${value}";

  static String m103(value) => "Last seen: ${value}";

  static String m104(p1, p2) => "${p1}/${p2}";

  static String m105(failedFiles) =>
      "${Intl.plural(failedFiles, zero: ' ', one: ' 1 file could not be removed.', other: ' ${failedFiles} files could not be removed.')}";

  static String m106(count) => "${Intl.plural(count, one: '1 file remaining', other: '${count} files remaining')}";

  static String m107(count) => "${Intl.plural(count, one: 'this download', other: 'these ${count} downloads')}";

  static String m108(deletedFiles, deletedItems, failedFiles, failedItems) =>
      "${Intl.plural(deletedItems, zero: 'Deleted no items', one: 'Deleted 1 item', other: 'Deleted ${deletedItems} items')}, ${Intl.plural(deletedFiles, zero: 'removed no files', one: 'removed 1 file', other: 'removed ${deletedFiles} files')}.${Intl.plural(failedFiles, zero: ' ', one: ' 1 file could not be removed.', other: ' ${failedFiles} files could not be removed.')}${Intl.plural(failedItems, zero: ' ', one: ' 1 item failed to delete.', other: ' ${failedItems} items failed to delete.')}";

  static String m109(count) => "${Intl.plural(count, one: '1 downloaded item', other: '${count} downloaded items')}";

  static String m110(count) => "${Intl.plural(count, one: '1 selected', other: '${count} selected')}";

  static String m111(count) =>
      "${Intl.plural(count, one: 'Deleted 1 audiobook from Audiobookshelf.', other: 'Deleted ${count} audiobooks from Audiobookshelf.')}";

  static String m112(count) =>
      "${Intl.plural(count, one: 'Deleted 1 audiobook from Audiobookshelf and file system.', other: 'Deleted ${count} audiobooks from Audiobookshelf and file system.')}";

  static String m113(title) => "Deleted \"${title}\" from Audiobookshelf.";

  static String m114(title) => "Deleted \"${title}\" from Audiobookshelf and file system.";

  static String m115(state) =>
      "Could not mark episode as ${Intl.select(state, {'finished': 'finished', 'unfinished': 'unfinished', 'other': '${state}'})}.";

  static String m116(state) =>
      "Could not mark item as ${Intl.select(state, {'finished': 'finished', 'unfinished': 'unfinished', 'other': '${state}'})}.";

  static String m117(state) =>
      "Could not mark selected items as ${Intl.select(state, {'finished': 'finished', 'unfinished': 'unfinished', 'other': '${state}'})}.";

  static String m118(state, episodeTitle) =>
      "Marked \"${episodeTitle}\" as ${Intl.select(state, {'finished': 'finished', 'unfinished': 'unfinished', 'other': '${state}'})}.";

  static String m119(state, itemTitle) =>
      "Marked \"${itemTitle}\" as ${Intl.select(state, {'finished': 'finished', 'unfinished': 'unfinished', 'other': '${state}'})}.";

  static String m120(count, state) =>
      "${Intl.plural(count, one: 'Marked 1 selected item as ${Intl.select(state, {'finished': 'finished', 'unfinished': 'unfinished', 'other': '${state}'})}.', other: 'Marked ${count} selected items as ${Intl.select(state, {'finished': 'finished', 'unfinished': 'unfinished', 'other': '${state}'})}.')}";

  static String m121(count) => "${Intl.plural(count, one: '1 selected', other: '${count} selected')}";

  static String m122(channels) => "${Intl.plural(channels, one: 'Mono', other: 'Stereo')}";

  static String m123(count) => "${Intl.plural(count, one: '1 book in series', other: '${count} books in series')}";

  static String m124(count, targetTitle) =>
      "${Intl.plural(count, one: 'Added 1 book to \"${targetTitle}\".', other: 'Added ${count} books to \"${targetTitle}\".')}";

  static String m125(count, targetTitle) =>
      "${Intl.plural(count, one: 'Added 1 book to \"${targetTitle}\".', other: 'Added ${count} books to \"${targetTitle}\".')}";

  static String m126(count) =>
      "${Intl.plural(count, one: 'Metadata change request completed. 1 book updated.', other: 'Metadata change request completed. ${count} books updated.')}";

  static String m127(count) =>
      "${Intl.plural(count, one: 'Metadata change request sent for 1 book.', other: 'Metadata change request sent for ${count} books.')}";

  static String m128(count) => "${Intl.plural(count, one: 'Run for 1', other: 'Run for ${count}')}";

  static String m129(count) =>
      "${Intl.plural(count, one: 'Added 1 upload item.', other: 'Added ${count} upload items.')}";

  static String m130(attempt, maxAttempts) =>
      "${Intl.plural(attempt, one: 'Uploading...', other: 'Retrying upload (${attempt}/${maxAttempts})...')}";

  static String m131(author) => "Author: ${author}";

  static String m132(count) => "${Intl.plural(count, one: '1 provider', other: '${count} providers')}";

  static String m133(title) => "Title: ${title}";

  static String m134(count) => "${Intl.plural(count, one: '1 result', other: '${count} results')}";

  static String m135(position) => "Current position: ${position}";

  static String m136(missingCount) =>
      "${Intl.plural(missingCount, one: '1 playlist entry is not directly displayable.', other: '${missingCount} playlist entries are not directly displayable.')}";

  static String m137(cfi) => "CFI: ${cfi}";

  static String m138(e) => "Could not delete download: ${e}";

  static String m139(e) => "Could not start download: ${e}";

  static String m140(failedSuffix, p1) => "Deleted ${p1} file(s).${failedSuffix}";

  static String m141(e) => "Could not delete download: ${e}";

  static String m142(e) => "Could not start download: ${e}";

  static String m143(failedSuffix, p1) => "Deleted ${p1} file(s).${failedSuffix}";

  static String m144(e) => "Could not delete download: ${e}";

  static String m145(e) => "Could not start download: ${e}";

  static String m146(failedSuffix, p1) => "Deleted ${p1} file(s).${failedSuffix}";

  static String m147(label) => "Delete ${label} from local storage and remove it from Downloads?";

  static String m148(error) => "Failed to queue visible items: ${error}";

  static String m149(err) => "Error loading search results: ${err}";

  static String m150(query) => "No results found for \"${query}\".";

  static String m151(query) => "Search results for \"${query}\"";

  static String m152(range) => "${range}d";

  static String m153(_selectedRange) => "Last {_selectedRange} days";

  static String m154(p1, p2) => "${p1}/${p2}";

  static String m155(p1, p2, totalPagesLabel, totalSessionsLabel) =>
      "Pages ${p1}/${totalPagesLabel} • Sessions ${p2}/${totalSessionsLabel}";

  static String m156(year) => "${year} in rewind";

  static String m157(peakMonth) => "Peak month: ${peakMonth}";

  static String m158(p1) => "Bookmark added at ${p1}";

  static String m159(p1, p2) => "${p1} - ${p2}";

  static String m160(p1) => "Font scale ${p1}x";

  static String m161(p1) => "Scale ${p1}x";

  static String m162(p1) => "Seek bar height ${p1}";

  static String m163(p1) => "${p1} settings";

  static String m164(p1) => "Time font size ${p1}";

  static String m165(p1) => "Error: ${p1}";

  static String m166(timeText) => "Position: ${timeText}";

  static String m167(error) => "Failed to load item sessions: ${error}";

  static String m168(p1) => "Edit ${p1} Layout";

  static String m169(p1) => "No free grid space available for ${p1}.";

  static String m170(remaining) => "and ${remaining} more to load";

  static String m171(error) => "Failed to load ebook metadata: ${error}";

  static String m172(error) => "Failed to load user profile: ${error}";

  static String m173(e) => "Error removing bookmark: ${e}";

  static String m174(e) => "Error removing highlight: ${e}";

  static String m175(e) => "Error removing underline: ${e}";

  static String m176(p1) => "Page ${p1}";

  static String m177(p1, p2) => "Page ${p1} (${p2}px)";

  static String m178(p1, p2) => "Range ${p1}-${p2}";

  static String m179(p1) => "${p1}px";

  static String m180(error) => "Failed to load user settings: ${error}";

  static String m181(managedServer) => "You currently are managing the server ${managedServer}";

  static String m182(error) => "Failed to load user settings: ${error}";

  static String m183(e) => "Failed to update sort field: ${e}";

  static String m184(error) => "Failed to load user settings: ${error}";

  static String m185(e) => "Failed to update sort field: ${e}";

  static String m186(error) => "Failed to load user settings: ${error}";

  static String m187(error) => "Failed to load user settings: ${error}";

  static String m188(e) => "Failed to update collapse series setting: ${e}";

  static String m189(e) => "Failed to update location: ${e}";

  static String m190(error) => "Failed to export logs: ${error}";

  static String m191(destinationDescription, p1) => "Logs exported to .log file (${destinationDescription}): ${p1}";

  static String m192(error) => "Unable to load subtitle settings: ${error}";

  static String m193(error) => "Failed to load user: ${error}";

  static String m194(e) => "Failed to save server settings: ${e}";

  static String m195(error) => "Failed to load user settings: ${error}";

  static String m196(p1) => "Are you sure you want to delete \"${p1}\"? This action cannot be undone.";

  static String m197(p1) => "Deleted user ${p1}";

  static String m198(e) => "Error loading user data: ${e}";

  static String m199(e, p1) => "Failed to delete user ${p1}: ${e}";

  static String m200(p1) => "Sign out from \"${p1}\" on this device?";

  static String m201(p1) => "Switched to ${p1}";

  static String m202(error) => "Failed to load user settings: ${error}";

  static String m203(state) =>
      "${Intl.select(state, {'reachable': 'Server is reachable', 'unreachable': 'Server is unreachable', 'other': 'Server status unknown'})}";

  static String m204(count) => "${Intl.plural(count, one: '1 entry', other: '${count} entries')}";

  static String m205(count) =>
      "<summary>Logs (${Intl.plural(count, one: '1 entry', other: '${count} entries')})</summary>";

  static String m206(days) => "${Intl.plural(days, one: '1 day', other: '${days} days')}";

  static String m207(count) => "${Intl.plural(count, one: '1 task running', other: '${count} tasks running')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "adminForceMetadataRefreshToolFailed": m0,
    "adminForceMetadataRefreshToolFailedToLoadLibraries": m1,
    "adminForceMetadataRefreshToolResultSummary": m2,
    "adminForceMetadataRefreshToolRunTool": MessageLookupByLibrary.simpleMessage("Run Tool"),
    "adminForceMetadataRefreshToolRunning": MessageLookupByLibrary.simpleMessage("Running..."),
    "adminForceMetadataRefreshToolSelectAtLeastOneLibrary": MessageLookupByLibrary.simpleMessage(
      "Select at least one library.",
    ),
    "adminSplitMetadataTermsToolDelimiterCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Delimiter cannot be empty.",
    ),
    "adminSplitMetadataTermsToolFailedToLoadLibraries": m3,
    "adminSplitMetadataTermsToolFailedToSplit": m4,
    "adminSplitMetadataTermsToolLabel": m5,
    "adminSplitMetadataTermsToolResultSummary": m6,
    "adminSplitMetadataTermsToolRunTool": MessageLookupByLibrary.simpleMessage("Run Tool"),
    "adminSplitMetadataTermsToolRunning": MessageLookupByLibrary.simpleMessage("Running..."),
    "adminSplitMetadataTermsToolSelectAtLeastOneLibrary": MessageLookupByLibrary.simpleMessage(
      "Select at least one library.",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("Yaabsa"),
    "authorCleanupBookCount": m7,
    "authorCleanupCheckedAuthorsSummary": m8,
    "authorCleanupCheckingAuthors": MessageLookupByLibrary.simpleMessage("Checking Authors..."),
    "authorCleanupDeleteAuthorsTitle": m9,
    "authorCleanupDeletingAuthorProgress": m10,
    "authorCleanupDeletingAuthorsTitle": MessageLookupByLibrary.simpleMessage("Deleting Authors"),
    "authorCleanupDeletionResultSummary": m11,
    "authorCleanupLoadingPage": m12,
    "authorCleanupPreparingToLoadAuthors": MessageLookupByLibrary.simpleMessage("Preparing to load authors..."),
    "authorCleanupProgressCount": m13,
    "authorCleanupRemoveAuthorsWithoutBooks": MessageLookupByLibrary.simpleMessage("Remove Authors Without Books"),
    "authorCleanupScanningAuthorsTitle": MessageLookupByLibrary.simpleMessage("Scanning Authors"),
    "authorDetailBookCount": m14,
    "authorDetailBooksTitle": MessageLookupByLibrary.simpleMessage("Books"),
    "authorDetailErrorLoadingDetails": MessageLookupByLibrary.simpleMessage("Error loading author details"),
    "authorDetailNoBooksFoundForThisAuthor": MessageLookupByLibrary.simpleMessage("No books found for this author."),
    "authorDetailNoSeriesFoundForThisAuthor": MessageLookupByLibrary.simpleMessage("No series found for this author."),
    "authorDetailOpenSeries": MessageLookupByLibrary.simpleMessage("Open series"),
    "authorDetailSeriesCount": m15,
    "authorDetailSeriesTitle": MessageLookupByLibrary.simpleMessage("Series"),
    "authorsViewErrorLoadingAuthors": MessageLookupByLibrary.simpleMessage("Error loading authors"),
    "commonAaos": MessageLookupByLibrary.simpleMessage("AAOS"),
    "commonActivities": MessageLookupByLibrary.simpleMessage("Activities"),
    "commonAndroidAuto": MessageLookupByLibrary.simpleMessage("Android Auto"),
    "commonChange": MessageLookupByLibrary.simpleMessage("Change"),
    "commonChoose": MessageLookupByLibrary.simpleMessage("Choose"),
    "commonConnectWithApiKey": MessageLookupByLibrary.simpleMessage("Connect with API Key"),
    "commonCouldNotUnlinkOpenId": MessageLookupByLibrary.simpleMessage("Could not unlink OpenID."),
    "commonEpisode": MessageLookupByLibrary.simpleMessage("Episode"),
    "commonHidePassword": MessageLookupByLibrary.simpleMessage("Hide password"),
    "commonLoading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "commonOpenIdLinkRemoved": MessageLookupByLibrary.simpleMessage("OpenID link removed."),
    "commonPause": MessageLookupByLibrary.simpleMessage("Pause"),
    "commonPlay": MessageLookupByLibrary.simpleMessage("Play"),
    "commonReplay": MessageLookupByLibrary.simpleMessage("Replay"),
    "commonResume": MessageLookupByLibrary.simpleMessage("Resume"),
    "commonSaveChanges": MessageLookupByLibrary.simpleMessage("Save changes"),
    "commonSaving": MessageLookupByLibrary.simpleMessage("Saving..."),
    "commonSearch": MessageLookupByLibrary.simpleMessage("Search"),
    "commonSearching": MessageLookupByLibrary.simpleMessage("Searching..."),
    "commonShowPassword": MessageLookupByLibrary.simpleMessage("Show password"),
    "commonSignIn": MessageLookupByLibrary.simpleMessage("Sign In"),
    "commonSigningIn": MessageLookupByLibrary.simpleMessage("Signing in..."),
    "commonTaskActivity": MessageLookupByLibrary.simpleMessage("Task Activity"),
    "commonTasks": MessageLookupByLibrary.simpleMessage("Tasks"),
    "commonUnknownError": MessageLookupByLibrary.simpleMessage("Unknown error"),
    "commonUserDisabled": MessageLookupByLibrary.simpleMessage("User disabled."),
    "commonUserEnabled": MessageLookupByLibrary.simpleMessage("User enabled."),
    "componentsAppDownloadStatusCancelDownload": MessageLookupByLibrary.simpleMessage("Cancel download"),
    "componentsAppDownloadStatusCanceledDownloadTask": m16,
    "componentsAppDownloadStatusCouldNotCancelDownload": m17,
    "componentsAppDownloadStatusCouldNotCancelDownloadTask": m18,
    "componentsAppDownloadStatusCouldNotLoadActiveDownloads": m19,
    "componentsAppDownloadStatusDownloadError": MessageLookupByLibrary.simpleMessage("Download Error"),
    "componentsAppDownloadStatusDownloadsInProgress": MessageLookupByLibrary.simpleMessage("Downloads in progress"),
    "componentsAppDownloadStatusError": m20,
    "componentsAppDownloadStatusNoActiveDownloads": MessageLookupByLibrary.simpleMessage("No active downloads."),
    "componentsAppDownloadStatusOk": MessageLookupByLibrary.simpleMessage("OK"),
    "componentsAppDownloadStatusText": m21,
    "componentsAppDownloadsDownloadListTileDeleteDownload": MessageLookupByLibrary.simpleMessage("Delete download"),
    "componentsAppDownloadsDownloadListTileDownloadedFiles": m22,
    "componentsAppDownloadsDownloadListTileWarningDownloadUnfinishedOrIncompleteNot":
        MessageLookupByLibrary.simpleMessage(
          "Warning: Download unfinished or incomplete. Not available for offline use yet.",
        ),
    "componentsAppItemEditorLibraryItemEditOverlayCloseEditor": MessageLookupByLibrary.simpleMessage("Close editor"),
    "componentsAppItemEditorLibraryItemEditOverlayCouldNotLoadItemDetailsFor": m23,
    "componentsAppItemEditorLibraryItemEditOverlayCouldNotSaveItemDetails": MessageLookupByLibrary.simpleMessage(
      "Could not save item details.",
    ),
    "componentsAppItemEditorLibraryItemEditOverlayEditItem": MessageLookupByLibrary.simpleMessage("Edit item"),
    "componentsAppItemEditorLibraryItemEditOverlayEmbeddingTaskFailed": MessageLookupByLibrary.simpleMessage(
      "Embedding task failed.",
    ),
    "componentsAppItemEditorLibraryItemEditOverlayFailedToCancelEncoding": m24,
    "componentsAppItemEditorLibraryItemEditOverlayFailedToLoadMetadataObject": m25,
    "componentsAppItemEditorLibraryItemEditOverlayFailedToStartEmbedding": m26,
    "componentsAppItemEditorLibraryItemEditOverlayFailedToStartM4bEncoding": m27,
    "componentsAppItemEditorLibraryItemEditOverlayM4bEncodingTaskFailed": MessageLookupByLibrary.simpleMessage(
      "M4B encoding task failed.",
    ),
    "componentsAppItemEditorLibraryItemEditOverlayNextItem": MessageLookupByLibrary.simpleMessage("Next item"),
    "componentsAppItemEditorLibraryItemEditOverlayNoServerConnectionAvailable": MessageLookupByLibrary.simpleMessage(
      "No server connection available.",
    ),
    "componentsAppItemEditorLibraryItemEditOverlayPreviousItem": MessageLookupByLibrary.simpleMessage("Previous item"),
    "componentsAppItemEditorLibraryItemEditOverlayRequestFailed": m28,
    "componentsAppItemEditorLibraryItemEditOverlaySavedItemDetails": MessageLookupByLibrary.simpleMessage(
      "Saved item details.",
    ),
    "componentsAppItemEditorLibraryItemEditOverlayTabDetails": MessageLookupByLibrary.simpleMessage("Details"),
    "componentsAppItemEditorLibraryItemEditOverlayTabEmbedding": MessageLookupByLibrary.simpleMessage("Embedding"),
    "componentsAppItemEditorLibraryItemEditOverlayTabEncoder": MessageLookupByLibrary.simpleMessage("Encoder"),
    "componentsAppItemEditorLibraryItemEditOverlayUpdateRequestFailed": MessageLookupByLibrary.simpleMessage(
      "Update request failed.",
    ),
    "componentsAppItemEditorLibraryItemEditorFormClose": MessageLookupByLibrary.simpleMessage("Close"),
    "componentsAppItemEditorLibraryItemEditorFormDescription": MessageLookupByLibrary.simpleMessage("Description"),
    "componentsAppItemEditorLibraryItemEditorFormEpisodicOrSerial": MessageLookupByLibrary.simpleMessage(
      "episodic or serial",
    ),
    "componentsAppItemEditorLibraryItemEditorFormMetadata": MessageLookupByLibrary.simpleMessage("Metadata"),
    "componentsAppItemEditorLibraryItemEditorFormNoChangesToSave": MessageLookupByLibrary.simpleMessage(
      "No changes to save.",
    ),
    "componentsAppItemEditorLibraryItemEditorFormYyyyMMDD": MessageLookupByLibrary.simpleMessage("YYYY-MM-DD"),
    "componentsAppItemEditorLibraryItemEditorInputsAddSeries": MessageLookupByLibrary.simpleMessage("Add series"),
    "componentsAppItemEditorLibraryItemEditorInputsCouldNotOpenTheSeriesSequence": MessageLookupByLibrary.simpleMessage(
      "Could not open the series sequence prompt. Please try again.",
    ),
    "componentsAppItemEditorLibraryItemEditorInputsEG12503": MessageLookupByLibrary.simpleMessage(
      "e.g. 1,2.5,03 (no spaces)",
    ),
    "componentsAppItemEditorLibraryItemEditorInputsSave": MessageLookupByLibrary.simpleMessage("Save"),
    "componentsAppItemEditorLibraryItemEditorInputsSequence": MessageLookupByLibrary.simpleMessage("Sequence"),
    "componentsAppItemEditorLibraryItemEditorInputsSeries": MessageLookupByLibrary.simpleMessage("Series"),
    "componentsAppItemEditorLibraryItemEditorInputsSeriesNumber": MessageLookupByLibrary.simpleMessage("Series number"),
    "componentsAppItemEditorLibraryItemEditorInputsSkip": MessageLookupByLibrary.simpleMessage("Skip"),
    "componentsAppItemEditorLibraryItemEmbeddingViewBackupAudioFilesBeforeEmbedding":
        MessageLookupByLibrary.simpleMessage("Backup audio files before embedding"),
    "componentsAppItemEditorLibraryItemEmbeddingViewChaptersToEmbed": MessageLookupByLibrary.simpleMessage(
      "Chapters To Embed",
    ),
    "componentsAppItemEditorLibraryItemEmbeddingViewEmbedding": MessageLookupByLibrary.simpleMessage("Embedding"),
    "componentsAppItemEditorLibraryItemEmbeddingViewForceChapterEmbedding": MessageLookupByLibrary.simpleMessage(
      "Force chapter embedding",
    ),
    "componentsAppItemEditorLibraryItemEmbeddingViewForcesChapterMarkersToBeRewritten":
        MessageLookupByLibrary.simpleMessage(
          "Forces chapter markers to be rewritten in the output files, even when chapters already exist.",
        ),
    "componentsAppItemEditorLibraryItemEmbeddingViewMetadataToEmbed": MessageLookupByLibrary.simpleMessage(
      "Metadata To Embed",
    ),
    "componentsAppItemEditorLibraryItemEmbeddingViewNoAudioTracksAreAvailableFor": MessageLookupByLibrary.simpleMessage(
      "No audio tracks are available for metadata embedding.",
    ),
    "componentsAppItemEditorLibraryItemEmbeddingViewNoChaptersAvailable": MessageLookupByLibrary.simpleMessage(
      "No chapters available.",
    ),
    "componentsAppItemEditorLibraryItemEmbeddingViewNoMetadataObjectReturnedByThe":
        MessageLookupByLibrary.simpleMessage("No metadata object returned by the server."),
    "componentsAppItemEditorLibraryItemEmbeddingViewQueued": MessageLookupByLibrary.simpleMessage("Queued"),
    "componentsAppItemEditorLibraryItemEmbeddingViewRefreshMetadata": MessageLookupByLibrary.simpleMessage(
      "Refresh Metadata",
    ),
    "componentsAppItemEditorLibraryItemEmbeddingViewRunning": MessageLookupByLibrary.simpleMessage("Running..."),
    "componentsAppItemEditorLibraryItemEmbeddingViewStartEmbed": MessageLookupByLibrary.simpleMessage("Start Embed"),
    "componentsAppItemEditorLibraryItemEmbeddingViewSubmitting": MessageLookupByLibrary.simpleMessage("Submitting..."),
    "componentsAppItemEditorLibraryItemEmbeddingViewText": MessageLookupByLibrary.simpleMessage("→"),
    "componentsAppItemEditorLibraryItemEncoderViewAdvanced": MessageLookupByLibrary.simpleMessage("Advanced"),
    "componentsAppItemEditorLibraryItemEncoderViewAudioTracks": MessageLookupByLibrary.simpleMessage("Audio Tracks"),
    "componentsAppItemEditorLibraryItemEncoderViewBitrate": MessageLookupByLibrary.simpleMessage("Bitrate"),
    "componentsAppItemEditorLibraryItemEncoderViewBitrateKbps": m29,
    "componentsAppItemEditorLibraryItemEncoderViewCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsAppItemEditorLibraryItemEncoderViewCanceling": MessageLookupByLibrary.simpleMessage("Canceling..."),
    "componentsAppItemEditorLibraryItemEncoderViewChannels": MessageLookupByLibrary.simpleMessage("Channels"),
    "componentsAppItemEditorLibraryItemEncoderViewChannelsShort": m30,
    "componentsAppItemEditorLibraryItemEncoderViewCodec": MessageLookupByLibrary.simpleMessage("Codec"),
    "componentsAppItemEditorLibraryItemEncoderViewM4bEncoder": MessageLookupByLibrary.simpleMessage("M4B Encoder"),
    "componentsAppItemEditorLibraryItemEncoderViewNoAudioTracksAreAvailableFor": MessageLookupByLibrary.simpleMessage(
      "No audio tracks are available for M4B encoding.",
    ),
    "componentsAppItemEditorLibraryItemEncoderViewPresets": MessageLookupByLibrary.simpleMessage("Presets"),
    "componentsAppItemEditorLibraryItemEncoderViewProgress": m31,
    "componentsAppItemEditorLibraryItemEncoderViewRunning": MessageLookupByLibrary.simpleMessage("Running..."),
    "componentsAppItemEditorLibraryItemEncoderViewStartEncode": MessageLookupByLibrary.simpleMessage("Start Encode"),
    "componentsAppItemEditorLibraryItemEncoderViewSubmitting": MessageLookupByLibrary.simpleMessage("Submitting..."),
    "componentsAppItemEditorLibraryItemEncoderViewText": m32,
    "componentsAppItemEditorLibraryItemEncoderViewTrackMetaLine": m33,
    "componentsAppItemEditorLibraryItemEncoderViewUnknownBitrate": MessageLookupByLibrary.simpleMessage(
      "unknown bitrate",
    ),
    "componentsAppItemEditorLibraryItemEncoderViewUnknownChannels": MessageLookupByLibrary.simpleMessage(
      "unknown channels",
    ),
    "componentsAppItemEditorLibraryItemEncoderViewUnknownCodec": MessageLookupByLibrary.simpleMessage("unknown codec"),
    "componentsAppItemEditorLibraryItemEncoderViewUnknownDuration": MessageLookupByLibrary.simpleMessage(
      "unknown duration",
    ),
    "componentsAppItemItemDeleteActionsNoSelectedAudiobooksCanBeDeleted": MessageLookupByLibrary.simpleMessage(
      "No selected audiobooks can be deleted. Select audiobook items and try again.",
    ),
    "componentsAppItemItemDeleteActionsOnlyAudiobooksCanBeDeletedFrom": MessageLookupByLibrary.simpleMessage(
      "Only audiobooks can be deleted from this action.",
    ),
    "componentsAppItemItemDescriptionDescription": MessageLookupByLibrary.simpleMessage("DESCRIPTION"),
    "componentsAppItemItemDescriptionShowLess": MessageLookupByLibrary.simpleMessage("Show less"),
    "componentsAppItemItemDescriptionShowMore": MessageLookupByLibrary.simpleMessage("Show more"),
    "componentsAppItemItemDetailComponentsBack": MessageLookupByLibrary.simpleMessage("Back"),
    "componentsAppItemItemDetailComponentsBookDetails": MessageLookupByLibrary.simpleMessage("Book details"),
    "componentsAppItemItemDetailComponentsText": MessageLookupByLibrary.simpleMessage(", "),
    "componentsAppItemItemMoreActionsButtonAddToCollection": MessageLookupByLibrary.simpleMessage("Add To Collection"),
    "componentsAppItemItemMoreActionsButtonAddToPlaylist": MessageLookupByLibrary.simpleMessage("Add To Playlist"),
    "componentsAppItemItemMoreActionsButtonDeleteAudiobook": MessageLookupByLibrary.simpleMessage("Delete Audiobook"),
    "componentsAppItemItemMoreActionsButtonEditItem": MessageLookupByLibrary.simpleMessage("Edit item"),
    "componentsAppItemItemMoreActionsButtonManualMatch": MessageLookupByLibrary.simpleMessage("Manual Match"),
    "componentsAppItemItemMoreActionsButtonMarkAsFinished": MessageLookupByLibrary.simpleMessage("Mark As Finished"),
    "componentsAppItemItemMoreActionsButtonMarkAsUnfinished": MessageLookupByLibrary.simpleMessage(
      "Mark As Unfinished",
    ),
    "componentsAppItemItemMoreActionsButtonMoreActions": MessageLookupByLibrary.simpleMessage("More actions"),
    "componentsAppItemItemMoreActionsButtonPlayHistory": MessageLookupByLibrary.simpleMessage("Play History"),
    "componentsAppItemItemMoreActionsButtonQuickMatch": MessageLookupByLibrary.simpleMessage("Quick Match"),
    "componentsAppItemItemProgressActionsNoSelectedBooksCanBeUpdated": MessageLookupByLibrary.simpleMessage(
      "No selected books can be updated.",
    ),
    "componentsAppItemItemProgressActionsProgressUpdatesAreCurrentlyAvailableFor": MessageLookupByLibrary.simpleMessage(
      "Progress updates are currently available for books only.",
    ),
    "componentsAppItemItemProgressActionsProgressUpdatesAreCurrentlyAvailableFor2":
        MessageLookupByLibrary.simpleMessage("Progress updates are currently available for podcast episodes only."),
    "componentsAppItemLibraryItemViewComponentsAddToQueue": MessageLookupByLibrary.simpleMessage("Add to queue"),
    "componentsAppItemLibraryItemViewComponentsAudioFilesCount": m34,
    "componentsAppItemLibraryItemViewComponentsAuthors": MessageLookupByLibrary.simpleMessage("Authors"),
    "componentsAppItemLibraryItemViewComponentsChapter": MessageLookupByLibrary.simpleMessage("Chapter"),
    "componentsAppItemLibraryItemViewComponentsChaptersCount": m35,
    "componentsAppItemLibraryItemViewComponentsCurrentlyPlaying": MessageLookupByLibrary.simpleMessage(
      "Currently playing",
    ),
    "componentsAppItemLibraryItemViewComponentsDeleteDownload": MessageLookupByLibrary.simpleMessage("Delete download"),
    "componentsAppItemLibraryItemViewComponentsDownload": MessageLookupByLibrary.simpleMessage("Download"),
    "componentsAppItemLibraryItemViewComponentsDownloading": MessageLookupByLibrary.simpleMessage("Downloading"),
    "componentsAppItemLibraryItemViewComponentsDuration": MessageLookupByLibrary.simpleMessage("Duration"),
    "componentsAppItemLibraryItemViewComponentsEbookFiles": MessageLookupByLibrary.simpleMessage("Ebook files"),
    "componentsAppItemLibraryItemViewComponentsGenres": MessageLookupByLibrary.simpleMessage("Genres"),
    "componentsAppItemLibraryItemViewComponentsLanguage": MessageLookupByLibrary.simpleMessage("Language"),
    "componentsAppItemLibraryItemViewComponentsLength": MessageLookupByLibrary.simpleMessage("Length"),
    "componentsAppItemLibraryItemViewComponentsLoading": MessageLookupByLibrary.simpleMessage("Loading"),
    "componentsAppItemLibraryItemViewComponentsNarrators": MessageLookupByLibrary.simpleMessage("Narrators"),
    "componentsAppItemLibraryItemViewComponentsPause": MessageLookupByLibrary.simpleMessage("Pause"),
    "componentsAppItemLibraryItemViewComponentsPlay": MessageLookupByLibrary.simpleMessage("Play"),
    "componentsAppItemLibraryItemViewComponentsPublishedYear": MessageLookupByLibrary.simpleMessage("Published year"),
    "componentsAppItemLibraryItemViewComponentsPublisher": MessageLookupByLibrary.simpleMessage("Publisher"),
    "componentsAppItemLibraryItemViewComponentsRead": MessageLookupByLibrary.simpleMessage("Read"),
    "componentsAppItemLibraryItemViewComponentsRemoveFromQueue": MessageLookupByLibrary.simpleMessage(
      "Remove from queue",
    ),
    "componentsAppItemLibraryItemViewComponentsResume": MessageLookupByLibrary.simpleMessage("Resume"),
    "componentsAppItemLibraryItemViewComponentsSeries": MessageLookupByLibrary.simpleMessage("Series"),
    "componentsAppItemLibraryItemViewComponentsSize": MessageLookupByLibrary.simpleMessage("Size"),
    "componentsAppItemLibraryItemViewComponentsStart": MessageLookupByLibrary.simpleMessage("Start"),
    "componentsAppItemLibraryItemViewComponentsTags": MessageLookupByLibrary.simpleMessage("Tags"),
    "componentsAppItemMatchLibraryItemQuickMatchActionsCouldNotRunQuickMatch": m36,
    "componentsAppItemMatchLibraryItemQuickMatchActionsNoAPISessionAvailable": MessageLookupByLibrary.simpleMessage(
      "No API session available.",
    ),
    "componentsAppItemMatchManualMatchManualMatchCollapsedSearchBarEdit": MessageLookupByLibrary.simpleMessage("Edit"),
    "componentsAppItemMatchManualMatchManualMatchCollapsedSearchBarSearchFiltersCollapsed":
        MessageLookupByLibrary.simpleMessage("Search filters collapsed"),
    "componentsAppItemMatchManualMatchManualMatchDialogCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsAppItemMatchManualMatchManualMatchDialogCandidates": MessageLookupByLibrary.simpleMessage("Candidates"),
    "componentsAppItemMatchManualMatchManualMatchDialogClose": MessageLookupByLibrary.simpleMessage("Close"),
    "componentsAppItemMatchManualMatchManualMatchDialogFailedToSaveManualMatch": m37,
    "componentsAppItemMatchManualMatchManualMatchDialogNoAPISessionAvailable": MessageLookupByLibrary.simpleMessage(
      "No API session available.",
    ),
    "componentsAppItemMatchManualMatchManualMatchDialogNoMatchResultsFound": MessageLookupByLibrary.simpleMessage(
      "No match results found.",
    ),
    "componentsAppItemMatchManualMatchManualMatchDialogNoWritableValuesWereSelectedFrom":
        MessageLookupByLibrary.simpleMessage("No writable values were selected from this match result."),
    "componentsAppItemMatchManualMatchManualMatchDialogPleaseEnterATitle": MessageLookupByLibrary.simpleMessage(
      "Please enter a title.",
    ),
    "componentsAppItemMatchManualMatchManualMatchDialogSelectAtLeastOneFieldTo": MessageLookupByLibrary.simpleMessage(
      "Select at least one field to apply.",
    ),
    "componentsAppItemMatchManualMatchManualMatchDialogSelectAtLeastOneProvider": MessageLookupByLibrary.simpleMessage(
      "Select at least one provider.",
    ),
    "componentsAppItemMatchManualMatchManualMatchDialogSelection": MessageLookupByLibrary.simpleMessage("Selection"),
    "componentsAppItemMatchManualMatchManualMatchEditorPaneApplyFields": MessageLookupByLibrary.simpleMessage(
      "Apply fields",
    ),
    "componentsAppItemMatchManualMatchManualMatchEditorPaneSelectAMatchResultToChoose":
        MessageLookupByLibrary.simpleMessage("Select a match result to choose which metadata fields to apply."),
    "componentsAppItemMatchManualMatchManualMatchEditorPaneSelectAllAvailableFields":
        MessageLookupByLibrary.simpleMessage("Select all available fields"),
    "componentsAppItemMatchManualMatchManualMatchFieldEditorAddValue": MessageLookupByLibrary.simpleMessage(
      "Add value",
    ),
    "componentsAppItemMatchManualMatchManualMatchFieldEditorCurrent": m38,
    "componentsAppItemMatchManualMatchManualMatchFieldEditorMode": MessageLookupByLibrary.simpleMessage("Mode:"),
    "componentsAppItemMatchManualMatchManualMatchFieldEditorNo": MessageLookupByLibrary.simpleMessage("No"),
    "componentsAppItemMatchManualMatchManualMatchFieldEditorYes": MessageLookupByLibrary.simpleMessage("Yes"),
    "componentsAppItemMatchManualMatchManualMatchProviderDropdownApply": MessageLookupByLibrary.simpleMessage("Apply"),
    "componentsAppItemMatchManualMatchManualMatchProviderDropdownCancel": MessageLookupByLibrary.simpleMessage(
      "Cancel",
    ),
    "componentsAppItemMatchManualMatchManualMatchProviderDropdownClose": MessageLookupByLibrary.simpleMessage("Close"),
    "componentsAppItemMatchManualMatchManualMatchProviderDropdownSelectProviders": MessageLookupByLibrary.simpleMessage(
      "Select providers",
    ),
    "componentsAppItemMatchManualMatchManualMatchResultsPaneMatchCandidates": MessageLookupByLibrary.simpleMessage(
      "Match candidates",
    ),
    "componentsAppItemMatchManualMatchManualMatchResultsPaneRunASearchToLoadMetadata":
        MessageLookupByLibrary.simpleMessage("Run a search to load metadata match results."),
    "componentsAppItemMatchManualMatchManualMatchSearchCardAuthor": MessageLookupByLibrary.simpleMessage("Author"),
    "componentsAppItemMatchManualMatchManualMatchSearchCardFailedToLoadProviders": MessageLookupByLibrary.simpleMessage(
      "Failed to load providers",
    ),
    "componentsAppItemMatchManualMatchManualMatchSearchCardLoading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "componentsAppItemMatchManualMatchManualMatchSearchCardNoProvidersAvailable": MessageLookupByLibrary.simpleMessage(
      "No providers available",
    ),
    "componentsAppItemMatchManualMatchManualMatchSearchCardProviders": MessageLookupByLibrary.simpleMessage(
      "Providers",
    ),
    "componentsAppItemMatchManualMatchManualMatchSearchCardSearchTitle": MessageLookupByLibrary.simpleMessage(
      "Search title",
    ),
    "componentsAppItemMatchManualMatchManualMatchSearchCardText": m39,
    "componentsAppItemMatchManualMatchManualMatchSearchCardTitle": MessageLookupByLibrary.simpleMessage("Title"),
    "componentsAppItemMatchQuickMatchOptionsDialogCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsAppItemMatchQuickMatchOptionsDialogCouldNotLoadMetadataProviders": m40,
    "componentsAppItemMatchQuickMatchOptionsDialogLoadingProviders": MessageLookupByLibrary.simpleMessage(
      "Loading providers...",
    ),
    "componentsAppItemMatchQuickMatchOptionsDialogNoMetadataProvidersAreAvailableFor":
        MessageLookupByLibrary.simpleMessage("No metadata providers are available for this media type."),
    "componentsAppItemMatchQuickMatchOptionsDialogOverwriteCoverImage": MessageLookupByLibrary.simpleMessage(
      "Overwrite cover image",
    ),
    "componentsAppItemMatchQuickMatchOptionsDialogOverwriteCurrentMetadata": MessageLookupByLibrary.simpleMessage(
      "Overwrite current metadata",
    ),
    "componentsAppItemMatchQuickMatchOptionsDialogProvider": MessageLookupByLibrary.simpleMessage("Provider"),
    "componentsAppItemMatchQuickMatchOptionsDialogReplaceCurrentCoverArtworkWhenA":
        MessageLookupByLibrary.simpleMessage("Replace current cover artwork when a match provides one."),
    "componentsAppItemMatchQuickMatchOptionsDialogReplaceExistingTitleAuthorDescriptionAnd":
        MessageLookupByLibrary.simpleMessage("Replace existing title, author, description, and related fields."),
    "componentsAppLibraryAuthorCleanupToolCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsAppLibraryAuthorCleanupToolClose": MessageLookupByLibrary.simpleMessage("Close"),
    "componentsAppLibraryAuthorCleanupToolCouldNotRemoveAuthorsWithoutBooks": m41,
    "componentsAppLibraryAuthorCleanupToolDelete": m42,
    "componentsAppLibraryAuthorCleanupToolNoAuthorsToRemove": MessageLookupByLibrary.simpleMessage(
      "No Authors To Remove",
    ),
    "componentsAppLibraryAuthorCleanupToolNoAuthorsWith0BooksWere": MessageLookupByLibrary.simpleMessage(
      "No authors with 0 books were found.",
    ),
    "componentsAppLibraryAuthorCleanupToolText": m43,
    "componentsAppLibraryAuthorCleanupToolTheseAuthorsHave0BooksAnd": MessageLookupByLibrary.simpleMessage(
      "These authors have 0 books and will be removed permanently:",
    ),
    "componentsAppLibraryAuthorCleanupToolYouAreOfflinePleaseReconnectAnd": MessageLookupByLibrary.simpleMessage(
      "You are offline. Please reconnect and try again.",
    ),
    "componentsAppLibraryAuthorDetailContentOpenSeries": MessageLookupByLibrary.simpleMessage("Open Series"),
    "componentsAppLibraryAuthorSortSheetClose": MessageLookupByLibrary.simpleMessage("Close"),
    "componentsAppLibraryAuthorSortSheetSortAuthors": MessageLookupByLibrary.simpleMessage("Sort Authors"),
    "componentsAppLibraryLibraryFilterSheetClear": MessageLookupByLibrary.simpleMessage("Clear"),
    "componentsAppLibraryLibraryFilterSheetClose": MessageLookupByLibrary.simpleMessage("Close"),
    "componentsAppLibraryLibraryFilterSheetLibraryFilters": MessageLookupByLibrary.simpleMessage("Library Filters"),
    "componentsAppLibraryLibraryFilterSheetNoFilterOptionsAreAvailableFor": MessageLookupByLibrary.simpleMessage(
      "No filter options are available for this library yet.",
    ),
    "componentsAppLibraryLibraryFilterSheetNoMatchingOptions": MessageLookupByLibrary.simpleMessage(
      "No matching options",
    ),
    "componentsAppLibraryLibraryFilterSheetOptionsCount": m44,
    "componentsAppLibraryLibraryFilterSheetSearchOptions": MessageLookupByLibrary.simpleMessage("Search options"),
    "componentsAppLibraryLibraryFilterSheetSelected": m45,
    "componentsAppLibraryLibraryMultiSelectActionsCouldNotQuickMatchSelectedBooks": m46,
    "componentsAppLibraryLibraryMultiSelectActionsNoAPISessionAvailable": MessageLookupByLibrary.simpleMessage(
      "No API session available.",
    ),
    "componentsAppLibraryLibraryMultiSelectHostAddToCollection": MessageLookupByLibrary.simpleMessage(
      "Add to collection",
    ),
    "componentsAppLibraryLibraryMultiSelectHostAddToPlaylist": MessageLookupByLibrary.simpleMessage("Add to playlist"),
    "componentsAppLibraryLibraryMultiSelectHostQuickMatchSelectedBooks": MessageLookupByLibrary.simpleMessage(
      "Quick match selected books",
    ),
    "componentsAppLibraryLibrarySortSheetClose": MessageLookupByLibrary.simpleMessage("Close"),
    "componentsAppLibraryLibrarySortSheetSortLibrary": MessageLookupByLibrary.simpleMessage("Sort Library"),
    "componentsAppLibraryLibraryTargetPickerSheetRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "componentsAppLibrarySwitcherSelectLibrary": MessageLookupByLibrary.simpleMessage("Select library"),
    "componentsAppTasksTaskNotificationPanelClearCompletedActivity": MessageLookupByLibrary.simpleMessage(
      "Clear completed activity",
    ),
    "componentsAppTasksTaskNotificationPanelNoTasksYet": MessageLookupByLibrary.simpleMessage("No tasks yet."),
    "componentsAppTasksTaskNotificationPanelTaskActivity": MessageLookupByLibrary.simpleMessage("Task Activity"),
    "componentsAppUploadLibraryUploadItemCardAcceptMetadataSuggestion": MessageLookupByLibrary.simpleMessage(
      "Accept metadata suggestion",
    ),
    "componentsAppUploadLibraryUploadItemCardFetchMetadata": MessageLookupByLibrary.simpleMessage("Fetch metadata"),
    "componentsAppUploadLibraryUploadItemCardFiles": m47,
    "componentsAppUploadLibraryUploadItemCardRejectMetadataSuggestion": MessageLookupByLibrary.simpleMessage(
      "Reject metadata suggestion",
    ),
    "componentsAppUploadLibraryUploadItemCardRemoveUploadItem": MessageLookupByLibrary.simpleMessage(
      "Remove upload item",
    ),
    "componentsAppUploadLibraryUploadItemCardSuggested": m48,
    "componentsAppUploadLibraryUploadItemCardText": m49,
    "componentsAppUploadLibraryUploadPanelAdvancedOptions": MessageLookupByLibrary.simpleMessage("Advanced options"),
    "componentsAppUploadLibraryUploadPanelApplyAuthor": MessageLookupByLibrary.simpleMessage("Apply author"),
    "componentsAppUploadLibraryUploadPanelApplySeries": MessageLookupByLibrary.simpleMessage("Apply series"),
    "componentsAppUploadLibraryUploadPanelBack": MessageLookupByLibrary.simpleMessage("Back"),
    "componentsAppUploadLibraryUploadPanelBulkUpdateQueueMetadata": MessageLookupByLibrary.simpleMessage(
      "Bulk update queue metadata",
    ),
    "componentsAppUploadLibraryUploadPanelCancelUpload": MessageLookupByLibrary.simpleMessage("Cancel upload"),
    "componentsAppUploadLibraryUploadPanelCancelUploads": MessageLookupByLibrary.simpleMessage("Cancel uploads"),
    "componentsAppUploadLibraryUploadPanelChooseFiles": MessageLookupByLibrary.simpleMessage("Choose files"),
    "componentsAppUploadLibraryUploadPanelChooseFolder": MessageLookupByLibrary.simpleMessage("Choose folder"),
    "componentsAppUploadLibraryUploadPanelClearQueue": MessageLookupByLibrary.simpleMessage("Clear queue"),
    "componentsAppUploadLibraryUploadPanelContinueAnyway": MessageLookupByLibrary.simpleMessage("Continue anyway"),
    "componentsAppUploadLibraryUploadPanelPathCheckIssuesFound": MessageLookupByLibrary.simpleMessage(
      "Path check issues found",
    ),
    "componentsAppUploadLibraryUploadPanelRequiresAdminRole": MessageLookupByLibrary.simpleMessage(
      "Requires admin role.",
    ),
    "componentsAppUploadLibraryUploadPanelSettings": MessageLookupByLibrary.simpleMessage("Settings"),
    "componentsAppUploadLibraryUploadPanelSomeItemsHaveDestinationConflictsOr": MessageLookupByLibrary.simpleMessage(
      "Some items have destination conflicts or path-check errors. Continue anyway?",
    ),
    "componentsAppUploadLibraryUploadPanelStartUpload": MessageLookupByLibrary.simpleMessage("Start upload"),
    "componentsAppUploadLibraryUploadPanelText": m50,
    "componentsAppUploadLibraryUploadPanelUploadQueueIsEmptyAddFiles": MessageLookupByLibrary.simpleMessage(
      "Upload queue is empty. Add files or folders using the drop area above.",
    ),
    "componentsAppUploadLibraryUploadPanelUploadTo": m51,
    "componentsAppUserSwitcherAddNewUser": MessageLookupByLibrary.simpleMessage("Add New User"),
    "componentsAppUserSwitcherAreYouSureYouWantTo": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to switch users? When you switch the user, the player will not be able to sync the progress. It will still be saved locally and sync with the server after an app restart.",
    ),
    "componentsAppUserSwitcherAvatarCheckingServerStatus": MessageLookupByLibrary.simpleMessage(
      "Checking server status",
    ),
    "componentsAppUserSwitcherAvatarServerConnectionProblems": MessageLookupByLibrary.simpleMessage(
      "Server connection problems",
    ),
    "componentsAppUserSwitcherAvatarServerReachable": MessageLookupByLibrary.simpleMessage("Server reachable"),
    "componentsAppUserSwitcherCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsAppUserSwitcherErrorLoadingCurrentUser": m52,
    "componentsAppUserSwitcherErrorLoadingUsers": m53,
    "componentsAppUserSwitcherSwitch": MessageLookupByLibrary.simpleMessage("Switch"),
    "componentsAppUserSwitcherSwitchOrAddUser": MessageLookupByLibrary.simpleMessage("Switch or Add User"),
    "componentsAppUserSwitcherSwitchUser": MessageLookupByLibrary.simpleMessage("Switch User"),
    "componentsCommonBookEditorSheetNoBooksSelected": MessageLookupByLibrary.simpleMessage("No books selected."),
    "componentsCommonBookEditorSheetNoMatchingBooksFound": MessageLookupByLibrary.simpleMessage(
      "No matching books found.",
    ),
    "componentsCommonBookEditorSheetSearchBooks": MessageLookupByLibrary.simpleMessage("Search books"),
    "componentsCommonBookEditorSheetSearchBooksToAdd": MessageLookupByLibrary.simpleMessage("Search books to add"),
    "componentsCommonBookEditorSheetSearchFailedPleaseTryAnotherQuery": MessageLookupByLibrary.simpleMessage(
      "Search failed. Please try another query.",
    ),
    "componentsCommonBookEditorSheetSelected": m54,
    "componentsCommonBookEditorSheetTitleAuthorOrSeries": MessageLookupByLibrary.simpleMessage(
      "Title, author, or series",
    ),
    "componentsCommonBookEditorSheetUnselectAll": MessageLookupByLibrary.simpleMessage("Unselect all"),
    "componentsCommonConnectionIssueViewNoServerConnectionAvailable": MessageLookupByLibrary.simpleMessage(
      "No server connection available",
    ),
    "componentsCommonConnectionIssueViewOpenDownloads": MessageLookupByLibrary.simpleMessage("Open Downloads"),
    "componentsCommonConnectionIssueViewRequiresActiveServerConnection": MessageLookupByLibrary.simpleMessage(
      "This section requires an active server connection. Reconnect and try again.",
    ),
    "componentsCommonConnectionIssueViewRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "componentsCommonConnectionIssueViewTryAgainAndCheckServerConnection": MessageLookupByLibrary.simpleMessage(
      "Please try again. If the issue persists, check your server connection.",
    ),
    "componentsCommonConnectionIssueViewUnableToLoadContent": MessageLookupByLibrary.simpleMessage(
      "Unable to load content",
    ),
    "componentsCommonCoverZoomViewClose": MessageLookupByLibrary.simpleMessage("Close"),
    "componentsCommonLibraryItemDeleteDialogCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsCommonLibraryItemDeleteDialogChooseDeletionMode": MessageLookupByLibrary.simpleMessage(
      "Choose deletion mode:",
    ),
    "componentsCommonLibraryItemDeleteDialogDeleteAudiobookQuestion": m55,
    "componentsCommonLibraryItemDeleteDialogDeleteWarning": m56,
    "componentsCommonLibraryItemDeleteDialogSelectedItemSAreNotAudiobooks": m57,
    "componentsCommonListEntityMissingViewBack": MessageLookupByLibrary.simpleMessage("Back"),
    "componentsCommonListManagementDialogsCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsCommonListManagementDialogsDescription": MessageLookupByLibrary.simpleMessage("Description"),
    "componentsCommonListManagementDialogsName": MessageLookupByLibrary.simpleMessage("Name"),
    "componentsCommonListManagementDialogsOptional": MessageLookupByLibrary.simpleMessage("Optional"),
    "componentsCommonListManagementHeaderCreate": MessageLookupByLibrary.simpleMessage("Create"),
    "componentsCommonManagedListOperationsNext": MessageLookupByLibrary.simpleMessage("Next"),
    "componentsCommonManagedListOperationsSave": MessageLookupByLibrary.simpleMessage("Save"),
    "componentsCommonMultiBookEntryWidgetText": m58,
    "componentsPlayerCommonBookmarksButtonBookmarks": MessageLookupByLibrary.simpleMessage("Bookmarks"),
    "componentsPlayerCommonBookmarksButtonNoActiveMediaToBookmark": MessageLookupByLibrary.simpleMessage(
      "No active media to bookmark.",
    ),
    "componentsPlayerCommonCastButtonCastDevices": MessageLookupByLibrary.simpleMessage("Cast Devices"),
    "componentsPlayerCommonCastButtonCastingLocalDownloadsRequiresAnActiveServerConnection":
        MessageLookupByLibrary.simpleMessage("Casting local downloads requires an active server connection."),
    "componentsPlayerCommonCastButtonCastingTo": m59,
    "componentsPlayerCommonCastButtonChromeCastIsUnavailableOnThisDevice": MessageLookupByLibrary.simpleMessage(
      "Chrome Cast is unavailable on this device.",
    ),
    "componentsPlayerCommonCastButtonChromeCastIsUnavailableOnThisPlatform": MessageLookupByLibrary.simpleMessage(
      "Chrome Cast is unavailable on this platform.",
    ),
    "componentsPlayerCommonCastButtonConnectToACastDevice": MessageLookupByLibrary.simpleMessage(
      "Connect to a cast device",
    ),
    "componentsPlayerCommonCastButtonConnected": MessageLookupByLibrary.simpleMessage("Connected"),
    "componentsPlayerCommonCastButtonCurrentTrackDoesNotHaveAPlayableUrl": MessageLookupByLibrary.simpleMessage(
      "Current track does not have a playable URL.",
    ),
    "componentsPlayerCommonCastButtonDisconnect": MessageLookupByLibrary.simpleMessage("Disconnect"),
    "componentsPlayerCommonCastButtonDisconnectedFromCastDevice": MessageLookupByLibrary.simpleMessage(
      "Disconnected from cast device.",
    ),
    "componentsPlayerCommonCastButtonFailedToCast": m60,
    "componentsPlayerCommonCastButtonFailedToDisconnect": m61,
    "componentsPlayerCommonCastButtonManageCastDevice": MessageLookupByLibrary.simpleMessage("Manage cast device"),
    "componentsPlayerCommonCastButtonNothingIsCurrentlyPlayingToCast": MessageLookupByLibrary.simpleMessage(
      "Nothing is currently playing to cast.",
    ),
    "componentsPlayerCommonCastButtonRetryCastSetup": MessageLookupByLibrary.simpleMessage("Retry Cast setup"),
    "componentsPlayerCommonCastButtonSearchingForCastDevices": MessageLookupByLibrary.simpleMessage(
      "Searching for cast devices...",
    ),
    "componentsPlayerCommonCastButtonUnableToConnectTo": m62,
    "componentsPlayerCommonCastButtonUnableToDetermineTheCurrentTrack": MessageLookupByLibrary.simpleMessage(
      "Unable to determine the current track.",
    ),
    "componentsPlayerCommonCastButtonUnableToPrepareServerStreamForThisItem": MessageLookupByLibrary.simpleMessage(
      "Unable to prepare a server stream for this item.",
    ),
    "componentsPlayerCommonCastButtonUnknownModel": MessageLookupByLibrary.simpleMessage("Unknown model"),
    "componentsPlayerCommonChapterTextNowPlaying": MessageLookupByLibrary.simpleMessage("Now playing"),
    "componentsPlayerCommonSleepTimerButtonCustomMinutes": MessageLookupByLibrary.simpleMessage("Custom minutes"),
    "componentsPlayerCommonSleepTimerButtonK5m": MessageLookupByLibrary.simpleMessage("+5m"),
    "componentsPlayerCommonSleepTimerButtonMinutes": MessageLookupByLibrary.simpleMessage("Minutes"),
    "componentsPlayerCommonSleepTimerButtonNotValid": MessageLookupByLibrary.simpleMessage("Not valid"),
    "componentsPlayerCommonSleepTimerButtonRemaining": m63,
    "componentsPlayerCommonSleepTimerButtonSleepTimer": MessageLookupByLibrary.simpleMessage("Sleep timer"),
    "componentsPlayerCommonSleepTimerButtonStart": MessageLookupByLibrary.simpleMessage("Start"),
    "componentsPlayerCommonSleepTimerButtonStop": MessageLookupByLibrary.simpleMessage("Stop"),
    "componentsPlayerCommonSpeedSliderApply": MessageLookupByLibrary.simpleMessage("Apply"),
    "componentsPlayerCommonSpeedSliderCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsPlayerCommonSpeedSliderCustomValue": MessageLookupByLibrary.simpleMessage("Custom value"),
    "componentsPlayerCommonSpeedSliderK0530": MessageLookupByLibrary.simpleMessage("0.5 - 3.0"),
    "componentsPlayerCommonSpeedSliderPlaybackSpeed": MessageLookupByLibrary.simpleMessage("Playback speed"),
    "componentsPlayerCommonSpeedSliderX": m64,
    "componentsPlayerCommonVolumeSliderPanelText": m65,
    "componentsPlayerCommonVolumeSliderPanelVolume": MessageLookupByLibrary.simpleMessage("Volume"),
    "componentsPlayerCommonVolumeSliderVolume": m66,
    "componentsSessionsCurrentUserListeningSessionsTabCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsSessionsCurrentUserListeningSessionsTabDelete": MessageLookupByLibrary.simpleMessage("Delete"),
    "componentsSessionsCurrentUserListeningSessionsTabDeleteSelected": MessageLookupByLibrary.simpleMessage(
      "Delete Selected",
    ),
    "componentsSessionsCurrentUserListeningSessionsTabDeleteSelectedSessionSThisCannot": m67,
    "componentsSessionsCurrentUserListeningSessionsTabDeleteSelectedSessions": MessageLookupByLibrary.simpleMessage(
      "Delete Selected Sessions",
    ),
    "componentsSessionsCurrentUserListeningSessionsTabDeletedSessionS": m68,
    "componentsSessionsCurrentUserListeningSessionsTabFailedToDeleteSessionSCheck": m69,
    "componentsSessionsCurrentUserListeningSessionsTabFailedToLoadUser": m70,
    "componentsSessionsCurrentUserListeningSessionsTabNoActiveUser": MessageLookupByLibrary.simpleMessage(
      "No active user.",
    ),
    "componentsSessionsCurrentUserListeningSessionsTabSelected": m71,
    "componentsSessionsLibraryItemListeningSessionsTabAllEpisodes": MessageLookupByLibrary.simpleMessage(
      "All Episodes",
    ),
    "componentsSessionsLibraryItemListeningSessionsTabCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsSessionsLibraryItemListeningSessionsTabDelete": MessageLookupByLibrary.simpleMessage("Delete"),
    "componentsSessionsLibraryItemListeningSessionsTabDeleteSelected": MessageLookupByLibrary.simpleMessage(
      "Delete Selected",
    ),
    "componentsSessionsLibraryItemListeningSessionsTabDeleteSelectedSessionSThisCannot": m72,
    "componentsSessionsLibraryItemListeningSessionsTabDeleteSelectedSessions": MessageLookupByLibrary.simpleMessage(
      "Delete Selected Sessions",
    ),
    "componentsSessionsLibraryItemListeningSessionsTabDeletedSessionS": m73,
    "componentsSessionsLibraryItemListeningSessionsTabFailedToDeleteSessionSCheck": m74,
    "componentsSessionsLibraryItemListeningSessionsTabFailedToLoadUser": m75,
    "componentsSessionsLibraryItemListeningSessionsTabFilterByEpisode": MessageLookupByLibrary.simpleMessage(
      "Filter by Episode",
    ),
    "componentsSessionsLibraryItemListeningSessionsTabNoActiveUser": MessageLookupByLibrary.simpleMessage(
      "No active user.",
    ),
    "componentsSessionsLibraryItemListeningSessionsTabSelected": m76,
    "componentsSessionsListeningSessionEditorDialogAuthor": MessageLookupByLibrary.simpleMessage("Author"),
    "componentsSessionsListeningSessionEditorDialogCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsSessionsListeningSessionEditorDialogClose": MessageLookupByLibrary.simpleMessage("Close"),
    "componentsSessionsListeningSessionEditorDialogCurrentPosition": MessageLookupByLibrary.simpleMessage(
      "Current Position",
    ),
    "componentsSessionsListeningSessionEditorDialogDate": MessageLookupByLibrary.simpleMessage("Date"),
    "componentsSessionsListeningSessionEditorDialogDelete": MessageLookupByLibrary.simpleMessage("Delete"),
    "componentsSessionsListeningSessionEditorDialogDeleteSession": MessageLookupByLibrary.simpleMessage(
      "Delete Session",
    ),
    "componentsSessionsListeningSessionEditorDialogDeleteThisSessionPermanentlyThisCannot":
        MessageLookupByLibrary.simpleMessage("Delete this session permanently? This cannot be undone."),
    "componentsSessionsListeningSessionEditorDialogDevice": MessageLookupByLibrary.simpleMessage("Device"),
    "componentsSessionsListeningSessionEditorDialogDirectPlay": MessageLookupByLibrary.simpleMessage("Direct Play"),
    "componentsSessionsListeningSessionEditorDialogDirectStream": MessageLookupByLibrary.simpleMessage("Direct Stream"),
    "componentsSessionsListeningSessionEditorDialogDuration": MessageLookupByLibrary.simpleMessage("Duration"),
    "componentsSessionsListeningSessionEditorDialogEnd": MessageLookupByLibrary.simpleMessage("End"),
    "componentsSessionsListeningSessionEditorDialogEpisodeId": MessageLookupByLibrary.simpleMessage("Episode ID"),
    "componentsSessionsListeningSessionEditorDialogFailedToDeleteListeningSession":
        MessageLookupByLibrary.simpleMessage("Failed to delete listening session."),
    "componentsSessionsListeningSessionEditorDialogFailedToDeleteListeningSessionError": m77,
    "componentsSessionsListeningSessionEditorDialogFailedToSaveListeningSessionChanges":
        MessageLookupByLibrary.simpleMessage("Failed to save listening session changes."),
    "componentsSessionsListeningSessionEditorDialogFailedToSaveListeningSessionChangesError": m78,
    "componentsSessionsListeningSessionEditorDialogItemId": MessageLookupByLibrary.simpleMessage("Item ID"),
    "componentsSessionsListeningSessionEditorDialogListened": MessageLookupByLibrary.simpleMessage("Listened"),
    "componentsSessionsListeningSessionEditorDialogPlayMethod": MessageLookupByLibrary.simpleMessage("Play Method"),
    "componentsSessionsListeningSessionEditorDialogPlayer": MessageLookupByLibrary.simpleMessage("Player"),
    "componentsSessionsListeningSessionEditorDialogSave": MessageLookupByLibrary.simpleMessage("Save"),
    "componentsSessionsListeningSessionEditorDialogServerVersion": MessageLookupByLibrary.simpleMessage(
      "Server Version",
    ),
    "componentsSessionsListeningSessionEditorDialogSessionId": MessageLookupByLibrary.simpleMessage("Session ID"),
    "componentsSessionsListeningSessionEditorDialogStart": MessageLookupByLibrary.simpleMessage("Start"),
    "componentsSessionsListeningSessionEditorDialogStartEndAndListenedTimeMustBeNonNegative":
        MessageLookupByLibrary.simpleMessage("Start, end and listened time must be non-negative."),
    "componentsSessionsListeningSessionEditorDialogStartPosition": MessageLookupByLibrary.simpleMessage(
      "Start Position",
    ),
    "componentsSessionsListeningSessionEditorDialogStarted": MessageLookupByLibrary.simpleMessage("Started"),
    "componentsSessionsListeningSessionEditorDialogTimeListened": MessageLookupByLibrary.simpleMessage("Time Listened"),
    "componentsSessionsListeningSessionEditorDialogTranscode": MessageLookupByLibrary.simpleMessage("Transcode"),
    "componentsSessionsListeningSessionEditorDialogUnknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "componentsSessionsListeningSessionEditorDialogUpdated": MessageLookupByLibrary.simpleMessage("Updated"),
    "componentsSessionsListeningSessionEditorDialogUser": MessageLookupByLibrary.simpleMessage("User"),
    "componentsSessionsListeningSessionEditorDialogUserId": MessageLookupByLibrary.simpleMessage("User ID"),
    "componentsSessionsListeningSessionsPaginationControlsNextPage": MessageLookupByLibrary.simpleMessage("Next page"),
    "componentsSessionsListeningSessionsPaginationControlsPage": m79,
    "componentsSessionsListeningSessionsPaginationControlsPerPage": MessageLookupByLibrary.simpleMessage("Per page:"),
    "componentsSessionsListeningSessionsPaginationControlsPreviousPage": MessageLookupByLibrary.simpleMessage(
      "Previous page",
    ),
    "componentsSessionsListeningSessionsPaginationControlsTotal": m80,
    "componentsSessionsOpenShareSessionDialogCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsSessionsOpenShareSessionDialogClose": MessageLookupByLibrary.simpleMessage("Close"),
    "componentsSessionsOpenShareSessionDialogDelete": MessageLookupByLibrary.simpleMessage("Delete"),
    "componentsSessionsOpenShareSessionDialogDeleteSharedSession": MessageLookupByLibrary.simpleMessage(
      "Delete Shared Session",
    ),
    "componentsSessionsOpenShareSessionDialogDeleteThisSharedSessionPermanentlyThis":
        MessageLookupByLibrary.simpleMessage("Delete this shared session permanently? This cannot be undone."),
    "componentsSessionsOpenShareSessionDialogSharedSession": MessageLookupByLibrary.simpleMessage("Shared Session"),
    "componentsSessionsSessionDurationPickerFieldCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsSessionsSessionDurationPickerFieldHours": MessageLookupByLibrary.simpleMessage("Hours"),
    "componentsSessionsSessionDurationPickerFieldMinutes": MessageLookupByLibrary.simpleMessage("Minutes"),
    "componentsSessionsSessionDurationPickerFieldSeconds": MessageLookupByLibrary.simpleMessage("Seconds"),
    "componentsSessionsSessionDurationPickerFieldSet": MessageLookupByLibrary.simpleMessage("Set"),
    "componentsSettingsAdminCustomMetadataProviderManagerAdd": MessageLookupByLibrary.simpleMessage("Add"),
    "componentsSettingsAdminCustomMetadataProviderManagerAddedProvider": m81,
    "componentsSettingsAdminCustomMetadataProviderManagerAuthHeaderConfigured": MessageLookupByLibrary.simpleMessage(
      "Auth header configured",
    ),
    "componentsSettingsAdminCustomMetadataProviderManagerAuthHeaderValue": MessageLookupByLibrary.simpleMessage(
      "Auth Header Value",
    ),
    "componentsSettingsAdminCustomMetadataProviderManagerCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsSettingsAdminCustomMetadataProviderManagerDeleteProvider": MessageLookupByLibrary.simpleMessage(
      "Delete provider",
    ),
    "componentsSettingsAdminCustomMetadataProviderManagerDeletedProvider": m82,
    "componentsSettingsAdminCustomMetadataProviderManagerEditProvider": MessageLookupByLibrary.simpleMessage(
      "Edit provider",
    ),
    "componentsSettingsAdminCustomMetadataProviderManagerHttpsExampleComPath": MessageLookupByLibrary.simpleMessage(
      "https://example.com/path",
    ),
    "componentsSettingsAdminCustomMetadataProviderManagerName": MessageLookupByLibrary.simpleMessage("Name"),
    "componentsSettingsAdminCustomMetadataProviderManagerNoCustomMetadataProvidersFound":
        MessageLookupByLibrary.simpleMessage("No custom metadata providers found."),
    "componentsSettingsAdminCustomMetadataProviderManagerOptional": MessageLookupByLibrary.simpleMessage("Optional"),
    "componentsSettingsAdminCustomMetadataProviderManagerRefreshProviders": MessageLookupByLibrary.simpleMessage(
      "Refresh providers",
    ),
    "componentsSettingsAdminCustomMetadataProviderManagerUpdatedProvider": m83,
    "componentsSettingsAdminCustomMetadataProviderManagerUrl": MessageLookupByLibrary.simpleMessage("URL"),
    "componentsSettingsAdminForceMetadataRefreshToolCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsSettingsAdminForceMetadataRefreshToolForceMetadataRefresh": MessageLookupByLibrary.simpleMessage(
      "Force metadata refresh",
    ),
    "componentsSettingsAdminForceMetadataRefreshToolForceMetadataRefresh2": MessageLookupByLibrary.simpleMessage(
      "Force Metadata Refresh",
    ),
    "componentsSettingsAdminForceMetadataRefreshToolNoActiveAPIClient": MessageLookupByLibrary.simpleMessage(
      "No active API client.",
    ),
    "componentsSettingsAdminForceMetadataRefreshToolRecreatesTheMetadataJsonFilesFor":
        MessageLookupByLibrary.simpleMessage("Recreates the metadata.json files for all items"),
    "componentsSettingsAdminForceMetadataRefreshToolRun": MessageLookupByLibrary.simpleMessage("Run"),
    "componentsSettingsAdminForceMetadataRefreshToolThisToolAppendsTheForceMetadata": MessageLookupByLibrary.simpleMessage(
      "This tool appends the \"force-metadata\" tag to every item in the selected libraries, performs a batch update, then removes the tag via the remove endpoint.",
    ),
    "componentsSettingsAdminItemMetadataUtilsViewFailedToLoadUserData": m84,
    "componentsSettingsAdminItemMetadataUtilsViewNoActiveUserSignInTo": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in to manage item metadata utilities.",
    ),
    "componentsSettingsAdminItemMetadataUtilsViewRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "componentsSettingsAdminItemMetadataUtilsViewThisPageRequiresAnAdminAccount": MessageLookupByLibrary.simpleMessage(
      "This page requires an admin account.",
    ),
    "componentsSettingsAdminLibraryStatsRankedSectionText": m85,
    "componentsSettingsAdminMetadataTermManagerCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsSettingsAdminMetadataTermManagerDelete": m86,
    "componentsSettingsAdminMetadataTermManagerName": MessageLookupByLibrary.simpleMessage("Name"),
    "componentsSettingsAdminMetadataTermManagerRefreshS": m87,
    "componentsSettingsAdminMetadataTermManagerRename": m88,
    "componentsSettingsAdminMetadataTermManagerSave": MessageLookupByLibrary.simpleMessage("Save"),
    "componentsSettingsAdminMetadataTermManagerUpdatedItemS": m89,
    "componentsSettingsAdminMetadataTermManagerUpdatedItemS2": m90,
    "componentsSettingsAdminServerLibraryStatsViewFailedToLoadUserData": m91,
    "componentsSettingsAdminServerLibraryStatsViewNoActiveUserSignInTo": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in to view library stats.",
    ),
    "componentsSettingsAdminServerLibraryStatsViewNoStatsAvailableForTheSelected": MessageLookupByLibrary.simpleMessage(
      "No stats available for the selected library.",
    ),
    "componentsSettingsAdminServerLibraryStatsViewRefreshStats": MessageLookupByLibrary.simpleMessage("Refresh stats"),
    "componentsSettingsAdminServerLibraryStatsViewRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "componentsSettingsAdminServerLibraryStatsViewSelectALibraryFromTheMain": MessageLookupByLibrary.simpleMessage(
      "Select a library from the main view to inspect its stats.",
    ),
    "componentsSettingsAdminServerLibraryStatsViewThisPageRequiresAnAdminAccount": MessageLookupByLibrary.simpleMessage(
      "This page requires an admin account.",
    ),
    "componentsSettingsAdminServerLogsViewAutoScroll": MessageLookupByLibrary.simpleMessage("Auto-scroll"),
    "componentsSettingsAdminServerLogsViewFailedToLoadUserData": m92,
    "componentsSettingsAdminServerLogsViewNoActiveUserSignInTo": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in to view server logs.",
    ),
    "componentsSettingsAdminServerLogsViewNoLogsFoundForTheCurrent": MessageLookupByLibrary.simpleMessage(
      "No logs found for the current search.",
    ),
    "componentsSettingsAdminServerLogsViewSearchLogs": MessageLookupByLibrary.simpleMessage("Search logs"),
    "componentsSettingsAdminServerLogsViewServerLogLevel": MessageLookupByLibrary.simpleMessage("Server Log Level"),
    "componentsSettingsAdminServerLogsViewThisPageRequiresAnAdminAccount": MessageLookupByLibrary.simpleMessage(
      "This page requires an admin account.",
    ),
    "componentsSettingsAdminServerSessionsViewAllUsers": MessageLookupByLibrary.simpleMessage("All Users"),
    "componentsSettingsAdminServerSessionsViewCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsSettingsAdminServerSessionsViewDelete": MessageLookupByLibrary.simpleMessage("Delete"),
    "componentsSettingsAdminServerSessionsViewDeleteSelected": MessageLookupByLibrary.simpleMessage("Delete Selected"),
    "componentsSettingsAdminServerSessionsViewDeleteSelectedSessionSThisCannot": m93,
    "componentsSettingsAdminServerSessionsViewDeleteSelectedSessions": MessageLookupByLibrary.simpleMessage(
      "Delete Selected Sessions",
    ),
    "componentsSettingsAdminServerSessionsViewDeletedSessionS": m94,
    "componentsSettingsAdminServerSessionsViewFailedToDeleteSessionSCheck": m95,
    "componentsSettingsAdminServerSessionsViewFailedToLoadUserData": m96,
    "componentsSettingsAdminServerSessionsViewFilterByUser": MessageLookupByLibrary.simpleMessage("Filter by User"),
    "componentsSettingsAdminServerSessionsViewNoActiveUserSignInTo": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in to manage sessions.",
    ),
    "componentsSettingsAdminServerSessionsViewNoSharedSessionsFound": MessageLookupByLibrary.simpleMessage(
      "No shared sessions found.",
    ),
    "componentsSettingsAdminServerSessionsViewRefreshSessions": MessageLookupByLibrary.simpleMessage(
      "Refresh sessions",
    ),
    "componentsSettingsAdminServerSessionsViewRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "componentsSettingsAdminServerSessionsViewSelected": m97,
    "componentsSettingsAdminServerSessionsViewThisPageRequiresAnAdminAccount": MessageLookupByLibrary.simpleMessage(
      "This page requires an admin account.",
    ),
    "componentsSettingsAdminServerUsersViewAddUser": MessageLookupByLibrary.simpleMessage("Add user"),
    "componentsSettingsAdminServerUsersViewCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsSettingsAdminServerUsersViewDelete": MessageLookupByLibrary.simpleMessage("Delete"),
    "componentsSettingsAdminServerUsersViewDeleteUser": MessageLookupByLibrary.simpleMessage("Delete User"),
    "componentsSettingsAdminServerUsersViewDeleteUserThisCannotBeUndone": m98,
    "componentsSettingsAdminServerUsersViewFailedToLoadUserData": m99,
    "componentsSettingsAdminServerUsersViewNoActiveUserSignInTo": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in to manage users.",
    ),
    "componentsSettingsAdminServerUsersViewRefresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "componentsSettingsAdminServerUsersViewRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "componentsSettingsAdminServerUsersViewSearchUsers": MessageLookupByLibrary.simpleMessage("Search users"),
    "componentsSettingsAdminServerUsersViewThisPageRequiresAnAdminAccount": MessageLookupByLibrary.simpleMessage(
      "This page requires an admin account.",
    ),
    "componentsSettingsAdminSplitMetadataTermsToolCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsSettingsAdminSplitMetadataTermsToolDelimiter": MessageLookupByLibrary.simpleMessage("Delimiter"),
    "componentsSettingsAdminSplitMetadataTermsToolExampleSplitsFantasySciFiInto": MessageLookupByLibrary.simpleMessage(
      "Example: \",\" splits \"Fantasy, Sci-Fi\" into two values.",
    ),
    "componentsSettingsAdminSplitMetadataTermsToolNoActiveAPIClient": MessageLookupByLibrary.simpleMessage(
      "No active API client.",
    ),
    "componentsSettingsAdminSplitMetadataTermsToolThisToolSplitsCombinedValuesUsing": m100,
    "componentsSettingsAdminToolLibrarySelectorClearAll": MessageLookupByLibrary.simpleMessage("Clear all"),
    "componentsSettingsAdminToolLibrarySelectorNoLibrariesAvailable": MessageLookupByLibrary.simpleMessage(
      "No libraries available.",
    ),
    "componentsSettingsAdminToolLibrarySelectorSelectAll": MessageLookupByLibrary.simpleMessage("Select all"),
    "componentsSettingsAdminToolLibrarySelectorTargetLibraries": MessageLookupByLibrary.simpleMessage(
      "Target libraries",
    ),
    "componentsSettingsAdminToolLibrarySelectorText": m101,
    "componentsSettingsAdminUsersAdminUserFormDialogAccount": MessageLookupByLibrary.simpleMessage("Account"),
    "componentsSettingsAdminUsersAdminUserFormDialogAccountType": MessageLookupByLibrary.simpleMessage("Account type"),
    "componentsSettingsAdminUsersAdminUserFormDialogCanAccessAllLibraries": MessageLookupByLibrary.simpleMessage(
      "Can access all libraries",
    ),
    "componentsSettingsAdminUsersAdminUserFormDialogCanAccessAllTags": MessageLookupByLibrary.simpleMessage(
      "Can access all tags",
    ),
    "componentsSettingsAdminUsersAdminUserFormDialogCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "componentsSettingsAdminUsersAdminUserFormDialogClose": MessageLookupByLibrary.simpleMessage("Close"),
    "componentsSettingsAdminUsersAdminUserFormDialogEmail": MessageLookupByLibrary.simpleMessage("Email"),
    "componentsSettingsAdminUsersAdminUserFormDialogInvertSelectedTags": MessageLookupByLibrary.simpleMessage(
      "Invert selected tags",
    ),
    "componentsSettingsAdminUsersAdminUserFormDialogLibraryAndTagAccess": MessageLookupByLibrary.simpleMessage(
      "Library and Tag Access",
    ),
    "componentsSettingsAdminUsersAdminUserFormDialogUnlinkOpenID": MessageLookupByLibrary.simpleMessage(
      "Unlink OpenID",
    ),
    "componentsSettingsAdminUsersAdminUserFormDialogUserIsActive": MessageLookupByLibrary.simpleMessage(
      "User is active",
    ),
    "componentsSettingsAdminUsersAdminUserFormDialogUsername": MessageLookupByLibrary.simpleMessage("Username"),
    "componentsSettingsAdminUsersAdminUserFormDialogWhenEnabledSelectedTagsAreBlocked":
        MessageLookupByLibrary.simpleMessage("When enabled, selected tags are blocked instead of allowed."),
    "componentsSettingsAdminUsersAdminUserListTileActive": MessageLookupByLibrary.simpleMessage("ACTIVE"),
    "componentsSettingsAdminUsersAdminUserListTileCreated": m102,
    "componentsSettingsAdminUsersAdminUserListTileDelete": MessageLookupByLibrary.simpleMessage("Delete"),
    "componentsSettingsAdminUsersAdminUserListTileDeleteUser": MessageLookupByLibrary.simpleMessage("Delete user"),
    "componentsSettingsAdminUsersAdminUserListTileDisable": MessageLookupByLibrary.simpleMessage("Disable"),
    "componentsSettingsAdminUsersAdminUserListTileDisableUser": MessageLookupByLibrary.simpleMessage("Disable user"),
    "componentsSettingsAdminUsersAdminUserListTileDisabled": MessageLookupByLibrary.simpleMessage("DISABLED"),
    "componentsSettingsAdminUsersAdminUserListTileEdit": MessageLookupByLibrary.simpleMessage("Edit"),
    "componentsSettingsAdminUsersAdminUserListTileEditUser": MessageLookupByLibrary.simpleMessage("Edit user"),
    "componentsSettingsAdminUsersAdminUserListTileEnable": MessageLookupByLibrary.simpleMessage("Enable"),
    "componentsSettingsAdminUsersAdminUserListTileEnableUser": MessageLookupByLibrary.simpleMessage("Enable user"),
    "componentsSettingsAdminUsersAdminUserListTileLastSeen": m103,
    "componentsSettingsAdminUsersAdminUserListTileNoEmail": MessageLookupByLibrary.simpleMessage("No email"),
    "componentsSettingsAdminUsersAdminUserListTileOpenId": MessageLookupByLibrary.simpleMessage("OPENID"),
    "componentsSettingsAdminUsersAdminUserListTileUnknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "componentsSettingsAdminUsersAdminUserListTileUnlinkOpenID": MessageLookupByLibrary.simpleMessage("Unlink OpenID"),
    "componentsSettingsAdminUsersAdminUserMultiSelectCardClearAll": MessageLookupByLibrary.simpleMessage("Clear all"),
    "componentsSettingsAdminUsersAdminUserMultiSelectCardSelectAll": MessageLookupByLibrary.simpleMessage("Select all"),
    "componentsSettingsAdminUsersAdminUserMultiSelectCardText": m104,
    "componentsSettingsAdminUsersAdminUserPermissionsEditorCanAccessExplicitContent":
        MessageLookupByLibrary.simpleMessage("Can access explicit content"),
    "componentsSettingsAdminUsersAdminUserPermissionsEditorCanCreateEreaderDevices":
        MessageLookupByLibrary.simpleMessage("Can create eReader devices"),
    "componentsSettingsAdminUsersAdminUserPermissionsEditorCanDelete": MessageLookupByLibrary.simpleMessage(
      "Can delete",
    ),
    "componentsSettingsAdminUsersAdminUserPermissionsEditorCanDownload": MessageLookupByLibrary.simpleMessage(
      "Can download",
    ),
    "componentsSettingsAdminUsersAdminUserPermissionsEditorCanUpdate": MessageLookupByLibrary.simpleMessage(
      "Can update",
    ),
    "componentsSettingsAdminUsersAdminUserPermissionsEditorCanUpload": MessageLookupByLibrary.simpleMessage(
      "Can upload",
    ),
    "componentsSettingsAdminUsersAdminUserPermissionsEditorPermissions": MessageLookupByLibrary.simpleMessage(
      "Permissions",
    ),
    "componentsSettingsManagementSettingsSectionAdminServerSettings": MessageLookupByLibrary.simpleMessage(
      "Admin Server Settings",
    ),
    "componentsSettingsManagementSettingsSectionManagement": MessageLookupByLibrary.simpleMessage("Management"),
    "componentsSettingsManagementSettingsSectionTools": MessageLookupByLibrary.simpleMessage("Tools"),
    "componentsSettingsServerManagementUploadModeButtonEnableUploadItemsFirst": MessageLookupByLibrary.simpleMessage(
      "Enable \"Upload items\" first.",
    ),
    "componentsSettingsServerManagementUploadModeButtonOpen": MessageLookupByLibrary.simpleMessage("Open"),
    "componentsSettingsServerManagementUploadModeButtonOpenUpload": MessageLookupByLibrary.simpleMessage("Open upload"),
    "componentsSettingsServerManagementUploadModeButtonRequiresUploadPermission": MessageLookupByLibrary.simpleMessage(
      "Requires upload permission.",
    ),
    "componentsSettingsServerManagementUploadModeButtonSelectLibraryBeforeOpeningUploadMode":
        MessageLookupByLibrary.simpleMessage("Select a library before opening upload mode."),
    "componentsSettingsServerManagementUploadModeButtonUploadModeRequiresUploadPermissionAndEnabledUploadActions":
        MessageLookupByLibrary.simpleMessage("Upload mode requires upload permission and enabled upload actions."),
    "downloadDeleteFailedSuffix": m105,
    "downloadStatusFilesRemaining": m106,
    "downloadsDeleteConfirmTarget": m107,
    "downloadsDeleteSummary": m108,
    "downloadsDownloadedItemsCount": m109,
    "downloadsSelectedCount": m110,
    "downloadsUnableToLoad": MessageLookupByLibrary.simpleMessage("Unable to load downloads"),
    "itemDeleteBulkDeletedFromAbs": m111,
    "itemDeleteBulkDeletedFromAbsAndFileSystem": m112,
    "itemDeleteCouldNotDeleteAudiobook": MessageLookupByLibrary.simpleMessage("Could not delete audiobook."),
    "itemDeleteCouldNotDeleteSelectedAudiobooks": MessageLookupByLibrary.simpleMessage(
      "Could not delete selected audiobooks.",
    ),
    "itemDeleteDeletedTitleFromAbs": m113,
    "itemDeleteDeletedTitleFromAbsAndFileSystem": m114,
    "itemProgressCouldNotMarkEpisodeAs": m115,
    "itemProgressCouldNotMarkItemAs": m116,
    "itemProgressCouldNotMarkSelectedItemsAs": m117,
    "itemProgressMarkedEpisodeAs": m118,
    "itemProgressMarkedItemAs": m119,
    "itemProgressMarkedSelectedItemsAs": m120,
    "layoutHomeCollapseSidebar": MessageLookupByLibrary.simpleMessage("Collapse sidebar"),
    "layoutHomeExpandSidebar": MessageLookupByLibrary.simpleMessage("Expand sidebar"),
    "layoutHomeSelectedCount": m121,
    "libraryItemEncoderChannelDisplay": m122,
    "libraryItemWidgetBooksInSeries": m123,
    "libraryMultiSelectAddToCollectionTitle": MessageLookupByLibrary.simpleMessage("Add to collection"),
    "libraryMultiSelectAddToPlaylistTitle": MessageLookupByLibrary.simpleMessage("Add to playlist"),
    "libraryMultiSelectAddedBooksToCollection": m124,
    "libraryMultiSelectAddedBooksToPlaylist": m125,
    "libraryMultiSelectCouldNotAddBooksToCollection": MessageLookupByLibrary.simpleMessage(
      "Could not add books to collection.",
    ),
    "libraryMultiSelectCouldNotAddBooksToPlaylist": MessageLookupByLibrary.simpleMessage(
      "Could not add books to playlist.",
    ),
    "libraryMultiSelectCouldNotLoadCollections": MessageLookupByLibrary.simpleMessage("Could not load collections."),
    "libraryMultiSelectCouldNotLoadPlaylists": MessageLookupByLibrary.simpleMessage("Could not load playlists."),
    "libraryMultiSelectMetadataChangeCompleted": MessageLookupByLibrary.simpleMessage(
      "Metadata change request completed.",
    ),
    "libraryMultiSelectMetadataChangeCompletedWithUpdates": m126,
    "libraryMultiSelectMetadataChangeRequestSent": MessageLookupByLibrary.simpleMessage(
      "Metadata change request sent.",
    ),
    "libraryMultiSelectMetadataChangeRequestSentForBooks": m127,
    "libraryMultiSelectNoCollectionsFound": MessageLookupByLibrary.simpleMessage("No collections found."),
    "libraryMultiSelectNoEditablePlaylistsFound": MessageLookupByLibrary.simpleMessage("No editable playlists found."),
    "libraryMultiSelectQuickMatchRunFor": m128,
    "libraryMultiSelectQuickMatchSelectedBooksDescription": MessageLookupByLibrary.simpleMessage(
      "Pick a provider and choose whether cover/details should overwrite current metadata.",
    ),
    "libraryMultiSelectQuickMatchSelectedBooksTitle": MessageLookupByLibrary.simpleMessage(
      "Quick match selected books",
    ),
    "libraryUploadPanelAddedUploadItems": m129,
    "libraryUploadPanelUploadAttemptMessage": m130,
    "manualMatchCollapsedAuthorSummary": m131,
    "manualMatchCollapsedProvidersCount": m132,
    "manualMatchCollapsedTapToEditFilters": MessageLookupByLibrary.simpleMessage("Tap to edit search filters"),
    "manualMatchCollapsedTitleSummary": m133,
    "manualMatchResultsCount": m134,
    "manualMatchResultsNoResultsYet": MessageLookupByLibrary.simpleMessage("No results yet"),
    "playerBookmarksSheetAddingBookmark": MessageLookupByLibrary.simpleMessage("Adding bookmark..."),
    "playerBookmarksSheetCreateBookmark": MessageLookupByLibrary.simpleMessage("Create bookmark"),
    "playerBookmarksSheetCurrentPosition": m135,
    "playerBookmarksSheetUntitledBookmark": MessageLookupByLibrary.simpleMessage("Untitled bookmark"),
    "playlistDetailMissingEntriesMessage": m136,
    "readerEpubAnnotationsBookmarks": MessageLookupByLibrary.simpleMessage("Bookmarks"),
    "readerEpubAnnotationsCfi": m137,
    "readerEpubAnnotationsHighlights": MessageLookupByLibrary.simpleMessage("Highlights"),
    "readerEpubAnnotationsTypeHighlight": MessageLookupByLibrary.simpleMessage("Highlight"),
    "readerEpubAnnotationsTypeUnderline": MessageLookupByLibrary.simpleMessage("Underline"),
    "readerEpubAnnotationsUnderlines": MessageLookupByLibrary.simpleMessage("Underlines"),
    "readerEpubAnnotationsUntitledBookmark": MessageLookupByLibrary.simpleMessage("Untitled bookmark"),
    "screensAuthSignInBack": MessageLookupByLibrary.simpleMessage("Back"),
    "screensAuthSignInHttpsYourAudiobookshelfExample": MessageLookupByLibrary.simpleMessage(
      "https://your-audiobookshelf.example",
    ),
    "screensAuthSignInOpenidFlowOpenedInYourBrowser": MessageLookupByLibrary.simpleMessage(
      "OpenID flow opened in your browser. Finish sign-in there and return to the app.",
    ),
    "screensAuthSignInServerAddress": MessageLookupByLibrary.simpleMessage("Server Address"),
    "screensAuthSignInSignInToYourAudiobookshelfServer": MessageLookupByLibrary.simpleMessage(
      "Sign in to your Audiobookshelf server",
    ),
    "screensAuthSignInYaabsa": MessageLookupByLibrary.simpleMessage("Yaabsa"),
    "screensAuthWidgetsSignInAdvancedOptionsAddHeader": MessageLookupByLibrary.simpleMessage("Add Header"),
    "screensAuthWidgetsSignInAdvancedOptionsAdvancedOptions": MessageLookupByLibrary.simpleMessage("Advanced Options"),
    "screensAuthWidgetsSignInAdvancedOptionsAuthenticateWithAGeneratedAPIKey": MessageLookupByLibrary.simpleMessage(
      "Authenticate with a generated API key instead of username/password.",
    ),
    "screensAuthWidgetsSignInAdvancedOptionsCustomHeaders": MessageLookupByLibrary.simpleMessage("Custom Headers"),
    "screensAuthWidgetsSignInAdvancedOptionsEditHeader": MessageLookupByLibrary.simpleMessage("Edit header"),
    "screensAuthWidgetsSignInAdvancedOptionsNoCustomHeadersConfigured": MessageLookupByLibrary.simpleMessage(
      "No custom headers configured.",
    ),
    "screensAuthWidgetsSignInAdvancedOptionsRemoveHeader": MessageLookupByLibrary.simpleMessage("Remove header"),
    "screensAuthWidgetsSignInAdvancedOptionsUseAPIKey": MessageLookupByLibrary.simpleMessage("Use API Key"),
    "screensAuthWidgetsSignInAuthSectionApiKey": MessageLookupByLibrary.simpleMessage("API Key"),
    "screensAuthWidgetsSignInAuthSectionNoSupportedAuthenticationMethodIsEnabled": MessageLookupByLibrary.simpleMessage(
      "No supported authentication method is enabled on this server.",
    ),
    "screensAuthWidgetsSignInAuthSectionPassword": MessageLookupByLibrary.simpleMessage("Password"),
    "screensAuthWidgetsSignInAuthSectionUsername": MessageLookupByLibrary.simpleMessage("Username"),
    "screensAuthWidgetsSignInErrorPanelCopied": MessageLookupByLibrary.simpleMessage("Copied"),
    "screensAuthWidgetsSignInHeaderEditorDialogAHeaderWithThisNameAlreadyExists": MessageLookupByLibrary.simpleMessage(
      "A header with this name already exists.",
    ),
    "screensAuthWidgetsSignInHeaderEditorDialogCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "screensAuthWidgetsSignInHeaderEditorDialogHeaderName": MessageLookupByLibrary.simpleMessage("Header Name"),
    "screensAuthWidgetsSignInHeaderEditorDialogHeaderNameAndValueAreRequired": MessageLookupByLibrary.simpleMessage(
      "Header name and value are required.",
    ),
    "screensAuthWidgetsSignInHeaderEditorDialogHeaderValue": MessageLookupByLibrary.simpleMessage("Header Value"),
    "screensAuthWidgetsSignInHeaderEditorDialogSave": MessageLookupByLibrary.simpleMessage("Save"),
    "screensAuthWidgetsSignInServerStatusCheckingServer": MessageLookupByLibrary.simpleMessage("Checking server..."),
    "screensAutomotiveAaosSettingsScaffoldBack": MessageLookupByLibrary.simpleMessage("Back"),
    "screensAutomotiveAaosSettingsScaffoldRefresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "screensAutomotiveParkedExperienceCarMediaApp": MessageLookupByLibrary.simpleMessage("Car Media App"),
    "screensAutomotiveParkedExperienceLogout": MessageLookupByLibrary.simpleMessage("Logout"),
    "screensAutomotiveParkedExperienceOpenMediaCenter": MessageLookupByLibrary.simpleMessage("Open Media Center"),
    "screensAutomotiveParkedExperienceSettings": MessageLookupByLibrary.simpleMessage("Settings"),
    "screensItemLibraryItemBookViewCouldNotDeleteDownload": m138,
    "screensItemLibraryItemBookViewCouldNotStartDownload": m139,
    "screensItemLibraryItemBookViewDeletedFileS": m140,
    "screensItemLibraryItemBookViewDownloadAddedToQueue": MessageLookupByLibrary.simpleMessage(
      "Download added to queue.",
    ),
    "screensItemLibraryItemPodcastViewCouldNotDeleteDownload": m141,
    "screensItemLibraryItemPodcastViewCouldNotStartDownload": m142,
    "screensItemLibraryItemPodcastViewDeletedFileS": m143,
    "screensItemLibraryItemPodcastViewDownloadAddedToQueue": MessageLookupByLibrary.simpleMessage(
      "Download added to queue.",
    ),
    "screensItemLibraryItemPodcastViewNoEpisodesMatchTheCurrentSearch": MessageLookupByLibrary.simpleMessage(
      "No episodes match the current search/filter settings.",
    ),
    "screensItemLibraryItemPodcastViewPodcastMetadataIsUnavailable": MessageLookupByLibrary.simpleMessage(
      "Podcast metadata is unavailable.",
    ),
    "screensItemLibraryItemViewUnableToLoadItem": MessageLookupByLibrary.simpleMessage("Unable to load item"),
    "screensItemPodcastPodcastEpisodeDetailsClose": MessageLookupByLibrary.simpleMessage("Close"),
    "screensItemPodcastPodcastEpisodeDetailsCouldNotDeleteDownload": m144,
    "screensItemPodcastPodcastEpisodeDetailsCouldNotStartDownload": m145,
    "screensItemPodcastPodcastEpisodeDetailsDeleteDownload": MessageLookupByLibrary.simpleMessage("Delete download"),
    "screensItemPodcastPodcastEpisodeDetailsDeletedFileS": m146,
    "screensItemPodcastPodcastEpisodeDetailsDescription": MessageLookupByLibrary.simpleMessage("Description"),
    "screensItemPodcastPodcastEpisodeDetailsDownload": MessageLookupByLibrary.simpleMessage("Download"),
    "screensItemPodcastPodcastEpisodeDetailsDownloadAddedToQueue": MessageLookupByLibrary.simpleMessage(
      "Download added to queue.",
    ),
    "screensItemPodcastPodcastEpisodeDetailsDownloading": MessageLookupByLibrary.simpleMessage("Downloading"),
    "screensItemPodcastPodcastEpisodeDetailsEpisode": MessageLookupByLibrary.simpleMessage("Episode"),
    "screensItemPodcastPodcastEpisodeUtilsAll": MessageLookupByLibrary.simpleMessage("All"),
    "screensItemPodcastPodcastEpisodeUtilsComplete": MessageLookupByLibrary.simpleMessage("Complete"),
    "screensItemPodcastPodcastEpisodeUtilsInProgress": MessageLookupByLibrary.simpleMessage("In Progress"),
    "screensItemPodcastPodcastEpisodeUtilsIncomplete": MessageLookupByLibrary.simpleMessage("Incomplete"),
    "screensItemPodcastPodcastEpisodeUtilsNewest": MessageLookupByLibrary.simpleMessage("Newest"),
    "screensItemPodcastPodcastEpisodeUtilsOldest": MessageLookupByLibrary.simpleMessage("Oldest"),
    "screensItemPodcastPodcastEpisodeUtilsTitleAZ": MessageLookupByLibrary.simpleMessage("Title A-Z"),
    "screensItemPodcastPodcastEpisodeUtilsTitleZA": MessageLookupByLibrary.simpleMessage("Title Z-A"),
    "screensItemPodcastPodcastEpisodeUtilsUntitledEpisode": MessageLookupByLibrary.simpleMessage("Untitled episode"),
    "screensItemPodcastPodcastEpisodesHeaderCardClearSearch": MessageLookupByLibrary.simpleMessage("Clear search"),
    "screensItemPodcastPodcastEpisodesHeaderCardEpisodes": MessageLookupByLibrary.simpleMessage("Episodes"),
    "screensItemPodcastPodcastEpisodesHeaderCardSearchEpisodesByTitle": MessageLookupByLibrary.simpleMessage(
      "Search episodes by title",
    ),
    "screensItemPodcastPodcastHeaderCardBack": MessageLookupByLibrary.simpleMessage("Back"),
    "screensItemPodcastPodcastHeaderCardDescription": MessageLookupByLibrary.simpleMessage("DESCRIPTION"),
    "screensItemPodcastPodcastHeaderCardPodcast": MessageLookupByLibrary.simpleMessage("Podcast"),
    "screensLayoutHomeLayoutHomeAppBarsClearSearch": MessageLookupByLibrary.simpleMessage("Clear search"),
    "screensLayoutHomeLayoutHomeAppBarsClearSelection": MessageLookupByLibrary.simpleMessage("Clear selection"),
    "screensLayoutHomeLayoutHomeAppBarsOpenUploader": MessageLookupByLibrary.simpleMessage("Open uploader"),
    "screensLayoutHomeLayoutHomeAppBarsSearchThisLibrary": MessageLookupByLibrary.simpleMessage("Search this library"),
    "screensLayoutHomeLayoutHomeAppBarsUpload": MessageLookupByLibrary.simpleMessage("Upload"),
    "screensLayoutHomeLeavePage": MessageLookupByLibrary.simpleMessage("Leave page"),
    "screensLayoutHomeLeaveUploadPage": MessageLookupByLibrary.simpleMessage("Leave upload page?"),
    "screensLayoutHomeLeavingThisPageNowCancelsActive": MessageLookupByLibrary.simpleMessage(
      "Leaving this page now cancels active uploads. Continue?",
    ),
    "screensLayoutHomeStayHere": MessageLookupByLibrary.simpleMessage("Stay here"),
    "screensMainAuthorDetailViewBack": MessageLookupByLibrary.simpleMessage("Back"),
    "screensMainAuthorsViewAuthorsAreAvailableOnlyForBook": MessageLookupByLibrary.simpleMessage(
      "Authors are available only for book libraries.",
    ),
    "screensMainAuthorsViewNoAuthorsFoundInThisLibrary": MessageLookupByLibrary.simpleMessage(
      "No authors found in this library.",
    ),
    "screensMainAuthorsViewNoLibrarySelectedPleaseSelectA": MessageLookupByLibrary.simpleMessage(
      "No library selected. Please select a library via the switcher.",
    ),
    "screensMainCollectionDetailViewBack": MessageLookupByLibrary.simpleMessage("Back"),
    "screensMainCollectionDetailViewCollectionActions": MessageLookupByLibrary.simpleMessage("Collection actions"),
    "screensMainCollectionDetailViewDeleteCollection": MessageLookupByLibrary.simpleMessage("Delete collection"),
    "screensMainCollectionDetailViewEditBooks": MessageLookupByLibrary.simpleMessage("Edit books"),
    "screensMainCollectionDetailViewEditDetails": MessageLookupByLibrary.simpleMessage("Edit details"),
    "screensMainCollectionDetailViewNoBooksFoundInThisCollection": MessageLookupByLibrary.simpleMessage(
      "No books found in this collection.",
    ),
    "screensMainCollectionDetailViewNoLibrarySelectedPleaseSelectA": MessageLookupByLibrary.simpleMessage(
      "No library selected. Please select a library via the switcher.",
    ),
    "screensMainCollectionViewDeleteCollection": MessageLookupByLibrary.simpleMessage("Delete collection"),
    "screensMainCollectionViewEditBooks": MessageLookupByLibrary.simpleMessage("Edit books"),
    "screensMainCollectionViewEditDetails": MessageLookupByLibrary.simpleMessage("Edit details"),
    "screensMainCollectionViewNoLibrarySelectedPleaseSelectA": MessageLookupByLibrary.simpleMessage(
      "No library selected. Please select a library via the switcher.",
    ),
    "screensMainDownloadsCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "screensMainDownloadsDelete": MessageLookupByLibrary.simpleMessage("Delete"),
    "screensMainDownloadsDeleteDownload": MessageLookupByLibrary.simpleMessage("Delete download"),
    "screensMainDownloadsDeleteFromLocalStorageAndRemove": m147,
    "screensMainDownloadsNoActiveUser": MessageLookupByLibrary.simpleMessage("No active user."),
    "screensMainDownloadsNoDownloadsAvailable": MessageLookupByLibrary.simpleMessage("No downloads available."),
    "screensMainDownloadsSelect": MessageLookupByLibrary.simpleMessage("Select"),
    "screensMainLibraryViewNoItemsFoundInThisLibrary": MessageLookupByLibrary.simpleMessage(
      "No items found in this library.",
    ),
    "screensMainLibraryViewNoLibrarySelectedPleaseSelectA": MessageLookupByLibrary.simpleMessage(
      "No library selected. Please select a library via the switcher.",
    ),
    "screensMainNarratorDetailViewBack": MessageLookupByLibrary.simpleMessage("Back"),
    "screensMainNarratorsViewNarratorsAreAvailableOnlyForBook": MessageLookupByLibrary.simpleMessage(
      "Narrators are available only for book libraries.",
    ),
    "screensMainNarratorsViewNoLibrarySelectedPleaseSelectA": MessageLookupByLibrary.simpleMessage(
      "No library selected. Please select a library via the switcher.",
    ),
    "screensMainNarratorsViewNoNarratorsFoundInThisLibrary": MessageLookupByLibrary.simpleMessage(
      "No narrators found in this library.",
    ),
    "screensMainPersonalizedViewFailedToQueueVisibleItems": m148,
    "screensMainPersonalizedViewNoLibrarySelectedPleaseSelectA": MessageLookupByLibrary.simpleMessage(
      "No library selected. Please select a library via the switcher.",
    ),
    "screensMainPersonalizedViewNoPersonalizedItemsFound": MessageLookupByLibrary.simpleMessage(
      "No personalized items found",
    ),
    "screensMainPersonalizedViewNoPersonalizedSectionsAreAvailableForThis": MessageLookupByLibrary.simpleMessage(
      "No personalized sections are available for this library yet.",
    ),
    "screensMainPersonalizedViewNoPersonalizedSectionsAvailableYet": MessageLookupByLibrary.simpleMessage(
      "No personalized sections available yet",
    ),
    "screensMainPersonalizedViewNoServerConnectionAvailable": MessageLookupByLibrary.simpleMessage(
      "No server connection available",
    ),
    "screensMainPersonalizedViewOpenDownloads": MessageLookupByLibrary.simpleMessage("Open Downloads"),
    "screensMainPersonalizedViewPersonalizedShelfIsOffline": MessageLookupByLibrary.simpleMessage(
      "Personalized shelf is offline",
    ),
    "screensMainPersonalizedViewPullDownToRefreshAndTryAgain": MessageLookupByLibrary.simpleMessage(
      "Pull down to refresh and try again.",
    ),
    "screensMainPersonalizedViewPullDownToRefreshOnceYourConnectionIs": MessageLookupByLibrary.simpleMessage(
      "Pull down to refresh once your connection is back.",
    ),
    "screensMainPersonalizedViewQueueAllItemsInThisShelf": MessageLookupByLibrary.simpleMessage(
      "Queue all items in this shelf",
    ),
    "screensMainPersonalizedViewRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "screensMainPersonalizedViewServerConnectionIsUnstableDisplayingThe": MessageLookupByLibrary.simpleMessage(
      "Server connection is unstable. Displaying the latest available shelf data.",
    ),
    "screensMainPersonalizedViewUnableToReachTheServerRightNowPull": MessageLookupByLibrary.simpleMessage(
      "Unable to reach the server right now. Pull down to retry.",
    ),
    "screensMainPlaylistDetailViewBack": MessageLookupByLibrary.simpleMessage("Back"),
    "screensMainPlaylistDetailViewDeletePlaylist": MessageLookupByLibrary.simpleMessage("Delete playlist"),
    "screensMainPlaylistDetailViewEditBooks": MessageLookupByLibrary.simpleMessage("Edit books"),
    "screensMainPlaylistDetailViewEditDetails": MessageLookupByLibrary.simpleMessage("Edit details"),
    "screensMainPlaylistDetailViewNoLibraryItemsFoundInThis": MessageLookupByLibrary.simpleMessage(
      "No library items found in this playlist.",
    ),
    "screensMainPlaylistDetailViewNoLibrarySelectedPleaseSelectA": MessageLookupByLibrary.simpleMessage(
      "No library selected. Please select a library via the switcher.",
    ),
    "screensMainPlaylistDetailViewPlaylistActions": MessageLookupByLibrary.simpleMessage("Playlist actions"),
    "screensMainPlaylistViewDeletePlaylist": MessageLookupByLibrary.simpleMessage("Delete playlist"),
    "screensMainPlaylistViewEditBooks": MessageLookupByLibrary.simpleMessage("Edit books"),
    "screensMainPlaylistViewEditDetails": MessageLookupByLibrary.simpleMessage("Edit details"),
    "screensMainPlaylistViewNoLibrarySelectedPleaseSelectA": MessageLookupByLibrary.simpleMessage(
      "No library selected. Please select a library via the switcher.",
    ),
    "screensMainSearchViewErrorLoadingSearchResults": m149,
    "screensMainSearchViewNoLibrarySelectedPleaseSelectA": MessageLookupByLibrary.simpleMessage(
      "No library selected. Please select a library via the switcher.",
    ),
    "screensMainSearchViewNoResultsFound": MessageLookupByLibrary.simpleMessage("No results found."),
    "screensMainSearchViewNoResultsFoundFor": m150,
    "screensMainSearchViewSearchResultsFor": m151,
    "screensMainSeriesDetailViewBack": MessageLookupByLibrary.simpleMessage("Back"),
    "screensMainSeriesDetailViewNoBooksFoundInThisSeries": MessageLookupByLibrary.simpleMessage(
      "No books found in this series.",
    ),
    "screensMainSeriesDetailViewNoLibrarySelectedPleaseSelectA": MessageLookupByLibrary.simpleMessage(
      "No library selected. Please select a library via the switcher.",
    ),
    "screensMainSeriesDetailViewSeriesAreAvailableOnlyForBook": MessageLookupByLibrary.simpleMessage(
      "Series are available only for book libraries.",
    ),
    "screensMainSeriesDetailViewSeriesDetailsCouldNotBeLoaded": MessageLookupByLibrary.simpleMessage(
      "Series details could not be loaded.",
    ),
    "screensMainSeriesViewNoLibrarySelectedPleaseSelectA": MessageLookupByLibrary.simpleMessage(
      "No library selected. Please select a library via the switcher.",
    ),
    "screensMainSeriesViewNoSeriesFoundInThisLibrary": MessageLookupByLibrary.simpleMessage(
      "No series found in this library.",
    ),
    "screensMainSeriesViewSeriesAreAvailableOnlyForBook": MessageLookupByLibrary.simpleMessage(
      "Series are available only for book libraries.",
    ),
    "screensMainStatsStatsActivityHeatmapLess": MessageLookupByLibrary.simpleMessage("Less"),
    "screensMainStatsStatsActivityHeatmapMore": MessageLookupByLibrary.simpleMessage("More"),
    "screensMainStatsStatsActivityRangeChartD": m152,
    "screensMainStatsStatsActivityRangeChartLastDays": m153,
    "screensMainStatsStatsActivityRangeChartText": m154,
    "screensMainStatsStatsActivitySectionFailedToLoadListeningActivity": MessageLookupByLibrary.simpleMessage(
      "Failed to load listening activity.",
    ),
    "screensMainStatsStatsActivitySectionRetryActivity": MessageLookupByLibrary.simpleMessage("Retry Activity"),
    "screensMainStatsStatsActivityTotalsCardListeningTimeTotals": MessageLookupByLibrary.simpleMessage(
      "Listening Time Totals",
    ),
    "screensMainStatsStatsActivityTotalsCardRetryTotals": MessageLookupByLibrary.simpleMessage("Retry totals"),
    "screensMainStatsStatsAdvancedDashboardAverageSession": MessageLookupByLibrary.simpleMessage("Average Session"),
    "screensMainStatsStatsAdvancedDashboardBookListening": MessageLookupByLibrary.simpleMessage("Book Listening"),
    "screensMainStatsStatsAdvancedDashboardBusiestHours": MessageLookupByLibrary.simpleMessage("Busiest Hours"),
    "screensMainStatsStatsAdvancedDashboardFailedToComputeAdvancedStats": MessageLookupByLibrary.simpleMessage(
      "Failed to compute advanced stats.",
    ),
    "screensMainStatsStatsAdvancedDashboardFavoriteHour": MessageLookupByLibrary.simpleMessage("Favorite Hour"),
    "screensMainStatsStatsAdvancedDashboardFavoriteWeekday": MessageLookupByLibrary.simpleMessage("Favorite Weekday"),
    "screensMainStatsStatsAdvancedDashboardFirstSession": MessageLookupByLibrary.simpleMessage("First Session"),
    "screensMainStatsStatsAdvancedDashboardLastSession": MessageLookupByLibrary.simpleMessage("Last Session"),
    "screensMainStatsStatsAdvancedDashboardLoadedPages": MessageLookupByLibrary.simpleMessage("Loaded Pages"),
    "screensMainStatsStatsAdvancedDashboardLoadedSessions": MessageLookupByLibrary.simpleMessage("Loaded Sessions"),
    "screensMainStatsStatsAdvancedDashboardLoadingAdvancedAnalytics": MessageLookupByLibrary.simpleMessage(
      "Loading advanced analytics...",
    ),
    "screensMainStatsStatsAdvancedDashboardLongestSession": MessageLookupByLibrary.simpleMessage("Longest Session"),
    "screensMainStatsStatsAdvancedDashboardLongestStreak": MessageLookupByLibrary.simpleMessage("Longest Streak"),
    "screensMainStatsStatsAdvancedDashboardMedianSession": MessageLookupByLibrary.simpleMessage("Median Session"),
    "screensMainStatsStatsAdvancedDashboardNoHourlyDataAvailable": MessageLookupByLibrary.simpleMessage(
      "No hourly data available.",
    ),
    "screensMainStatsStatsAdvancedDashboardNoMonthlyDataAvailable": MessageLookupByLibrary.simpleMessage(
      "No monthly data available.",
    ),
    "screensMainStatsStatsAdvancedDashboardNoTopAuthorsAvailable": MessageLookupByLibrary.simpleMessage(
      "No top authors available.",
    ),
    "screensMainStatsStatsAdvancedDashboardNoTopItemsAvailable": MessageLookupByLibrary.simpleMessage(
      "No top items available.",
    ),
    "screensMainStatsStatsAdvancedDashboardNoWeekdayDataAvailable": MessageLookupByLibrary.simpleMessage(
      "No weekday data available.",
    ),
    "screensMainStatsStatsAdvancedDashboardPagesSessions": m155,
    "screensMainStatsStatsAdvancedDashboardPodcastListening": MessageLookupByLibrary.simpleMessage("Podcast Listening"),
    "screensMainStatsStatsAdvancedDashboardRetryAdvancedMode": MessageLookupByLibrary.simpleMessage(
      "Retry Advanced Mode",
    ),
    "screensMainStatsStatsAdvancedDashboardTopAuthors": MessageLookupByLibrary.simpleMessage("Top Authors"),
    "screensMainStatsStatsAdvancedDashboardTopItems": MessageLookupByLibrary.simpleMessage("Top Items"),
    "screensMainStatsStatsAdvancedDashboardTopMonths": MessageLookupByLibrary.simpleMessage("Top Months"),
    "screensMainStatsStatsAdvancedDashboardTotalListening": MessageLookupByLibrary.simpleMessage("Total Listening"),
    "screensMainStatsStatsAdvancedDashboardTotalSessions": MessageLookupByLibrary.simpleMessage("Total Sessions"),
    "screensMainStatsStatsAdvancedDashboardUniqueAuthors": MessageLookupByLibrary.simpleMessage("Unique Authors"),
    "screensMainStatsStatsAdvancedDashboardUniqueItems": MessageLookupByLibrary.simpleMessage("Unique Items"),
    "screensMainStatsStatsAdvancedDashboardWeekdayBreakdown": MessageLookupByLibrary.simpleMessage("Weekday Breakdown"),
    "screensMainStatsStatsFormattersUnknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "screensMainStatsStatsFormattersZeroClock": MessageLookupByLibrary.simpleMessage("0:00"),
    "screensMainStatsStatsFormattersZeroMinutes": MessageLookupByLibrary.simpleMessage("0 min"),
    "screensMainStatsStatsRecentSessionsListNoRecentSessionsAvailable": MessageLookupByLibrary.simpleMessage(
      "No recent sessions available.",
    ),
    "screensMainStatsStatsWeekdayBreakdownNoWeekdayListeningDataAvailable": MessageLookupByLibrary.simpleMessage(
      "No weekday listening data available.",
    ),
    "screensMainStatsStatsYearRewindSectionFailedToLoadYearInReview": MessageLookupByLibrary.simpleMessage(
      "Failed to load year-in-review stats.",
    ),
    "screensMainStatsStatsYearRewindSectionInRewind": m156,
    "screensMainStatsStatsYearRewindSectionNoYearInReviewDataAvailable": MessageLookupByLibrary.simpleMessage(
      "No year-in-review data available for this year.",
    ),
    "screensMainStatsStatsYearRewindSectionPeakMonth": m157,
    "screensMainStatsStatsYearRewindSectionRefresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "screensMainStatsStatsYearRewindSectionRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "screensMainStatsStatsYearRewindSectionYear": MessageLookupByLibrary.simpleMessage("Year"),
    "screensMainStatsViewAdvancedModeFetchesEveryListeningSession": MessageLookupByLibrary.simpleMessage(
      "Advanced mode fetches every listening-session page and can take time on large accounts.",
    ),
    "screensMainStatsViewCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "screensMainStatsViewLoad": MessageLookupByLibrary.simpleMessage("Load"),
    "screensMainStatsViewLoadAdvancedAnalytics": MessageLookupByLibrary.simpleMessage("Load advanced analytics?"),
    "screensMainStatsViewLoadAdvancedAnalytics2": MessageLookupByLibrary.simpleMessage("Load Advanced Analytics"),
    "screensMainStatsViewRecentSessions": MessageLookupByLibrary.simpleMessage("Recent Sessions"),
    "screensMainStatsViewRefreshActivity": MessageLookupByLibrary.simpleMessage("Refresh activity"),
    "screensMainStatsViewStats": MessageLookupByLibrary.simpleMessage("Stats"),
    "screensMainUserListeningSessionsViewBack": MessageLookupByLibrary.simpleMessage("Back"),
    "screensMainUserListeningSessionsViewListeningSessions": MessageLookupByLibrary.simpleMessage("Listening Sessions"),
    "screensPlayerBookmarksSheetBookmarkAddedAt": m158,
    "screensPlayerBookmarksSheetBookmarkDeleted": MessageLookupByLibrary.simpleMessage("Bookmark deleted."),
    "screensPlayerBookmarksSheetBookmarks": MessageLookupByLibrary.simpleMessage("Bookmarks"),
    "screensPlayerBookmarksSheetCouldNotCreateBookmarkRightNow": MessageLookupByLibrary.simpleMessage(
      "Could not create bookmark right now.",
    ),
    "screensPlayerBookmarksSheetCouldNotDeleteBookmarkRightNow": MessageLookupByLibrary.simpleMessage(
      "Could not delete bookmark right now.",
    ),
    "screensPlayerBookmarksSheetFailedToCreateBookmark": MessageLookupByLibrary.simpleMessage(
      "Failed to create bookmark.",
    ),
    "screensPlayerBookmarksSheetFailedToDeleteBookmark": MessageLookupByLibrary.simpleMessage(
      "Failed to delete bookmark.",
    ),
    "screensPlayerBookmarksSheetNoBookmarksYet": MessageLookupByLibrary.simpleMessage("No bookmarks yet"),
    "screensPlayerBookmarksSheetPlayALittleFurtherBeforeCreating": MessageLookupByLibrary.simpleMessage(
      "Play a little further before creating a bookmark.",
    ),
    "screensPlayerBookmarksSheetPleaseEnterBookmarkText": MessageLookupByLibrary.simpleMessage(
      "Please enter bookmark text.",
    ),
    "screensPlayerCarModeScreenCarMode": MessageLookupByLibrary.simpleMessage("Car Mode"),
    "screensPlayerChapterNoChaptersAvailable": MessageLookupByLibrary.simpleMessage("No chapters available"),
    "screensPlayerChapterText": m159,
    "screensPlayerComponentsBookmarkTitleDialogBookmarkText": MessageLookupByLibrary.simpleMessage("Bookmark text"),
    "screensPlayerComponentsBookmarkTitleDialogCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "screensPlayerComponentsBookmarkTitleDialogCreate": MessageLookupByLibrary.simpleMessage("Create"),
    "screensPlayerComponentsBookmarkTitleDialogCreateBookmark": MessageLookupByLibrary.simpleMessage("Create bookmark"),
    "screensPlayerComponentsBookmarkTitleDialogEnterBookmark": MessageLookupByLibrary.simpleMessage("Enter bookmark"),
    "screensPlayerLayoutPlayerComponentSettingsSheetCoverFitMode": MessageLookupByLibrary.simpleMessage(
      "Cover fit mode",
    ),
    "screensPlayerLayoutPlayerComponentSettingsSheetFontScaleX": m160,
    "screensPlayerLayoutPlayerComponentSettingsSheetHidden": MessageLookupByLibrary.simpleMessage("Hidden"),
    "screensPlayerLayoutPlayerComponentSettingsSheetMoveDown": MessageLookupByLibrary.simpleMessage("Move down"),
    "screensPlayerLayoutPlayerComponentSettingsSheetMoveUp": MessageLookupByLibrary.simpleMessage("Move up"),
    "screensPlayerLayoutPlayerComponentSettingsSheetScaleX": m161,
    "screensPlayerLayoutPlayerComponentSettingsSheetSeekBarHeight": m162,
    "screensPlayerLayoutPlayerComponentSettingsSheetSettings": m163,
    "screensPlayerLayoutPlayerComponentSettingsSheetShowAuthor": MessageLookupByLibrary.simpleMessage("Show author"),
    "screensPlayerLayoutPlayerComponentSettingsSheetShowNarrator": MessageLookupByLibrary.simpleMessage(
      "Show narrator",
    ),
    "screensPlayerLayoutPlayerComponentSettingsSheetShowSeries": MessageLookupByLibrary.simpleMessage("Show series"),
    "screensPlayerLayoutPlayerComponentSettingsSheetTextAlignment": MessageLookupByLibrary.simpleMessage(
      "Text alignment",
    ),
    "screensPlayerLayoutPlayerComponentSettingsSheetTimeFontSize": m164,
    "screensPlayerLayoutPlayerComponentSettingsSheetTimeLabelsPosition": MessageLookupByLibrary.simpleMessage(
      "Time labels position",
    ),
    "screensPlayerLayoutPlayerComponentSettingsSheetUseCardStyle": MessageLookupByLibrary.simpleMessage(
      "Use card style",
    ),
    "screensPlayerLayoutPlayerComponentSettingsSheetVisible": MessageLookupByLibrary.simpleMessage("Visible"),
    "screensPlayerLayoutPlayerComponentSettingsSheetWhenThisComponentHasNoData": MessageLookupByLibrary.simpleMessage(
      "When this component has no data",
    ),
    "screensPlayerLayoutPlayerGridCanvasComponentActions": MessageLookupByLibrary.simpleMessage("Component actions"),
    "screensPlayerLayoutPlayerGridCanvasMoveDown": MessageLookupByLibrary.simpleMessage("Move down"),
    "screensPlayerLayoutPlayerGridCanvasMoveLeft": MessageLookupByLibrary.simpleMessage("Move left"),
    "screensPlayerLayoutPlayerGridCanvasMoveRight": MessageLookupByLibrary.simpleMessage("Move right"),
    "screensPlayerLayoutPlayerGridCanvasMoveUp": MessageLookupByLibrary.simpleMessage("Move up"),
    "screensPlayerLayoutPlayerGridCanvasNarrower": MessageLookupByLibrary.simpleMessage("Narrower"),
    "screensPlayerLayoutPlayerGridCanvasNoComponentsAreVisibleForThis": MessageLookupByLibrary.simpleMessage(
      "No components are visible for this layout.",
    ),
    "screensPlayerLayoutPlayerGridCanvasRemoveFromLayout": MessageLookupByLibrary.simpleMessage("Remove from layout"),
    "screensPlayerLayoutPlayerGridCanvasSettings": MessageLookupByLibrary.simpleMessage("Settings"),
    "screensPlayerLayoutPlayerGridCanvasShorter": MessageLookupByLibrary.simpleMessage("Shorter"),
    "screensPlayerLayoutPlayerGridCanvasTaller": MessageLookupByLibrary.simpleMessage("Taller"),
    "screensPlayerLayoutPlayerGridCanvasWider": MessageLookupByLibrary.simpleMessage("Wider"),
    "screensPlayerPlayBarLoadingNextItem": MessageLookupByLibrary.simpleMessage("Loading next item..."),
    "screensPlayerPlayHistoryLocalTabError": m165,
    "screensPlayerPlayHistoryLocalTabNoActiveUser": MessageLookupByLibrary.simpleMessage("No active user."),
    "screensPlayerPlayHistoryLocalTabNoPlayHistoryAvailable": MessageLookupByLibrary.simpleMessage(
      "No play history available",
    ),
    "screensPlayerPlayHistoryLocalTabPosition": m166,
    "screensPlayerPlayHistoryLocalTabToday": MessageLookupByLibrary.simpleMessage("Today"),
    "screensPlayerPlayHistoryLocalTabYesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
    "screensPlayerPlayHistoryViewFailedToLoadItemSessions": m167,
    "screensPlayerPlayHistoryViewNoUserOrMediaItemAvailable": MessageLookupByLibrary.simpleMessage(
      "No user or media item available",
    ),
    "screensPlayerPlayHistoryViewPlayHistory": MessageLookupByLibrary.simpleMessage("Play History"),
    "screensPlayerPlayerAddComponent": MessageLookupByLibrary.simpleMessage("Add component"),
    "screensPlayerPlayerCopyLayoutConfig": MessageLookupByLibrary.simpleMessage("Copy layout config"),
    "screensPlayerPlayerDoneEditing": MessageLookupByLibrary.simpleMessage("Done editing"),
    "screensPlayerPlayerEditLayout": m168,
    "screensPlayerPlayerEnterLayoutEditMode": MessageLookupByLibrary.simpleMessage("Enter layout edit mode"),
    "screensPlayerPlayerExitEditMode": MessageLookupByLibrary.simpleMessage("Exit edit mode"),
    "screensPlayerPlayerLayoutConfigCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "Layout config copied to clipboard.",
    ),
    "screensPlayerPlayerLoadingNextItem": MessageLookupByLibrary.simpleMessage("Loading next item..."),
    "screensPlayerPlayerLockedModePreventOverlap": MessageLookupByLibrary.simpleMessage(
      "Locked mode (prevent overlap)",
    ),
    "screensPlayerPlayerMoreOptions": MessageLookupByLibrary.simpleMessage("More options"),
    "screensPlayerPlayerNoActiveMediaToBookmark": MessageLookupByLibrary.simpleMessage("No active media to bookmark."),
    "screensPlayerPlayerNoFreeGridSpaceAvailableFor": m169,
    "screensPlayerPlayerPlayer": MessageLookupByLibrary.simpleMessage("Player"),
    "screensPlayerPlayerQueue": MessageLookupByLibrary.simpleMessage("Queue"),
    "screensPlayerPlayerQuickPlayerSettings": MessageLookupByLibrary.simpleMessage("Quick Player Settings"),
    "screensPlayerPlayerQuickSettings": MessageLookupByLibrary.simpleMessage("Quick Settings"),
    "screensPlayerPlayerResetActiveScreenLayout": MessageLookupByLibrary.simpleMessage("Reset active screen layout"),
    "screensPlayerPlayerTimelineMode": MessageLookupByLibrary.simpleMessage("Timeline mode"),
    "screensPlayerPlayerUnlockedOverlapMode": MessageLookupByLibrary.simpleMessage("Unlocked overlap mode"),
    "screensPlayerQueueAndMoreToLoad": m170,
    "screensPlayerQueueLoadMore": MessageLookupByLibrary.simpleMessage("Load more"),
    "screensPlayerQueueLoadingTitle": MessageLookupByLibrary.simpleMessage("Loading title..."),
    "screensPlayerQueueQueueIsEmpty": MessageLookupByLibrary.simpleMessage("Queue is empty"),
    "screensPlayerQueueRemoveFromQueue": MessageLookupByLibrary.simpleMessage("Remove from queue"),
    "screensPlayerSubtitleReadingModeNoSubtitlesAvailableForThisTitle": MessageLookupByLibrary.simpleMessage(
      "No subtitles available for this title.",
    ),
    "screensPlayerSubtitleReadingModeStartPlaybackToUseContinuousSubtitle": MessageLookupByLibrary.simpleMessage(
      "Start playback to use continuous subtitle reading mode.",
    ),
    "screensPlayerSubtitleReadingModeSubtitlesAreDisabledInPlayerSettings": MessageLookupByLibrary.simpleMessage(
      "Subtitles are disabled in player settings.",
    ),
    "screensPlayerSubtitleReadingModeWaitingForSubtitleCue": MessageLookupByLibrary.simpleMessage(
      "Waiting for subtitle cue...",
    ),
    "screensReaderReaderBuildersBookmark": MessageLookupByLibrary.simpleMessage("Bookmark"),
    "screensReaderReaderBuildersEbookReader": MessageLookupByLibrary.simpleMessage("Ebook Reader"),
    "screensReaderReaderBuildersHighlight": MessageLookupByLibrary.simpleMessage("Highlight"),
    "screensReaderReaderBuildersUnderline": MessageLookupByLibrary.simpleMessage("Underline"),
    "screensReaderReaderBuildersViewAnnotations": MessageLookupByLibrary.simpleMessage("View Annotations"),
    "screensReaderReaderFailedToLoadEbookMetadata": m171,
    "screensReaderReaderFailedToLoadUserProfile": m172,
    "screensReaderReaderMissingAuthenticationTokenForEbookLoading": MessageLookupByLibrary.simpleMessage(
      "Missing authentication token for ebook loading.",
    ),
    "screensReaderReaderNoAuthenticatedUserAvailable": MessageLookupByLibrary.simpleMessage(
      "No authenticated user available.",
    ),
    "screensReaderReaderPdfHelpersAddAnOptionalNote": MessageLookupByLibrary.simpleMessage("Add an optional note"),
    "screensReaderReaderPdfHelpersCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "screensReaderReaderPdfHelpersDeleteAnnotation": MessageLookupByLibrary.simpleMessage("Delete annotation"),
    "screensReaderReaderPdfHelpersEditBookmark": MessageLookupByLibrary.simpleMessage("Edit bookmark"),
    "screensReaderReaderPdfHelpersSave": MessageLookupByLibrary.simpleMessage("Save"),
    "screensReaderReaderPdfHelpersText": MessageLookupByLibrary.simpleMessage("Text"),
    "screensReaderWidgetsReaderEpubAnnotationsListViewAnnotations": MessageLookupByLibrary.simpleMessage("Annotations"),
    "screensReaderWidgetsReaderEpubAnnotationsListViewBookmarkRemoved": MessageLookupByLibrary.simpleMessage(
      "Bookmark removed",
    ),
    "screensReaderWidgetsReaderEpubAnnotationsListViewErrorRemovingBookmark": m173,
    "screensReaderWidgetsReaderEpubAnnotationsListViewErrorRemovingHighlight": m174,
    "screensReaderWidgetsReaderEpubAnnotationsListViewErrorRemovingUnderline": m175,
    "screensReaderWidgetsReaderEpubAnnotationsListViewHighlightRemoved": MessageLookupByLibrary.simpleMessage(
      "Highlight removed",
    ),
    "screensReaderWidgetsReaderEpubAnnotationsListViewNoAnnotationsFound": MessageLookupByLibrary.simpleMessage(
      "No annotations found",
    ),
    "screensReaderWidgetsReaderEpubAnnotationsListViewUnderlineRemoved": MessageLookupByLibrary.simpleMessage(
      "Underline removed",
    ),
    "screensReaderWidgetsReaderPdfAnnotationsListViewAnnotations": MessageLookupByLibrary.simpleMessage("Annotations"),
    "screensReaderWidgetsReaderPdfAnnotationsListViewDeleteAnnotation": MessageLookupByLibrary.simpleMessage(
      "Delete annotation",
    ),
    "screensReaderWidgetsReaderPdfAnnotationsListViewEditBookmark": MessageLookupByLibrary.simpleMessage(
      "Edit bookmark",
    ),
    "screensReaderWidgetsReaderPdfAnnotationsListViewNoAnnotationsFound": MessageLookupByLibrary.simpleMessage(
      "No annotations found",
    ),
    "screensReaderWidgetsReaderPdfAnnotationsListViewPage": m176,
    "screensReaderWidgetsReaderPdfAnnotationsListViewPagePx": m177,
    "screensReaderWidgetsReaderPdfAnnotationsListViewRange": m178,
    "screensReaderWidgetsReaderThicknessPickerSheetPx": m179,
    "screensReaderWidgetsReaderThicknessPickerSheetSelectUnderlineThickness": MessageLookupByLibrary.simpleMessage(
      "Select Underline Thickness",
    ),
    "screensSettingsAdminItemMetadataUtilsSettingsBack": MessageLookupByLibrary.simpleMessage("Back"),
    "screensSettingsAdminItemMetadataUtilsSettingsItemMetadataUtils": MessageLookupByLibrary.simpleMessage(
      "Item Metadata Utils",
    ),
    "screensSettingsAdminServerLibraryStatsSettingsTitle": MessageLookupByLibrary.simpleMessage("Library Stats"),
    "screensSettingsAdminServerLogsSettingsTitle": MessageLookupByLibrary.simpleMessage("Admin Logs"),
    "screensSettingsAdminServerSessionsSettingsBack": MessageLookupByLibrary.simpleMessage("Back"),
    "screensSettingsAdminServerSessionsSettingsListeningSessions": MessageLookupByLibrary.simpleMessage(
      "Listening Sessions",
    ),
    "screensSettingsAdminServerSettingsFailedToLoadUserSettings": m180,
    "screensSettingsAdminServerSettingsNoActiveUserSignInTo": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in to open admin server settings.",
    ),
    "screensSettingsAdminServerSettingsYouCurrentlyAreManagingTheServer": m181,
    "screensSettingsAdminServerUsersSettingsTitle": MessageLookupByLibrary.simpleMessage("Manage Users"),
    "screensSettingsAndroidAutoAndroidAutoLibrarySettingsAuthor": MessageLookupByLibrary.simpleMessage("Author"),
    "screensSettingsAndroidAutoAndroidAutoLibrarySettingsDateAdded": MessageLookupByLibrary.simpleMessage("Date Added"),
    "screensSettingsAndroidAutoAndroidAutoLibrarySettingsFailedToLoadUserSettings": m182,
    "screensSettingsAndroidAutoAndroidAutoLibrarySettingsFailedToUpdateSortField": m183,
    "screensSettingsAndroidAutoAndroidAutoLibrarySettingsNoActiveUserSignInTo": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in to configure Android Auto library settings.",
    ),
    "screensSettingsAndroidAutoAndroidAutoLibrarySettingsSortBy": MessageLookupByLibrary.simpleMessage("Sort By"),
    "screensSettingsAndroidAutoAndroidAutoLibrarySettingsTitle": MessageLookupByLibrary.simpleMessage("Title"),
    "screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsAuthor": MessageLookupByLibrary.simpleMessage("Author"),
    "screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsDateAdded": MessageLookupByLibrary.simpleMessage(
      "Date Added",
    ),
    "screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsFailedToLoadUserSettings": m184,
    "screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsFailedToUpdateSortField": m185,
    "screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsNoActiveUserSignInTo":
        MessageLookupByLibrary.simpleMessage("No active user. Sign in to configure Android Auto podcast settings."),
    "screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsSortBy": MessageLookupByLibrary.simpleMessage(
      "Sort By",
    ),
    "screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsTitle": MessageLookupByLibrary.simpleMessage("Title"),
    "screensSettingsAndroidAutoSettingsAaosModeActive": MessageLookupByLibrary.simpleMessage("AAOS mode active"),
    "screensSettingsAndroidAutoSettingsAaosSettings": MessageLookupByLibrary.simpleMessage("AAOS Settings"),
    "screensSettingsAndroidAutoSettingsAndroidAutoSettings": MessageLookupByLibrary.simpleMessage(
      "Android Auto Settings",
    ),
    "screensSettingsAndroidAutoSettingsFailedToLoadUserSettings": m186,
    "screensSettingsAndroidAutoSettingsForNowThereAreNoAdditional": MessageLookupByLibrary.simpleMessage(
      "For now there are no additional AAOS-specific settings.",
    ),
    "screensSettingsAndroidAutoSettingsNoActiveUserSignInTo": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in to configure Android Auto browse settings.",
    ),
    "screensSettingsAppearanceSettingsDisplay": MessageLookupByLibrary.simpleMessage("Display"),
    "screensSettingsAppearanceSettingsEnglish": MessageLookupByLibrary.simpleMessage("English"),
    "screensSettingsAppearanceSettingsGeneral": MessageLookupByLibrary.simpleMessage("General"),
    "screensSettingsAppearanceSettingsGeneralDescription": MessageLookupByLibrary.simpleMessage(
      "Language and diagnostics.",
    ),
    "screensSettingsAppearanceSettingsGerman": MessageLookupByLibrary.simpleMessage("Deutsch"),
    "screensSettingsAppearanceSettingsLanguage": MessageLookupByLibrary.simpleMessage("Language"),
    "screensSettingsAppearanceSettingsLogLevel": MessageLookupByLibrary.simpleMessage("Log Level"),
    "screensSettingsAppearanceSettingsTheme": MessageLookupByLibrary.simpleMessage("Theme"),
    "screensSettingsAppearanceSettingsThemeSubtitle": MessageLookupByLibrary.simpleMessage(
      "Theme mode, preset palette, and custom accent color.",
    ),
    "screensSettingsAppearanceSettingsTitle": MessageLookupByLibrary.simpleMessage("Appearance Settings"),
    "screensSettingsCachingGeneralSettingsEnableCaching": MessageLookupByLibrary.simpleMessage("Enable caching"),
    "screensSettingsCachingGeneralSettingsEnableCachingDisabledReason": MessageLookupByLibrary.simpleMessage(
      "Enable response caching to use speedup mode.",
    ),
    "screensSettingsCachingGeneralSettingsSpeedupMode": MessageLookupByLibrary.simpleMessage("Speedup mode"),
    "screensSettingsCachingGeneralSettingsSpeedupModeDescription": MessageLookupByLibrary.simpleMessage(
      "Combines caching with refreshing the cache after each request. This can briefly show stale data until a refresh finishes.",
    ),
    "screensSettingsCachingGeneralSettingsTitle": MessageLookupByLibrary.simpleMessage("Caching - General"),
    "screensSettingsCachingRouteSettingsDescription": MessageLookupByLibrary.simpleMessage(
      "Configure per-endpoint cache behavior. Route settings remain accessible even when global caching is off.",
    ),
    "screensSettingsCachingRouteSettingsEnableCachingDisabledReason": MessageLookupByLibrary.simpleMessage(
      "Enable response caching to change route-level cache behavior.",
    ),
    "screensSettingsCachingRouteSettingsTitle": MessageLookupByLibrary.simpleMessage("Caching - Routes"),
    "screensSettingsCachingRouteSettingsWarningOddBehaviorMultipleDevices": MessageLookupByLibrary.simpleMessage(
      "Warning: Enabling this could lead to odd behavior with multiple devices.",
    ),
    "screensSettingsCachingSettingsGeneral": MessageLookupByLibrary.simpleMessage("General"),
    "screensSettingsCachingSettingsGeneralSubtitle": MessageLookupByLibrary.simpleMessage(
      "Enable/disable caching and configure speedup mode behavior.",
    ),
    "screensSettingsCachingSettingsRouteRules": MessageLookupByLibrary.simpleMessage("Route Rules"),
    "screensSettingsCachingSettingsRouteRulesDisabledSubtitle": MessageLookupByLibrary.simpleMessage(
      "Open route rules (editing is disabled until caching is enabled).",
    ),
    "screensSettingsCachingSettingsRouteRulesEnabledSubtitle": MessageLookupByLibrary.simpleMessage(
      "Configure endpoint-level cache behavior.",
    ),
    "screensSettingsCachingSettingsSubsettings": MessageLookupByLibrary.simpleMessage("Caching Subsettings"),
    "screensSettingsCachingSettingsTitle": MessageLookupByLibrary.simpleMessage("Caching Settings"),
    "screensSettingsLibrarySettingsChooseFolder": MessageLookupByLibrary.simpleMessage("Choose folder"),
    "screensSettingsLibrarySettingsCollapseSeries": MessageLookupByLibrary.simpleMessage("Collapse Series"),
    "screensSettingsLibrarySettingsDownloadLocationUpdated": MessageLookupByLibrary.simpleMessage(
      "Download location updated.",
    ),
    "screensSettingsLibrarySettingsFailedToLoadUserSettings": m187,
    "screensSettingsLibrarySettingsFailedToUpdateCollapseSeriesSetting": m188,
    "screensSettingsLibrarySettingsFailedToUpdateLocation": m189,
    "screensSettingsLibrarySettingsNoActiveUserSignInTo": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in to configure download settings.",
    ),
    "screensSettingsLibrarySettingsUseDefaultLocation": MessageLookupByLibrary.simpleMessage("Use default location"),
    "screensSettingsLibrarySettingsUsingDefaultDownloadLocation": MessageLookupByLibrary.simpleMessage(
      "Using default download location.",
    ),
    "screensSettingsLicenseSettingsProvidedAsIsWithoutWarranty": MessageLookupByLibrary.simpleMessage(
      "This application is provided \"as is\" without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement.",
    ),
    "screensSettingsLogViewAutoScroll": MessageLookupByLibrary.simpleMessage("Auto-scroll"),
    "screensSettingsLogViewCopyGitHub": MessageLookupByLibrary.simpleMessage("Copy GitHub"),
    "screensSettingsLogViewCopyRaw": MessageLookupByLibrary.simpleMessage("Copy Raw"),
    "screensSettingsLogViewFailedToExportLogs": m190,
    "screensSettingsLogViewGithubFormattedLogsCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "GitHub formatted logs copied to clipboard!",
    ),
    "screensSettingsLogViewLoadingLogs": MessageLookupByLibrary.simpleMessage("Loading logs..."),
    "screensSettingsLogViewLogsExportedToLogFile": m191,
    "screensSettingsLogViewLogsWillAppearHereAsThey": MessageLookupByLibrary.simpleMessage(
      "Logs will appear here as they are generated.",
    ),
    "screensSettingsLogViewNoLogsToCopy": MessageLookupByLibrary.simpleMessage("No logs to copy."),
    "screensSettingsLogViewNoLogsToExport": MessageLookupByLibrary.simpleMessage("No logs to export."),
    "screensSettingsLogViewNoLogsYet": MessageLookupByLibrary.simpleMessage("No logs yet"),
    "screensSettingsLogViewRawLogsCopiedToClipboard": MessageLookupByLibrary.simpleMessage(
      "Raw logs copied to clipboard!",
    ),
    "screensSettingsLogViewScrollToBottom": MessageLookupByLibrary.simpleMessage("Scroll to bottom"),
    "screensSettingsLogViewScrollToTop": MessageLookupByLibrary.simpleMessage("Scroll to top"),
    "screensSettingsPathTagGenreUpdateSettingsTitle": MessageLookupByLibrary.simpleMessage("Path Tag and Genre Update"),
    "screensSettingsPlayerGlobalPlayerSettingsAutoPlayLastPlayedOnAppStart": MessageLookupByLibrary.simpleMessage(
      "Auto-play last played on app start",
    ),
    "screensSettingsPlayerGlobalPlayerSettingsAutoPlayLastPlayedOnAppStartDescription":
        MessageLookupByLibrary.simpleMessage(
          "When enabled and nothing is currently playing, app launch will resume the last played item if it is not finished.",
        ),
    "screensSettingsPlayerGlobalPlayerSettingsKeepScreenOn": MessageLookupByLibrary.simpleMessage("Keep Screen On"),
    "screensSettingsPlayerGlobalPlayerSettingsLockMediaNotification": MessageLookupByLibrary.simpleMessage(
      "Lock Media Notification",
    ),
    "screensSettingsPlayerGlobalPlayerSettingsMaxBufferSize": MessageLookupByLibrary.simpleMessage("Max buffer size"),
    "screensSettingsPlayerGlobalPlayerSettingsMaxBufferSizeTooltip": MessageLookupByLibrary.simpleMessage(
      "Maximum size of the buffer in bytes. This is just a hint for the player and may not be respected by the OS. No more than 5 minutes should be cached.",
    ),
    "screensSettingsPlayerGlobalPlayerSettingsShowNotificationMoreButton": MessageLookupByLibrary.simpleMessage(
      "Show notification More button",
    ),
    "screensSettingsPlayerGlobalPlayerSettingsShowNotificationMoreButtonDescription":
        MessageLookupByLibrary.simpleMessage("When enabled, a More button will be shown, giving more quick actions"),
    "screensSettingsPlayerGlobalPlayerSettingsTitle": MessageLookupByLibrary.simpleMessage("Global Player Settings"),
    "screensSettingsPlayerPlayerSettingsAccessibilityAndDevice": MessageLookupByLibrary.simpleMessage(
      "Accessibility & Device",
    ),
    "screensSettingsPlayerPlayerSettingsGeneral": MessageLookupByLibrary.simpleMessage("General"),
    "screensSettingsPlayerPlayerSettingsGeneralAutoQueue": MessageLookupByLibrary.simpleMessage("Auto queue"),
    "screensSettingsPlayerPlayerSettingsGeneralAutoQueueDescription": MessageLookupByLibrary.simpleMessage(
      "Automatically queue upcoming books when playback starts from library, series, playlist, or collection views.",
    ),
    "screensSettingsPlayerPlayerSettingsGeneralAutoQueueFirstSeriesOutsideSourceViews":
        MessageLookupByLibrary.simpleMessage("Auto queue first series outside source views"),
    "screensSettingsPlayerPlayerSettingsGeneralAutoQueueFirstSeriesOutsideSourceViewsDescription":
        MessageLookupByLibrary.simpleMessage(
          "When Auto queue is enabled, also auto queue books from the first linked series even when playback starts outside a series view.",
        ),
    "screensSettingsPlayerPlayerSettingsGeneralEnableAutoQueueDisabledReason": MessageLookupByLibrary.simpleMessage(
      "Enable Auto queue to use this option.",
    ),
    "screensSettingsPlayerPlayerSettingsGeneralFastForwardInterval": MessageLookupByLibrary.simpleMessage(
      "Fast forward interval",
    ),
    "screensSettingsPlayerPlayerSettingsGeneralFastForwardIntervalDescription": MessageLookupByLibrary.simpleMessage(
      "How many seconds to skip when jumping forward.",
    ),
    "screensSettingsPlayerPlayerSettingsGeneralRewindInterval": MessageLookupByLibrary.simpleMessage("Rewind interval"),
    "screensSettingsPlayerPlayerSettingsGeneralRewindIntervalDescription": MessageLookupByLibrary.simpleMessage(
      "How many seconds to skip when rewinding.",
    ),
    "screensSettingsPlayerPlayerSettingsGeneralSubtitle": MessageLookupByLibrary.simpleMessage(
      "Timeline mode, seek intervals, and auto queue behavior.",
    ),
    "screensSettingsPlayerPlayerSettingsGeneralTimelineMarkers": MessageLookupByLibrary.simpleMessage(
      "Timeline markers",
    ),
    "screensSettingsPlayerPlayerSettingsGeneralTimelineMarkersDescription": MessageLookupByLibrary.simpleMessage(
      "Choose whether the full timeline displays chapter markers, bookmark markers, both, or none.",
    ),
    "screensSettingsPlayerPlayerSettingsGeneralTimelineMode": MessageLookupByLibrary.simpleMessage("Timeline mode"),
    "screensSettingsPlayerPlayerSettingsGeneralTimelineModeDescription": MessageLookupByLibrary.simpleMessage(
      "Choose whether the seek bar tracks a chapter, the full audiobook, or both.",
    ),
    "screensSettingsPlayerPlayerSettingsGeneralTitle": MessageLookupByLibrary.simpleMessage("Player - General"),
    "screensSettingsPlayerPlayerSettingsPlayback": MessageLookupByLibrary.simpleMessage("Playback"),
    "screensSettingsPlayerPlayerSettingsShakeControls": MessageLookupByLibrary.simpleMessage("Shake controls"),
    "screensSettingsPlayerPlayerSettingsShakeControlsSupportedSubtitle": MessageLookupByLibrary.simpleMessage(
      "Configure shake gestures and sensitivity.",
    ),
    "screensSettingsPlayerPlayerSettingsShakeControlsTitle": MessageLookupByLibrary.simpleMessage(
      "Player - Shake Controls",
    ),
    "screensSettingsPlayerPlayerSettingsShakeControlsUnavailableOnThisDevice": MessageLookupByLibrary.simpleMessage(
      "Shake controls are not available on this device.",
    ),
    "screensSettingsPlayerPlayerSettingsShakeControlsUnsupportedReason": MessageLookupByLibrary.simpleMessage(
      "This device does not support shake controls.",
    ),
    "screensSettingsPlayerPlayerSettingsShakeControlsUnsupportedSubtitle": MessageLookupByLibrary.simpleMessage(
      "Available on devices with motion sensors.",
    ),
    "screensSettingsPlayerPlayerSettingsSleepTimer": MessageLookupByLibrary.simpleMessage("Sleep timer"),
    "screensSettingsPlayerPlayerSettingsSleepTimerAfterSleepTimerStopsPlaybackRewindThis":
        MessageLookupByLibrary.simpleMessage(
          "After sleep timer stops playback, rewind this much when the same item is played again.",
        ),
    "screensSettingsPlayerPlayerSettingsSleepTimerAutorestartRangeEnd": MessageLookupByLibrary.simpleMessage(
      "Auto-restart range end",
    ),
    "screensSettingsPlayerPlayerSettingsSleepTimerAutorestartRangeStart": MessageLookupByLibrary.simpleMessage(
      "Auto-restart range start",
    ),
    "screensSettingsPlayerPlayerSettingsSleepTimerAutorestartTimerOnPlaybackStart":
        MessageLookupByLibrary.simpleMessage("Auto-restart timer on playback start"),
    "screensSettingsPlayerPlayerSettingsSleepTimerChooseWhetherPlaybackIsStoppedOrPausedWhen":
        MessageLookupByLibrary.simpleMessage(
          "Choose whether playback is stopped or paused when the sleep timer expires.",
        ),
    "screensSettingsPlayerPlayerSettingsSleepTimerEnableAutorestartAndTimeRangeTo":
        MessageLookupByLibrary.simpleMessage("Enable auto-restart and time range to configure this option."),
    "screensSettingsPlayerPlayerSettingsSleepTimerEnableAutorestartToConfigureThisOption":
        MessageLookupByLibrary.simpleMessage("Enable auto-restart to configure this option."),
    "screensSettingsPlayerPlayerSettingsSleepTimerLimitAutomaticSleepTimerRestartToSpecific":
        MessageLookupByLibrary.simpleMessage("Limit automatic sleep timer restart to specific hours."),
    "screensSettingsPlayerPlayerSettingsSleepTimerM005": MessageLookupByLibrary.simpleMessage("5 min"),
    "screensSettingsPlayerPlayerSettingsSleepTimerM010": MessageLookupByLibrary.simpleMessage("10 min"),
    "screensSettingsPlayerPlayerSettingsSleepTimerM015": MessageLookupByLibrary.simpleMessage("15 min"),
    "screensSettingsPlayerPlayerSettingsSleepTimerM030": MessageLookupByLibrary.simpleMessage("30 min"),
    "screensSettingsPlayerPlayerSettingsSleepTimerOff": MessageLookupByLibrary.simpleMessage("Off"),
    "screensSettingsPlayerPlayerSettingsSleepTimerOnlyAutorestartDuringATimeRange":
        MessageLookupByLibrary.simpleMessage("Only auto-restart during a time range"),
    "screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerAutorestartBecomesActiveAt":
        MessageLookupByLibrary.simpleMessage("Sleep timer auto-restart becomes active at this time."),
    "screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerAutorestartRemainsActiveUntil":
        MessageLookupByLibrary.simpleMessage("Sleep timer auto-restart remains active until this time."),
    "screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerEndAction": MessageLookupByLibrary.simpleMessage(
      "Sleep timer end action",
    ),
    "screensSettingsPlayerPlayerSettingsSleepTimerSleepTimerEndRewind": MessageLookupByLibrary.simpleMessage(
      "Sleep timer end rewind",
    ),
    "screensSettingsPlayerPlayerSettingsSleepTimerSubtitle": MessageLookupByLibrary.simpleMessage(
      "Choose timer end behavior and optional automatic restart.",
    ),
    "screensSettingsPlayerPlayerSettingsSleepTimerTitle": MessageLookupByLibrary.simpleMessage("Player - Sleep Timer"),
    "screensSettingsPlayerPlayerSettingsSleepTimerWhenPlaybackStartsAndNoTimerIs": MessageLookupByLibrary.simpleMessage(
      "When playback starts and no timer is active, automatically start a new sleep timer using your last duration.",
    ),
    "screensSettingsPlayerPlayerSettingsSmartRewind": MessageLookupByLibrary.simpleMessage("Smart rewind"),
    "screensSettingsPlayerPlayerSettingsSmartRewindEnableSmartRewindDisabledReason":
        MessageLookupByLibrary.simpleMessage("Enable Smart rewind to configure this option."),
    "screensSettingsPlayerPlayerSettingsSmartRewindLongPauseThreshold": MessageLookupByLibrary.simpleMessage(
      "Long-pause threshold",
    ),
    "screensSettingsPlayerPlayerSettingsSmartRewindLongPauseThresholdDescription": MessageLookupByLibrary.simpleMessage(
      "If paused longer than the short threshold and up to this amount, the medium smart rewind value is used. Longer pauses use the long smart rewind value.",
    ),
    "screensSettingsPlayerPlayerSettingsSmartRewindLongRewindAmount": MessageLookupByLibrary.simpleMessage(
      "Long rewind amount",
    ),
    "screensSettingsPlayerPlayerSettingsSmartRewindLongRewindAmountDescription": MessageLookupByLibrary.simpleMessage(
      "Rewind amount used for long pauses.",
    ),
    "screensSettingsPlayerPlayerSettingsSmartRewindMediumRewindAmount": MessageLookupByLibrary.simpleMessage(
      "Medium rewind amount",
    ),
    "screensSettingsPlayerPlayerSettingsSmartRewindMediumRewindAmountDescription": MessageLookupByLibrary.simpleMessage(
      "Rewind amount used for medium pauses.",
    ),
    "screensSettingsPlayerPlayerSettingsSmartRewindShortPauseThreshold": MessageLookupByLibrary.simpleMessage(
      "Short-pause threshold",
    ),
    "screensSettingsPlayerPlayerSettingsSmartRewindShortPauseThresholdDescription":
        MessageLookupByLibrary.simpleMessage("If paused up to this amount, the short smart rewind value is used."),
    "screensSettingsPlayerPlayerSettingsSmartRewindShortRewindAmount": MessageLookupByLibrary.simpleMessage(
      "Short rewind amount",
    ),
    "screensSettingsPlayerPlayerSettingsSmartRewindShortRewindAmountDescription": MessageLookupByLibrary.simpleMessage(
      "Rewind amount used for short pauses.",
    ),
    "screensSettingsPlayerPlayerSettingsSmartRewindSmartRewind": MessageLookupByLibrary.simpleMessage("Smart rewind"),
    "screensSettingsPlayerPlayerSettingsSmartRewindSmartRewindDescription": MessageLookupByLibrary.simpleMessage(
      "When playback is resumed after a pause, rewind by an amount based on how long playback was paused.",
    ),
    "screensSettingsPlayerPlayerSettingsSmartRewindSubtitle": MessageLookupByLibrary.simpleMessage(
      "Control how much playback rewinds after pauses.",
    ),
    "screensSettingsPlayerPlayerSettingsSmartRewindTitle": MessageLookupByLibrary.simpleMessage(
      "Player - Smart Rewind",
    ),
    "screensSettingsPlayerPlayerSettingsSubtitles": MessageLookupByLibrary.simpleMessage("Subtitles"),
    "screensSettingsPlayerPlayerSettingsSubtitlesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Enable subtitles and reading support behavior.",
    ),
    "screensSettingsPlayerPlayerSettingsSubtitlesTitle": MessageLookupByLibrary.simpleMessage("Player - Subtitles"),
    "screensSettingsPlayerPlayerSettingsTitle": MessageLookupByLibrary.simpleMessage("Player Settings"),
    "screensSettingsPlayerWidgetsShakeSettingsSectionShakeControls": MessageLookupByLibrary.simpleMessage(
      "Shake Controls",
    ),
    "screensSettingsPlayerWidgetsSubtitleSettingsSectionNoActiveUserSignInTo": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in to configure subtitle settings.",
    ),
    "screensSettingsPlayerWidgetsSubtitleSettingsSectionSubtitles": MessageLookupByLibrary.simpleMessage("Subtitles"),
    "screensSettingsPlayerWidgetsSubtitleSettingsSectionUnableToLoadSubtitleSettings": m192,
    "screensSettingsReaderSettingsReaderSpecificSettingsWillAppearHere": MessageLookupByLibrary.simpleMessage(
      "Reader-specific settings will appear here.",
    ),
    "screensSettingsServerConnectionSettingsCredentialValidationReturnedNoData": MessageLookupByLibrary.simpleMessage(
      "Credential validation returned no data.",
    ),
    "screensSettingsServerConnectionSettingsCredentials": MessageLookupByLibrary.simpleMessage("Credentials"),
    "screensSettingsServerConnectionSettingsCredentialsBelongToDifferentAccountUseAddAccount":
        MessageLookupByLibrary.simpleMessage("Credentials belong to a different account. Use Add Account instead."),
    "screensSettingsServerConnectionSettingsEnterAValidExternalUrl": MessageLookupByLibrary.simpleMessage(
      "Enter a valid external URL.",
    ),
    "screensSettingsServerConnectionSettingsEnterAValidLocalUrlOrLeaveBlank": MessageLookupByLibrary.simpleMessage(
      "Enter a valid local URL or leave blank.",
    ),
    "screensSettingsServerConnectionSettingsEnterPasswordToUpdateUsernameOr": MessageLookupByLibrary.simpleMessage(
      "Enter password to update username or credentials.",
    ),
    "screensSettingsServerConnectionSettingsExternalServerURL": MessageLookupByLibrary.simpleMessage(
      "External Server URL",
    ),
    "screensSettingsServerConnectionSettingsFailedToLoadUser": m193,
    "screensSettingsServerConnectionSettingsFailedToSaveServerSettings": m194,
    "screensSettingsServerConnectionSettingsFailedToSaveServerSettingsPlain": MessageLookupByLibrary.simpleMessage(
      "Failed to save server settings.",
    ),
    "screensSettingsServerConnectionSettingsHttp19216812513378": MessageLookupByLibrary.simpleMessage(
      "http://192.168.1.25:13378",
    ),
    "screensSettingsServerConnectionSettingsHttpsYourAudiobookshelfExample": MessageLookupByLibrary.simpleMessage(
      "https://your-audiobookshelf.example",
    ),
    "screensSettingsServerConnectionSettingsLeavePasswordEmptyToKeepCurrent": MessageLookupByLibrary.simpleMessage(
      "Leave password empty to keep current credentials and update only server URLs.",
    ),
    "screensSettingsServerConnectionSettingsLocalServerURLOptional": MessageLookupByLibrary.simpleMessage(
      "Local Server URL (Optional)",
    ),
    "screensSettingsServerConnectionSettingsNoActiveUserSignInBefore": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in before editing server settings.",
    ),
    "screensSettingsServerConnectionSettingsPassword": MessageLookupByLibrary.simpleMessage("Password"),
    "screensSettingsServerConnectionSettingsPleaseEnterAValidExternalServer": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid external server URL.",
    ),
    "screensSettingsServerConnectionSettingsPleaseEnterAValidLocalServer": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid local server URL or leave it blank.",
    ),
    "screensSettingsServerConnectionSettingsRequiredOnlyWhenChangingCredentials": MessageLookupByLibrary.simpleMessage(
      "Required only when changing credentials",
    ),
    "screensSettingsServerConnectionSettingsServerEndpoints": MessageLookupByLibrary.simpleMessage("Server Endpoints"),
    "screensSettingsServerConnectionSettingsServerSettingsSaved": MessageLookupByLibrary.simpleMessage(
      "Server settings saved.",
    ),
    "screensSettingsServerConnectionSettingsTheAppWillTryLocalFirst": MessageLookupByLibrary.simpleMessage(
      "The app will try local first and fall back to external when local is unreachable.",
    ),
    "screensSettingsServerConnectionSettingsTitle": MessageLookupByLibrary.simpleMessage("Server Connection"),
    "screensSettingsServerConnectionSettingsUsername": MessageLookupByLibrary.simpleMessage("Username"),
    "screensSettingsServerConnectionSettingsUsernameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Username cannot be empty.",
    ),
    "screensSettingsServerManagementSettingsFailedToLoadUserSettings": m195,
    "screensSettingsServerManagementSettingsNoActiveUserSignInTo": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in to manage server management visibility settings.",
    ),
    "screensSettingsSettingsPageScaffoldBack": MessageLookupByLibrary.simpleMessage("Back"),
    "screensSettingsSettingsScreenAboutAndSupport": MessageLookupByLibrary.simpleMessage("About & Support"),
    "screensSettingsSettingsScreenActiveACCOUNT": MessageLookupByLibrary.simpleMessage("ACTIVE ACCOUNT"),
    "screensSettingsSettingsScreenAddAccount": MessageLookupByLibrary.simpleMessage("Add Account"),
    "screensSettingsSettingsScreenAppearance": MessageLookupByLibrary.simpleMessage("Appearance"),
    "screensSettingsSettingsScreenApplicationSettings": MessageLookupByLibrary.simpleMessage("Application Settings"),
    "screensSettingsSettingsScreenAreYouSureYouWantTo": m196,
    "screensSettingsSettingsScreenCaching": MessageLookupByLibrary.simpleMessage("Caching"),
    "screensSettingsSettingsScreenCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "screensSettingsSettingsScreenCarIntegration": MessageLookupByLibrary.simpleMessage("Car Integration"),
    "screensSettingsSettingsScreenCurrentAccount": MessageLookupByLibrary.simpleMessage("Current Account"),
    "screensSettingsSettingsScreenDelete": MessageLookupByLibrary.simpleMessage("Delete"),
    "screensSettingsSettingsScreenDeleteThisUser": MessageLookupByLibrary.simpleMessage("Delete this user"),
    "screensSettingsSettingsScreenDeleteUser": MessageLookupByLibrary.simpleMessage("Delete User?"),
    "screensSettingsSettingsScreenDeletedUser": m197,
    "screensSettingsSettingsScreenEbookReaderSettings": MessageLookupByLibrary.simpleMessage("Ebook-Reader Settings"),
    "screensSettingsSettingsScreenErrorLoadingUserData": m198,
    "screensSettingsSettingsScreenFailedToDeleteUser": m199,
    "screensSettingsSettingsScreenGlobalPlayer": MessageLookupByLibrary.simpleMessage("Global Player"),
    "screensSettingsSettingsScreenInformationAndAttribution": MessageLookupByLibrary.simpleMessage(
      "Information & Attribution",
    ),
    "screensSettingsSettingsScreenLibraryBehaviour": MessageLookupByLibrary.simpleMessage("Library Behaviour"),
    "screensSettingsSettingsScreenLicensesAppVersionAndAttribution": MessageLookupByLibrary.simpleMessage(
      "Licenses, app version, and attribution details.",
    ),
    "screensSettingsSettingsScreenLogs": MessageLookupByLibrary.simpleMessage("Logs"),
    "screensSettingsSettingsScreenManageAccounts": MessageLookupByLibrary.simpleMessage("Manage Accounts"),
    "screensSettingsSettingsScreenNavigateToReportAnIssue": MessageLookupByLibrary.simpleMessage(
      "Navigate to Report an Issue",
    ),
    "screensSettingsSettingsScreenNavigateToViewOnGitHub": MessageLookupByLibrary.simpleMessage(
      "Navigate to View on GitHub",
    ),
    "screensSettingsSettingsScreenNoActiveUser": MessageLookupByLibrary.simpleMessage("No active user."),
    "screensSettingsSettingsScreenNoOtherAccountsAvailable": MessageLookupByLibrary.simpleMessage(
      "No other accounts available.",
    ),
    "screensSettingsSettingsScreenNoServer": MessageLookupByLibrary.simpleMessage("No server"),
    "screensSettingsSettingsScreenOpenCarLibrary": MessageLookupByLibrary.simpleMessage("Open Car Library"),
    "screensSettingsSettingsScreenOtherAccounts": MessageLookupByLibrary.simpleMessage("Other Accounts"),
    "screensSettingsSettingsScreenReportAnIssue": MessageLookupByLibrary.simpleMessage("Report an Issue"),
    "screensSettingsSettingsScreenSignOut": MessageLookupByLibrary.simpleMessage("Sign Out"),
    "screensSettingsSettingsScreenSignOutCurrentAccount": MessageLookupByLibrary.simpleMessage(
      "Sign Out Current Account?",
    ),
    "screensSettingsSettingsScreenSignOutFromOnThisDevice": m200,
    "screensSettingsSettingsScreenSignOutThisAccount": MessageLookupByLibrary.simpleMessage("Sign out this account"),
    "screensSettingsSettingsScreenSwitchToTheSystemMediaCenter": MessageLookupByLibrary.simpleMessage(
      "Switch to the system Media Center",
    ),
    "screensSettingsSettingsScreenSwitchToThisUser": MessageLookupByLibrary.simpleMessage("Switch to this user"),
    "screensSettingsSettingsScreenSwitchedTo": m201,
    "screensSettingsSettingsScreenViewOnGitHub": MessageLookupByLibrary.simpleMessage("View on GitHub"),
    "screensSettingsThemeSettingsTitle": MessageLookupByLibrary.simpleMessage("Theme"),
    "screensSettingsToolsSettingsFailedToLoadUserSettings": m202,
    "screensSettingsToolsSettingsNoActiveUserSignInTo": MessageLookupByLibrary.simpleMessage(
      "No active user. Sign in to configure tools.",
    ),
    "screensSettingsToolsSettingsTheseToolsAddFunctionalityBeyondStandard": MessageLookupByLibrary.simpleMessage(
      "These tools add functionality beyond standard ABS behavior. They coordinate multiple API calls to accomplish a task, so edge cases can happen. All tools are disabled by default. Enabling a tool can add controls to the UI, while other tools live only in subpages below.",
    ),
    "seriesDetailErrorLoadingSeriesBooks": MessageLookupByLibrary.simpleMessage("Error loading series books"),
    "serverStatusReachability": m203,
    "settingsLogViewAppStorageFallbackLocation": MessageLookupByLibrary.simpleMessage("app storage fallback location"),
    "settingsLogViewEntriesCount": m204,
    "settingsLogViewExportLog": MessageLookupByLibrary.simpleMessage("Export .log"),
    "settingsLogViewExportingLog": MessageLookupByLibrary.simpleMessage("Exporting .log..."),
    "settingsLogViewSelectedLocation": MessageLookupByLibrary.simpleMessage("selected location"),
    "settingsLogViewSummaryLogs": m205,
    "settingsLogViewTitle": MessageLookupByLibrary.simpleMessage("Logs"),
    "statsAdvancedLongestStreakDays": m206,
    "taskNotificationNoTasksRunning": MessageLookupByLibrary.simpleMessage("No tasks are currently running."),
    "taskNotificationTasksRunning": m207,
  };
}
