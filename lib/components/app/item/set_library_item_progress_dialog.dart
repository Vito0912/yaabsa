import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/util/l10n.dart';

typedef SetLibraryItemProgressSelection = ({double progress, DateTime startedDate, DateTime? finishedDate});

Future<SetLibraryItemProgressSelection?> showSetLibraryItemProgressDialog({
  required BuildContext context,
  required double initialProgress,
  required double durationSeconds,
  required DateTime initialStartedDate,
  DateTime? initialFinishedDate,
}) {
  return showDialog<SetLibraryItemProgressSelection>(
    context: context,
    builder: (dialogContext) {
      return SetLibraryItemProgressDialog(
        initialProgress: initialProgress,
        durationSeconds: durationSeconds,
        initialStartedDate: initialStartedDate,
        initialFinishedDate: initialFinishedDate,
        onCancel: () => Navigator.of(dialogContext).pop(),
        onSave: (selection) => Navigator.of(dialogContext).pop(selection),
      );
    },
  );
}

class SetLibraryItemProgressDialog extends StatefulWidget {
  const SetLibraryItemProgressDialog({
    super.key,
    required this.initialProgress,
    required this.durationSeconds,
    required this.initialStartedDate,
    required this.initialFinishedDate,
    required this.onCancel,
    required this.onSave,
  });

  final double initialProgress;
  final double durationSeconds;
  final DateTime initialStartedDate;
  final DateTime? initialFinishedDate;
  final VoidCallback onCancel;
  final ValueChanged<SetLibraryItemProgressSelection> onSave;

  @override
  State<SetLibraryItemProgressDialog> createState() => _SetLibraryItemProgressDialogState();
}

class _SetLibraryItemProgressDialogState extends State<SetLibraryItemProgressDialog> {
  late final TextEditingController _timeController;
  late final TextEditingController _percentageController;
  late double _selectedProgress;
  late DateTime _startedDate;
  DateTime? _finishedDate;
  String? _timeError;
  String? _percentageError;

  double get _durationSeconds => widget.durationSeconds;

  double get _currentTimeSeconds => _durationSeconds * _selectedProgress;

  @override
  void initState() {
    super.initState();

    _selectedProgress = widget.initialProgress.clamp(0.0, 1.0).toDouble();
    _startedDate = DateUtils.dateOnly(widget.initialStartedDate);
    _finishedDate = widget.initialFinishedDate == null ? null : DateUtils.dateOnly(widget.initialFinishedDate!);
    if (_selectedProgress >= 1 && _finishedDate == null) {
      _finishedDate = _startedDate;
    }
    _timeController = TextEditingController(text: _formatClockTime(_currentTimeSeconds));
    _percentageController = TextEditingController(text: (_selectedProgress * 100).round().toString());
  }

