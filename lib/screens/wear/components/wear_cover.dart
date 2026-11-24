import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/cover_zoom_view.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/wear/components/wear_activity_scope.dart';
import 'package:yaabsa/util/network/request_headers.dart';

class WearCover extends ConsumerWidget {
  const WearCover({
    required this.uri,
    this.size = 40,
    this.icon = Icons.headphones,
    this.background = false,
    this.circular = false,
    super.key,
  });

  final Uri? uri;
  final double size;
  final IconData icon;
  final bool background;
  final bool circular;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final placeholder = ColoredBox(
      color: colors.surfaceContainerHigh,
      child: Center(
        child: Icon(icon, size: size * 0.48, color: colors.onSurfaceVariant),
      ),
    );
    final active = WearActivityScope.isActive(context) && (ModalRoute.isCurrentOf(context) ?? true);
    final user = ref.watch(currentUserProvider).value;
    final pixels = (size * MediaQuery.devicePixelRatioOf(context)).ceil().clamp(64, 256);
    var artwork = uri;
    if (artwork != null &&
        (artwork.scheme == 'http' || artwork.scheme == 'https') &&
        RegExp(r'/api/items/[^/]+/cover/?$').hasMatch(artwork.path)) {
      artwork = artwork.replace(queryParameters: {...artwork.queryParameters, 'width': '$pixels', 'height': '$pixels'});
    }

    final server = Uri.tryParse(user?.server?.url ?? '');
    final sameServer =
        artwork != null &&
        server != null &&
        artwork.scheme == server.scheme &&
        artwork.host == server.host &&
        artwork.port == server.port;
    final headers = sameServer
        ? buildRequestHeaders(serverHeaders: user?.server?.headers, bearerToken: user?.preferredAuthToken)
        : const <String, String>{};
    final source = active ? coverImageProviderFromUri(artwork, requestHeaders: headers) : null;
    final image = source == null
        ? (background ? const ColoredBox(color: Colors.black) : placeholder)
        : Image(
            image: ResizeImage(source, width: pixels, height: pixels, policy: ResizeImagePolicy.fit),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) => placeholder,
          );
    if (background) {
      return ExcludeSemantics(child: SizedBox.expand(child: image));
    }
    var radius = size > 64 ? 24.0 : 14.0;
    if (circular) {
      radius = size / 2;
    }

    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox.square(dimension: size, child: image),
      ),
    );
  }
}
