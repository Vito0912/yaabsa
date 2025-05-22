import 'package:buchshelfly/api/me/user.dart';
import 'package:buchshelfly/provider/common/media_progress_provider.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epub_reader/flutter_epub_reader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Reader extends StatefulWidget {
  const Reader({super.key, required this.itemId});

  final String itemId;

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  final EpubController epubController = EpubController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ebook Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final User user = ref.watch(currentUserProvider).value!;
          final currentProgress = ref.read(
            mediaProgressNotifierProvider.select((asyncValue) {
              return asyncValue.value?[widget.itemId];
            }),
          );

          final EpubSource epubSource = EpubSource.fromUrl(
            '${user.server!.url}/api/items/${widget.itemId}/ebook',
            headers: {'Authorization': 'Bearer ${user.token}'},
            isCachedToLocal: false,
          );

          return Column(
            children: [
              Expanded(
                child: Listener(
                  onPointerSignal: (pointerSignal) {
                    if (pointerSignal is PointerScrollEvent) {
                      if (pointerSignal.scrollDelta.dy > 0) {
                        epubController.next();
                      } else if (pointerSignal.scrollDelta.dy < 0) {
                        epubController.prev();
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      EpubViewer(
                        epubController: epubController,
                        epubSource: epubSource,
                        initialCfi: currentProgress?.ebookLocation,
                        displaySettings: EpubDisplaySettings(
                          flow: EpubFlow.paginated,
                          snap: true,
                          spread: EpubSpread.auto,
                          useSnapAnimationAndroid: true,
                          theme: EpubTheme(themeType: EpubThemeType.dark),
                        ),
                        onRelocated: (cfi) {},
                        selectionContextMenu: ContextMenu(
                          menuItems: [ContextMenuItem(title: 'Copy', id: 1, action: () {})],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 120,
                                width: 40,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      epubController.prev();
                                    },
                                    child: const Center(child: Icon(Icons.arrow_back, color: Colors.black)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 120,
                                width: 40,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      epubController.next();
                                    },
                                    child: const Center(child: Icon(Icons.arrow_forward, color: Colors.black)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
