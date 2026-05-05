import 'package:flutter/material.dart';

class LibraryTargetPickerOption {
  const LibraryTargetPickerOption({required this.id, required this.title, this.subtitle});

  final String id;
  final String title;
  final String? subtitle;
}

typedef LibraryTargetOptionsLoader = Future<List<LibraryTargetPickerOption>> Function();

Future<LibraryTargetPickerOption?> showLibraryTargetPickerSheet({
  required BuildContext context,
  required String title,
  List<LibraryTargetPickerOption> options = const <LibraryTargetPickerOption>[],
  LibraryTargetOptionsLoader? loadOptions,
  required String emptyMessage,
  String loadErrorMessage = 'Could not load options.',
}) {
  assert(options.isNotEmpty || loadOptions != null, 'Provide either options or loadOptions.');

  final maxHeight = MediaQuery.of(context).size.height * 0.7;

  return showModalBottomSheet<LibraryTargetPickerOption>(
    context: context,
    useSafeArea: true,
    builder: (sheetContext) {
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: loadOptions == null
              ? _LibraryTargetPickerListContent(
                  title: title,
                  options: options,
                  emptyMessage: emptyMessage,
                  onSelected: (option) => Navigator.of(sheetContext).pop(option),
                )
              : _LibraryTargetPickerAsyncContent(
                  title: title,
                  emptyMessage: emptyMessage,
                  loadErrorMessage: loadErrorMessage,
                  loadOptions: loadOptions,
                  onSelected: (option) => Navigator.of(sheetContext).pop(option),
                ),
        ),
      );
    },
  );
}

class _LibraryTargetPickerAsyncContent extends StatefulWidget {
  const _LibraryTargetPickerAsyncContent({
    required this.title,
    required this.emptyMessage,
    required this.loadErrorMessage,
    required this.loadOptions,
    required this.onSelected,
  });

  final String title;
  final String emptyMessage;
  final String loadErrorMessage;
  final LibraryTargetOptionsLoader loadOptions;
  final ValueChanged<LibraryTargetPickerOption> onSelected;

  @override
  State<_LibraryTargetPickerAsyncContent> createState() => _LibraryTargetPickerAsyncContentState();
}

class _LibraryTargetPickerAsyncContentState extends State<_LibraryTargetPickerAsyncContent> {
  late Future<List<LibraryTargetPickerOption>> _optionsFuture;

  @override
  void initState() {
    super.initState();
    _optionsFuture = widget.loadOptions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LibraryTargetPickerOption>>(
      future: _optionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _LibraryTargetPickerLoadingContent(title: widget.title);
        }

        if (snapshot.hasError) {
          return _LibraryTargetPickerErrorContent(
            title: widget.title,
            message: widget.loadErrorMessage,
            onRetry: () {
              setState(() {
                _optionsFuture = widget.loadOptions();
              });
            },
          );
        }

        return _LibraryTargetPickerListContent(
          title: widget.title,
          options: snapshot.data ?? const <LibraryTargetPickerOption>[],
          emptyMessage: widget.emptyMessage,
          onSelected: widget.onSelected,
        );
      },
    );
  }
}

class _LibraryTargetPickerListContent extends StatelessWidget {
  const _LibraryTargetPickerListContent({
    required this.title,
    required this.options,
    required this.emptyMessage,
    required this.onSelected,
  });

  final String title;
  final List<LibraryTargetPickerOption> options;
  final String emptyMessage;
  final ValueChanged<LibraryTargetPickerOption> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(title: Text(title, style: Theme.of(context).textTheme.titleMedium)),
        const Divider(height: 1),
        Expanded(
          child: options.isEmpty
              ? Center(child: Text(emptyMessage, textAlign: TextAlign.center))
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final subtitle = option.subtitle?.trim();

                    return ListTile(
                      title: Text(option.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: subtitle == null || subtitle.isEmpty
                          ? null
                          : Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _LibraryTargetPickerLoadingContent extends StatelessWidget {
  const _LibraryTargetPickerLoadingContent({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(title: Text(title, style: Theme.of(context).textTheme.titleMedium)),
        const Divider(height: 1),
        Expanded(
          child: _LibraryTargetShimmer(
            child: ListView.separated(
              itemCount: 7,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, _) => const _LibraryTargetShimmerTile(),
            ),
          ),
        ),
      ],
    );
  }
}

class _LibraryTargetPickerErrorContent extends StatelessWidget {
  const _LibraryTargetPickerErrorContent({required this.title, required this.message, required this.onRetry});

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(title: Text(title, style: Theme.of(context).textTheme.titleMedium)),
        const Divider(height: 1),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LibraryTargetShimmer extends StatefulWidget {
  const _LibraryTargetShimmer({required this.child});

  final Widget child;

  @override
  State<_LibraryTargetShimmer> createState() => _LibraryTargetShimmerState();
}

class _LibraryTargetShimmerState extends State<_LibraryTargetShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final base = colorScheme.surfaceContainerHighest;
    final highlight = colorScheme.surface;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final position = (_controller.value * 2) - 1;

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(position - 1, 0),
              end: Alignment(position + 1, 0),
              colors: <Color>[base, highlight, base],
              stops: const <double>[0.35, 0.5, 0.65],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class _LibraryTargetShimmerTile extends StatelessWidget {
  const _LibraryTargetShimmerTile();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;

    return ListTile(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 180,
          height: 12,
          decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(8)),
        ),
      ),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 120,
          height: 10,
          decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
