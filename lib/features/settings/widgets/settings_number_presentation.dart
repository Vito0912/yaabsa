import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/lists/settings_control_label.dart';
import 'package:yaabsa/util/l10n.dart';

class SettingsNumberPresentation extends StatefulWidget {
  const SettingsNumberPresentation({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.description,
    this.unitLabel,
    this.icon,
    this.tooltip,
    this.enabled = true,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int>? onChanged;
  final String? description;
  final String? unitLabel;
  final IconData? icon;
  final String? tooltip;
  final bool enabled;

  @override
  State<SettingsNumberPresentation> createState() => _SettingsNumberPresentationState();
}

class _SettingsNumberPresentationState extends State<SettingsNumberPresentation> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  int? _lastSyncedValue;

  @override
  void initState() {
    super.initState();
    _syncController(widget.value);
  }

  @override
  void didUpdateWidget(covariant SettingsNumberPresentation oldWidget) {
    super.didUpdateWidget(oldWidget);
    final clamped = widget.value.clamp(widget.min, widget.max).toInt();
    if (widget.value != oldWidget.value && clamped != _lastSyncedValue) {
      _syncController(clamped);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncController(int value) {
    final clamped = value.clamp(widget.min, widget.max).toInt();
    _lastSyncedValue = clamped;
    _controller.text = '$clamped';
    _errorText = null;
  }

  void _commitValue(int nextValue) {
    final clamped = nextValue.clamp(widget.min, widget.max).toInt();
    setState(() {
      _syncController(clamped);
    });
    widget.onChanged?.call(clamped);
  }

  void _cancelEdit() {
    setState(() {
      _syncController(widget.value);
    });
  }

  void _submitText() {
    final parsed = int.tryParse(_controller.text.trim());
    if (parsed == null || parsed < widget.min || parsed > widget.max) {
      setState(() {
        _errorText = context.l10n.settingsNumberRangeError(widget.min, widget.max);
      });
      return;
    }

    _commitValue(parsed);
  }

  bool _fitsInlineRow(BuildContext context, double maxWidth) {
    if (!maxWidth.isFinite) {
      return true;
    }

    final textScaler = MediaQuery.textScalerOf(context);
    final textScale = textScaler.scale(1);
    final unitText = widget.unitLabel;
    var unitWidth = 0.0;

    if (unitText != null && unitText.isNotEmpty) {
      final style = Theme.of(context).textTheme.bodyLarge ?? const TextStyle(fontSize: 16);
      final painter = TextPainter(
        text: TextSpan(text: unitText, style: style),
        maxLines: 1,
        textDirection: Directionality.of(context),
        textScaler: textScaler,
      )..layout();
      unitWidth = painter.width + 12.0;
    }

    final minimumInlineWidth = 112.0 + (120.0 * textScale) + unitWidth + 96.0;
    return maxWidth >= minimumInlineWidth;
  }

  Widget _buildDecreaseButton(AppLocalizations l10n, bool isEnabled, int clampedValue) {
    return IconButton.filledTonal(
      tooltip: l10n.actionDecrease,
      onPressed: isEnabled && clampedValue > widget.min ? () => _commitValue(clampedValue - 1) : null,
      icon: const Icon(Icons.remove_rounded),
    );
  }

  Widget _buildIncreaseButton(AppLocalizations l10n, bool isEnabled, int clampedValue) {
    return IconButton.filledTonal(
      tooltip: l10n.actionIncrease,
      onPressed: isEnabled && clampedValue < widget.max ? () => _commitValue(clampedValue + 1) : null,
      icon: const Icon(Icons.add_rounded),
    );
  }

  Widget _buildTextField({Widget? suffixIcon}) {
    return StyledTextField(
      controller: _controller,
      enabled: widget.enabled && widget.onChanged != null,
      isDense: true,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      suffixText: widget.unitLabel,
      errorText: _errorText,
      onChanged: (_) {
        setState(() {
          _errorText = null;
        });
      },
      onSubmitted: (_) => _submitText(),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isEnabled = widget.enabled && widget.onChanged != null;
    final clampedValue = widget.value.clamp(widget.min, widget.max).toInt();
    final showCancel = isEnabled && (_errorText != null || _controller.text.trim() != '$clampedValue');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsControlLabel(
            label: widget.label,
            description: widget.description,
            enabled: isEnabled,
            icon: widget.icon,
            tooltip: widget.tooltip,
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              if (_fitsInlineRow(context, constraints.maxWidth)) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDecreaseButton(l10n, isEnabled, clampedValue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField(
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (showCancel)
                              IconButton(
                                tooltip: l10n.actionCancel,
                                onPressed: _cancelEdit,
                                icon: const Icon(Icons.close_rounded),
                              ),
                            IconButton(
                              tooltip: l10n.actionSave,
                              onPressed: isEnabled ? _submitText : null,
                              icon: const Icon(Icons.check_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildIncreaseButton(l10n, isEnabled, clampedValue),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDecreaseButton(l10n, isEnabled, clampedValue),
                          const SizedBox(width: 8),
                          _buildIncreaseButton(l10n, isEnabled, clampedValue),
                        ],
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (showCancel)
                            YaabsaButton.small(
                              variant: YaabsaButtonVariant.text,
                              onPressed: _cancelEdit,
                              label: Text(l10n.actionCancel),
                            ),
                          YaabsaButton.small(
                            variant: YaabsaButtonVariant.tonal,
                            onPressed: isEnabled ? _submitText : null,
                            icon: const Icon(Icons.check_rounded, size: 16),
                            label: Text(l10n.actionSave),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
