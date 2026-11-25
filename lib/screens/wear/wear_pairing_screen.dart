import 'package:yaabsa/screens/wear/wear_sign_in_screen.dart';
import 'package:yaabsa/provider/wear/wear_sign_in_provider.dart';
import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/provider/wear/wear_providers.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/wear/wear_ambient_view.dart';
import 'package:yaabsa/ui/components/wear/wear_scroll_view.dart';
import 'package:yaabsa/ui/components/wear/wear_swipe_to_dismiss.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/ui/components/wear/wear_page_header.dart';
import 'package:yaabsa/ui/components/wear/wear_browse_button.dart';
import 'package:yaabsa/util/l10n.dart';

class WearPairingScreen extends StatefulWidget {
  const WearPairingScreen({this.isAmbient = false, super.key});

  final bool isAmbient;

  @override
  State<WearPairingScreen> createState() => _WearPairingScreenState();
}

class _WearPairingScreenState extends State<WearPairingScreen> {
  bool _isRequesting = false;
  String? _errorMessage;
  final _cancelToken = CancelToken();

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  Future<void> _requestCredentials() async {
    setState(() {
      _isRequesting = true;
      _errorMessage = null;
    });

    try {
      final result = await pairWithPhone(cancelToken: _cancelToken);

      if (!mounted) {
        return;
      }

      if (result == WearPairingResult.noPhone) {
        setState(() {
          _errorMessage = context.l10n.wearPairingNoPhoneConnected;
        });
      } else if (result == WearPairingResult.noResponse) {
        setState(() {
          _errorMessage = context.l10n.wearPairingNoPhoneResponse;
        });
      }
      // On success the home screen switches to the player via the
      // active-user providers; nothing to do here.
    } catch (e, stack) {
      // DioException.message is null for transport failures; the actual
      // cause (socket, TLS, Cronet error) is in DioException.error.
      final detail = e is DioException ? '${e.type.name}: ${e.error ?? e.message}' : '$e';
      logger('Wear pairing failed: $detail\n$stack', tag: 'WearPairing', level: InfoLevel.error);
      if (mounted) {
        setState(() {
          _errorMessage = wearRequestError(e);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequesting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return WearSwipeToDismiss(
      child: Scaffold(
        body: widget.isAmbient
            ? const WearAmbientView()
            : WearScrollView(
                children: [
                  WearPageHeader(title: context.l10n.headingWelcome, subtitle: context.l10n.wearPairingSubtitle),
                  if (_isRequesting) ...[
                    const Center(child: YaabsaCircularProgressIndicator(strokeWidth: 2, size: 32)),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.wearPairingSignInOnPhone,
                      style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.54)),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    WearBrowseButton(
                      title: context.l10n.actionSignIn,
                      icon: Icons.watch_outlined,
                      primary: true,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WearSignInScreen()));
                      },
                    ),
                    const SizedBox(height: 8),
                    WearBrowseButton(
                      title: context.l10n.actionContinue,
                      icon: Icons.phone_android_rounded,
                      onPressed: _requestCredentials,
                    ),
                  ],
                  if (_errorMessage != null && !_isRequesting) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: TextStyle(fontSize: 12, color: colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
