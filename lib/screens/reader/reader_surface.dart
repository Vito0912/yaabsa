part of 'reader.dart';

extension _ReaderSurface on _ReaderState {
  Widget _buildReaderSurface({
    required AsyncValue<LibraryItem> itemAsync,
    required AsyncValue<User?> userAsync,
    required String? effectiveInitialLocation,
    required bool isEpubMode,
    required bool hideMiniPlayerSetting,
  }) {
    return StreamBuilder<bool>(
      stream: audioHandler.shouldShowPlayer,
      initialData: audioHandler.shouldShowPlayerNow,
      builder: (context, snapshot) => _buildReaderScaffold(
        itemAsync: itemAsync,
        userAsync: userAsync,
        effectiveInitialLocation: effectiveInitialLocation,
        isEpubMode: isEpubMode,
        showMiniPlayer: (!hideMiniPlayerSetting || _isMediaOverlayActive || _isTtsPlaying) && snapshot.data == true,
      ),
    );
  }

  Widget _buildReaderScaffold({
    required AsyncValue<LibraryItem> itemAsync,
    required AsyncValue<User?> userAsync,
    required String? effectiveInitialLocation,
    required bool isEpubMode,
    required bool showMiniPlayer,
  }) {
    final title = itemAsync.asData?.value.media?.title ?? 'Your book';

    return Theme(
      data: _readerThemeData,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: _readerColors.surface,
        drawer: _buildDrawer(isEpubMode: isEpubMode, title: title),
        onDrawerChanged: (open) => _isNavigationOpen = open,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.paddingOf(context).top + (_isSystemUiVisible || !_isBookReady ? 56 : 12),
                          bottom: _isSystemUiVisible ? 4 : 12,
                        ),
                        child: itemAsync.when(
                          data: (item) {
                            return userAsync.when(
                              data: (user) {
                                if (user == null) {
                                  return const Center(child: Text('No authenticated user available.'));
                                }

                                if (_loadingLocalFile) {
                                  return const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 16),
                                        Text('Loading local ebook files...'),
                                      ],
                                    ),
                                  );
                                }

                                final authToken = user.preferredAuthToken;

                                if (authToken == null || authToken.isEmpty) {
                                  return const Center(child: Text('Missing authentication token for ebook loading.'));
                                }

                                final mode = _resolveReaderMode(item);

                                if (mode == _ReaderRenderMode.pdf) {
                                  return _buildPdfReaderBody(
                                    user: user,
                                    authToken: authToken,
                                    initialLocation: effectiveInitialLocation,
                                    pdfFile: _localEbookFile,
                                  );
                                }

                                final format = _normalizeEbookFormat(
                                  item.media?.bookMedia?.ebookFile?.ebookFormat ??
                                      item.media?.bookMedia?.ebookFormat ??
                                      item.media?.bookMedia?.ebookFile?.metadata.ext,
                                );
                                final bookExtension = format.isNotEmpty ? format : 'epub';

                                return _buildEpubReaderBody(
                                  user: user,
                                  authToken: authToken,
                                  initialCfi: effectiveInitialLocation,
                                  bookExtension: bookExtension,
                                  bookFile: _localEbookFile,
                                );
                              },
                              error: (error, stackTrace) {
                                return Center(child: Text('Failed to load user profile: $error'));
                              },
                              loading: () {
                                return const Center(child: CircularProgressIndicator());
                              },
                            );
                          },
                          error: (error, stackTrace) {
                            return Center(child: Text('Failed to load ebook metadata: $error'));
                          },
                          loading: () {
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
                    _buildTopBar(isEpubMode: isEpubMode, title: title),
                  ],
                ),
              ),
              _buildProgressControls(isEpubMode: isEpubMode, showMiniPlayer: showMiniPlayer),
              if (showMiniPlayer) const PlayBar(includeBottomSafeArea: true, attachedToBottom: true),
            ],
          ),
        ),
      ),
    );
  }
}
