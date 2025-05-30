import 'dart:convert';

import 'package:buchshelfly/api/me/bookmark.dart';
import 'package:buchshelfly/api/me/request/create_bookmark_request.dart';
import 'package:buchshelfly/api/me/user.dart';
import 'package:buchshelfly/api/routes/abs_api.dart';
import 'package:buchshelfly/models/internal_annotation.dart';
import 'package:buchshelfly/provider/common/media_progress_provider.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epub_reader/flutter_epub_reader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<Color> _kHighlightColors = [
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.pink,
  Colors.orange,
  Colors.purple,
  Colors.transparent,
];

const List<double> _kUnderlineThickness = [1.0, 2.0, 3.0, 4.0, 6.0];

const Duration _kSnackBarDuration = Duration(seconds: 2);

class Reader extends ConsumerStatefulWidget {
  const Reader({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<Reader> createState() => _ReaderState();
}

class _ReaderState extends ConsumerState<Reader> {
  final EpubController epubController = EpubController();
  String? _selectedCfi;
  String? _selectedText;

  String _colorToHex(Color color, {bool allowNone = false}) {
    if (allowNone && color == Colors.transparent) return 'none';
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: _kSnackBarDuration));
  }

  bool get _hasValidSelection => _selectedCfi != null && _selectedText != null;

