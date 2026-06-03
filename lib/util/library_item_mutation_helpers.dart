import 'package:yaabsa/provider/common/library_item_events.dart';

bool mutationAffectsSeriesList(LibraryItemMutation mutation) {
  final oldSeries = mutation.previousItem?.seriesName;
  final newSeries = mutation.item?.seriesName;
  if (oldSeries != newSeries) {
    return true;
  }

  if (mutation.type == LibraryItemMutationType.added && newSeries != null) {
    return true;
  }

  if (mutation.type == LibraryItemMutationType.removed && oldSeries != null) {
    return true;
  }

  return false;
}

bool mutationAffectsSeries(LibraryItemMutation mutation, String seriesId) {
  final oldHasSeries = mutation.previousItem?.media?.bookMedia?.metadata.series?.any((s) => s.id == seriesId) ?? false;
  final newHasSeries = mutation.item?.media?.bookMedia?.metadata.series?.any((s) => s.id == seriesId) ?? false;

  if (oldHasSeries || newHasSeries) {
    return true;
  }

  return false;
}

bool mutationAffectsAuthorsList(LibraryItemMutation mutation) {
  final oldAuthors = mutation.previousItem?.authorString;
  final newAuthors = mutation.item?.authorString;
  if (oldAuthors != newAuthors) {
    return true;
  }

  if (mutation.type == LibraryItemMutationType.added && newAuthors != null) {
    return true;
  }

  if (mutation.type == LibraryItemMutationType.removed && oldAuthors != null) {
    return true;
  }

  return false;
}

bool mutationAffectsAuthor(LibraryItemMutation mutation, String authorId) {
  final oldHasAuthor = mutation.previousItem?.media?.bookMedia?.metadata.authors?.any((a) => a.id == authorId) ?? false;
  final newHasAuthor = mutation.item?.media?.bookMedia?.metadata.authors?.any((a) => a.id == authorId) ?? false;

  if (oldHasAuthor || newHasAuthor) {
    return true;
  }

  return false;
}
