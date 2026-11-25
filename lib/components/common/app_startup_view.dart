import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/empty_state_card.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class AppStartupView extends StatelessWidget {
  const AppStartupView({super.key, this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    final startupError = error;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (startupError == null) ...[
                    YaabsaLoadingIndicator(semanticLabel: context.l10n.startupAudioServiceStatus),
                    const SizedBox(height: 16),
                    Text(context.l10n.startupAudioServiceStatus),
                  ] else ...[
                    YaabsaEmptyStateCard(
                      title: context.l10n.startupUnableToStartTitle,
                      subtitle: context.l10n.startupAudioServiceError,
                      icon: Icons.error_outline_rounded,
                      centered: true,
                    ),
                    const SizedBox(height: 16),
                    SelectableText(startupError.toString()),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