  void _showAnnotationsList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => _AnnotationsListView(epubController: epubController),
    );
  }

  void _showColorPicker({required bool isHighlight}) {
    if (!_hasValidSelection) {
      _showSnackBar('Please select some text first');
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder:
          (context) => _ColorPickerSheet(
            isHighlight: isHighlight,
            colors: isHighlight ? _kHighlightColors.sublist(0, _kHighlightColors.length - 1) : _kHighlightColors,
            onColorSelected: (color) {
              Navigator.pop(context);
              if (isHighlight) {
                _toggleHighlight(_selectedCfi!, _selectedText!, color);
              } else {
                _showThicknessPicker(color: color);
              }
            },
          ),
    );
  }

  void _showThicknessPicker({required Color color}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder:
          (context) => _ThicknessPickerSheet(
            color: color,
            thicknesses: _kUnderlineThickness,
            onThicknessSelected: (thickness) {
              Navigator.pop(context);
              _toggleUnderline(_selectedCfi!, _selectedText!, color, thickness);
            },
          ),
    );
  }

  Future<void> _toggleHighlight(String cfi, String text, Color color) async {
    try {
      final highlights = await epubController.getHighlights();
      final existingHighlight = highlights.where((h) => h.cfi == cfi).firstOrNull;

      if (existingHighlight != null) {
        epubController.removeHighlight(cfi);
      } else {
        epubController.addHighlight(EpubHighlight(cfi: cfi, text: '', color: _colorToHex(color), opacity: 0.5));
      }
    } catch (e) {
      _showSnackBar('Error toggling highlight: $e');
    }

    _clearSelection();
  }

  Future<void> _toggleUnderline(String cfi, String text, Color color, double thickness) async {
    try {
      final underlines = await epubController.getUnderlines();
      final existingUnderline = underlines.where((u) => u.cfi == cfi).firstOrNull;

      if (existingUnderline != null) {
        epubController.removeUnderline(cfi);
      } else {
        epubController.addUnderline(
          EpubUnderline(
            cfi: cfi,
            text: '',
            color: _colorToHex(color, allowNone: true),
            opacity: 1.0,
            thickness: thickness,
          ),
        );
      }
    } catch (e) {
      _showSnackBar('Error toggling underline: $e');
    }

    _clearSelection();
  }

  void _clearSelection() {
    setState(() {
      _selectedCfi = null;
      _selectedText = null;
    });
  }

  void _syncAnnotations() async {
    final List<InternalAnnotation> annotations = [
      ...(await epubController.getUnderlines()).map(
        (u) => InternalAnnotation(
          cfi: u.cfi,
          color: u.color,
          text: u.text,
          opacity: u.opacity,
          thickness: u.thickness,
          type: AnnotationType.underline,
        ),
      ),
      ...(await epubController.getBookmarks()).map(
        (u) => InternalAnnotation(cfi: u.cfi, text: u.title, type: AnnotationType.bookmark),
      ),
      ...(await epubController.getHighlights()).map(
        (u) => InternalAnnotation(
          cfi: u.cfi,
          color: u.color,
          text: u.text,
          opacity: u.opacity,
          type: AnnotationType.highlight,
        ),
      ),
    ];

    final ABSApi? api = ref.read(absApiProvider);
    if (api == null) {
      _showSnackBar('API not available');
      return;
    }

    api.getMeApi().createBookmark(
      widget.itemId,
      createBookmarkRequest: CreateBookmarkRequest(time: -1, title: jsonEncode(annotations)),
    );
  }

  _loadAnnotationsFromApi() async {
    final ABSApi? api = ref.read(absApiProvider);
    if (api == null) {
      _showSnackBar('API not available');
      return;
    }

    final User user = ref.read(currentUserProvider).value!;
    final Bookmark? bookmark =
        user.bookmarks?.where((b) => b.libraryItemId == widget.itemId && b.time == -1).firstOrNull;
    if (bookmark == null) {
      _showSnackBar('No annotations found for this item');
      return;
    }
    final List<InternalAnnotation> annotations =
        (jsonDecode(bookmark.title) as List)
            .map((e) => InternalAnnotation.fromJson(e as Map<String, dynamic>))
            .toList();

    for (final highlight in await epubController.getHighlights()) {
      await epubController.removeHighlight(highlight.cfi);
    }
    for (final underline in await epubController.getUnderlines()) {
      await epubController.removeUnderline(underline.cfi);
    }
    for (final bookmark in await epubController.getBookmarks()) {
      await epubController.removeBookmark(cfi: bookmark.cfi);
    }

    EpubLocation currentLocation = await epubController.getCurrentLocation();

    for (final annotation in annotations) {
      if (annotation.type == AnnotationType.highlight) {
        await epubController.addHighlight(
          EpubHighlight(
            cfi: annotation.cfi,
            text: annotation.text ?? '',
            color: annotation.color ?? 'none',
            opacity: annotation.opacity ?? 0.5,
          ),
        );
      } else if (annotation.type == AnnotationType.underline) {
        await epubController.addUnderline(
          EpubUnderline(
            cfi: annotation.cfi,
            text: annotation.text ?? '',
            color: annotation.color ?? 'none',
            opacity: 1.0,
            thickness: annotation.thickness ?? 1.0,
          ),
        );
      } else if (annotation.type == AnnotationType.bookmark) {
        // Workaround: Bookmark get's added at current position
        await epubController.goTo(cfi: annotation.cfi);
        await epubController.addBookmark(customTitle: annotation.text);
      }
    }

    await epubController.goTo(cfi: currentLocation.startCfi ?? currentLocation.endCfi!);
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Ebook Reader'),
      actions: [
        IconButton(
          icon: Icon(Icons.highlight, color: _selectedText != null ? Colors.yellow : Colors.grey),
          onPressed: () => _showColorPicker(isHighlight: true),
          tooltip: 'Highlight',
        ),
        IconButton(
          icon: Icon(Icons.format_underlined, color: _selectedText != null ? Colors.blue : Colors.grey),
          onPressed: () => _showColorPicker(isHighlight: false),
          tooltip: 'Underline',
        ),
        IconButton(icon: const Icon(Icons.list), onPressed: _showAnnotationsList, tooltip: 'View Annotations'),
        // TODO: Automate sync with server
        IconButton(icon: const Icon(Icons.upload), onPressed: () => _syncAnnotations(), tooltip: 'Sync Annotations'),
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => _loadAnnotationsFromApi(),
          tooltip: 'Load Annotations',
        ),
      ],
    );
  }

  Widget _buildSelectionIndicator() {
    if (_selectedText == null) return const SizedBox.shrink();

    final displayText = _selectedText!.length > 50 ? '${_selectedText!.substring(0, 50)}...' : _selectedText!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: Colors.blue.shade50,
      child: Text(
        'Selected: "$displayText"',
        style: const TextStyle(fontSize: 12, color: Colors.blue, fontStyle: FontStyle.italic),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavigationButton(icon: Icons.arrow_back, onTap: () => epubController.prev()),
            _NavigationButton(icon: Icons.arrow_forward, onTap: () => epubController.next()),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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
                        onRelocated: (location) {
                          ref
                              .read(absApiProvider)!
                              .getMeApi()
                              .updateBookProgress(
                                widget.itemId,
                                epubCfi: location.startCfi ?? location.endCfi!,
                                progress: location.progress,
                              );
                          logger(
                            'Epub relocated: ${location.startCfi ?? location.endCfi!}, progress: ${location.progress}',
                            level: InfoLevel.debug,
                            tag: 'EpubReader',
                          );
                        },
                        onTextSelected: (text) {
                          setState(() {
                            _selectedCfi = text.selectionCfi;
                            _selectedText = text.selectedText;
                          });
                        },
                      ),
                      _buildSelectionIndicator(),
                      _buildNavigationButtons(),
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

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 40,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Center(child: Icon(icon, color: Colors.black)),
        ),
      ),
    );
  }
}

