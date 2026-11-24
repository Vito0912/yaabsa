import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/wear/wear_scroll_view.dart';
import 'package:yaabsa/ui/components/wear/wear_swipe_to_dismiss.dart';
import 'package:yaabsa/util/network/request_headers.dart';
import 'package:yaabsa/ui/components/wear/wear_page_header.dart';

typedef WearServerHeader = ({String name, String value});

class WearHeaderScreen extends StatefulWidget {
  const WearHeaderScreen({super.key});

  @override
  State<WearHeaderScreen> createState() => _WearHeaderScreenState();
}

class _WearHeaderScreenState extends State<WearHeaderScreen> {
  final _name = TextEditingController();
  final _value = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _value.dispose();
    super.dispose();
  }

  void _add() {
    final name = _name.text.trim();
    final value = _value.text;
    final validationError = validateServerHeader(name: name, value: value);
    if (validationError != null) {
      setState(() {
        _error = validationError;
      });
      return;
    }
    Navigator.of(context).pop<WearServerHeader>((name: name, value: value));
  }

  @override
  Widget build(BuildContext context) {
    return WearSwipeToDismiss(
      child: Scaffold(
        body: WearScrollView(
          children: [
            const WearPageHeader(title: 'Server header'),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _value,
              decoration: const InputDecoration(labelText: 'Value'),
              autocorrect: false,
              enableSuggestions: false,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            if (_error != null) Text(_error!, textAlign: TextAlign.center),
            FilledButton(onPressed: _add, child: const Text('Add')),
          ],
        ),
      ),
    );
  }
}