  @override
  void dispose() {
    _timeController.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  void _updateProgress(double progress) {
    final boundedProgress = progress.clamp(0.0, 1.0).toDouble();
    final formattedTime = _formatClockTime(_durationSeconds * boundedProgress);
    final formattedPercentage = (boundedProgress * 100).round().toString();

    setState(() {
      _selectedProgress = boundedProgress;
      if (boundedProgress >= 1 && _finishedDate == null) {
        _finishedDate = DateUtils.dateOnly(DateTime.now());
      }
      if (_timeController.text != formattedTime) {
        _timeController.value = TextEditingValue(
          text: formattedTime,
          selection: TextSelection.collapsed(offset: formattedTime.length),
        );
      }
      if (_percentageController.text != formattedPercentage) {
        _percentageController.value = TextEditingValue(
          text: formattedPercentage,
          selection: TextSelection.collapsed(offset: formattedPercentage.length),
        );
      }
      _timeError = null;
      _percentageError = null;
    });
  }

  void _updateTime(String value) {
    final selectedSeconds = _parseClockTime(value);

    if (selectedSeconds == null) {
      setState(() {
        _timeError = context.l10n.validationEnterTimeFormat;
      });
      return;
    }

    if (selectedSeconds > _durationSeconds) {
      setState(() {
        _timeError = context.l10n.validationTimeExceedsDuration(_formatClockTime(_durationSeconds));
      });
      return;
    }

    _updateProgress(selectedSeconds / _durationSeconds);
  }

  void _updatePercentage(String value) {
    final selectedPercentage = int.tryParse(value);

    if (selectedPercentage == null) {
      setState(() {
        _percentageError = context.l10n.validationPercentageRequired;
      });
      return;
    }

    if (selectedPercentage > 100) {
      setState(() {
        _percentageError = context.l10n.validationPercentageExceedsMaximum;
      });
      return;
    }

    _updateProgress(selectedPercentage / 100);
  }

  Future<void> _selectDate({required bool isFinishedDate}) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final firstSelectableDate = DateTime(1900);
    final firstDate = isFinishedDate ? _startedDate : firstSelectableDate;
    final lastDate = isFinishedDate
        ? today
        : _selectedProgress >= 1 && _finishedDate != null
        ? _finishedDate!
        : today;
    final currentDate = isFinishedDate ? _finishedDate ?? today : _startedDate;
    final initialDate = DateUtils.dateOnly(currentDate);
    final boundedInitialDate = initialDate.isAfter(lastDate)
        ? lastDate
        : initialDate.isBefore(firstDate)
        ? firstDate
        : initialDate;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: boundedInitialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (!mounted || selectedDate == null) {
      return;
    }

    final selectedDateOnly = DateUtils.dateOnly(selectedDate);
    if (isFinishedDate) {
      _updateProgress(1);
    }

    setState(() {
      if (isFinishedDate) {
        _finishedDate = selectedDateOnly;
      } else {
        _startedDate = selectedDateOnly;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final appLocalizations = context.l10n;
    final startedDateLabel = localizations.formatMediumDate(_startedDate);
    final isFinished = _selectedProgress >= 1;
    final finishedDateLabel = _finishedDate == null
        ? appLocalizations.statusNotFinished
        : localizations.formatMediumDate(_finishedDate!);

    return AlertDialog(
      title: Text(appLocalizations.actionSetProgress),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: StyledTextField(
                    controller: _timeController,
                    label: appLocalizations.fieldElapsedTime,
                    hintText: 'H:MM:SS',
                    helperText: _timeError == null
                        ? appLocalizations.hintBookLength(_formatClockTime(_durationSeconds))
                        : null,
                    errorText: _timeError,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9:]'))],
                    onChanged: _updateTime,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: StyledTextField(
                    controller: _percentageController,
                    label: appLocalizations.fieldProgress,
                    hintText: '0-100',
                    suffixText: '%',
                    errorText: _percentageError,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: _updatePercentage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _selectDate(isFinishedDate: false),
              icon: const Icon(Icons.calendar_today_rounded),
              label: Text(appLocalizations.labelStartedDate(startedDateLabel), overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _selectDate(isFinishedDate: true),
              icon: const Icon(Icons.event_available_rounded),
              label: Text(
                isFinished ? appLocalizations.labelFinishedDate(finishedDateLabel) : appLocalizations.actionSetFinished,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: widget.onCancel, child: Text(appLocalizations.actionCancel)),
        FilledButton(
          onPressed: _timeError == null && _percentageError == null
              ? () =>
                    widget.onSave((progress: _selectedProgress, startedDate: _startedDate, finishedDate: _finishedDate))
              : null,
          child: Text(appLocalizations.actionSave),
        ),
      ],
    );
  }
}

double? _parseClockTime(String value) {
  final parts = value.trim().split(':');
  if (parts.length < 2 || parts.length > 3 || parts.any((part) => part.isEmpty)) {
    return null;
  }

  final values = parts.map(int.tryParse).toList(growable: false);
  if (values.any((part) => part == null || part < 0)) {
    return null;
  }

  final seconds = values.last!;
  final minutes = values[values.length - 2]!;
  if (seconds >= 60 || (parts.length == 3 && minutes >= 60)) {
    return null;
  }

  final hours = parts.length == 3 ? values.first! : 0;
  final totalSeconds = (hours * Duration.secondsPerHour) + (minutes * Duration.secondsPerMinute) + seconds;
  return totalSeconds.toDouble();
}

String _formatClockTime(double seconds) {
  final totalSeconds = seconds.round().clamp(0, 1 << 31);
  final duration = Duration(seconds: totalSeconds);
  final hours = duration.inHours.toString().padLeft(2, '0');
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final remainingSeconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$hours:$minutes:$remainingSeconds';
}