class _ColorPickerSheet extends StatelessWidget {
  const _ColorPickerSheet({required this.isHighlight, required this.colors, required this.onColorSelected});

  final bool isHighlight;
  final List<Color> colors;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isHighlight ? 'Select Highlight Color' : 'Select Border Color',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),
          const Text('Colors:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                colors.map((color) {
                  return GestureDetector(
                    onTap: () => onColorSelected(color),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ThicknessPickerSheet extends StatelessWidget {
  const _ThicknessPickerSheet({required this.color, required this.thicknesses, required this.onThicknessSelected});

  final Color color;
  final List<double> thicknesses;
  final ValueChanged<double> onThicknessSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Border Radius',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 16),
          ...thicknesses.map((thickness) {
            return ListTile(
              title: Text('${thickness.toInt()}px', style: const TextStyle(color: Colors.black)),
              leading: Container(
                width: 40,
                height: thickness,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(thickness / 2)),
              ),
              onTap: () => onThicknessSelected(thickness),
            );
          }),
        ],
      ),
    );
  }
}

class _AnnotationsListView extends StatefulWidget {
  const _AnnotationsListView({required this.epubController});

  final EpubController epubController;

  @override
  State<_AnnotationsListView> createState() => _AnnotationsListViewState();
}

class _AnnotationsListViewState extends State<_AnnotationsListView> {
  List<EpubHighlight> highlights = [];
  List<EpubUnderline> underlines = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnnotations();
  }

  Future<void> _loadAnnotations() async {
    try {
      final [highlightsList, underlinesList] = await Future.wait([
        widget.epubController.getHighlights(),
        widget.epubController.getUnderlines(),
      ]);

      setState(() {
        highlights = highlightsList as List<EpubHighlight>;
        underlines = underlinesList as List<EpubUnderline>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeHighlight(String cfi) async {
    try {
      widget.epubController.removeHighlight(cfi);
      setState(() {
        highlights.removeWhere((h) => h.cfi == cfi);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Highlight removed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error removing highlight: $e')));
    }
  }

  Future<void> _removeUnderline(String cfi) async {
    try {
      widget.epubController.removeUnderline(cfi);
      setState(() {
        underlines.removeWhere((u) => u.cfi == cfi);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Underline removed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error removing underline: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
    }

    final hasAnnotations = highlights.isNotEmpty || underlines.isNotEmpty;

    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Annotations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          if (!hasAnnotations)
            const Expanded(child: Center(child: Text('No annotations found', style: TextStyle(color: Colors.grey))))
          else
            Expanded(
              child: ListView(
                children: [
                  if (highlights.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Highlights',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ),
                    ...highlights.map(
                      (highlight) => _AnnotationTile(
                        type: 'Highlight',
                        cfi: highlight.cfi,
                        color: highlight.color,
                        onRemove: () => _removeHighlight(highlight.cfi),
                      ),
                    ),
                  ],
                  if (underlines.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Underlines',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ),
                    ...underlines.map(
                      (underline) => _AnnotationTile(
                        type: 'Underline',
                        cfi: underline.cfi,
                        color: underline.color,
                        thickness: underline.thickness,
                        onRemove: () => _removeUnderline(underline.cfi),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AnnotationTile extends StatelessWidget {
  const _AnnotationTile({
    required this.type,
    required this.cfi,
    required this.color,
    required this.onRemove,
    this.thickness,
  });

  final String type;
  final String cfi;
  final String color;
  final double? thickness;
  final VoidCallback onRemove;

  Color _parseColor(String colorStr) {
    if (colorStr == 'none') return Colors.transparent;
    if (colorStr.startsWith('#')) {
      return Color(int.parse(colorStr.substring(1), radix: 16) + 0xFF000000);
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final parsedColor = _parseColor(color);

    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: type == 'Highlight' ? parsedColor : Colors.transparent,
          border: type == 'Underline' ? Border(bottom: BorderSide(color: parsedColor, width: thickness ?? 1)) : null,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      title: Text(
        '$type ${thickness != null ? '(${thickness!.toInt()}px)' : ''}',
        style: const TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        'CFI: ${cfi.length > 30 ? '${cfi.substring(0, 30)}...' : cfi}',
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onRemove),
    );
  }
}
