import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/empty_state_card.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

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
                    const YaabsaLoadingIndicator(semanticLabel: 'Starting audio service'),
                    const SizedBox(height: 16),
                    const Text('Starting audio service…'),
                  ] else ...[
                    const YaabsaEmptyStateCard(
                      title: 'Unable to start YAABSA',
                      subtitle: 'The audio service could not start. Close and restart the app',
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
