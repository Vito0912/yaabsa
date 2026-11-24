import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/provider/wear/wear_sign_in_provider.dart';
import 'package:yaabsa/screens/wear/wear_header_screen.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/wear/wear_scroll_view.dart';
import 'package:yaabsa/ui/components/wear/wear_swipe_to_dismiss.dart';
import 'package:yaabsa/ui/components/wear/wear_page_header.dart';

class WearSignInScreen extends ConsumerStatefulWidget {
  const WearSignInScreen({super.key});

  @override
  ConsumerState<WearSignInScreen> createState() => _WearSignInScreenState();
}

class _WearSignInScreenState extends ConsumerState<WearSignInScreen> {
  final _server = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _headers = <String, String>{};

  @override
  void dispose() {
    _server.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _addHeader() async {
    final header = await Navigator.of(context)
        .push<WearServerHeader>(MaterialPageRoute(builder: (_) => const WearHeaderScreen()));
    if (header != null && mounted) {
      setState(() {
        _headers.removeWhere((name, _) => name.toLowerCase() == header.name.toLowerCase());
        _headers[header.name] = header.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final signIn = ref.watch(wearSignInProvider);
    final loading = signIn.isLoading;

    return WearSwipeToDismiss(
      child: Scaffold(
        body: AutofillGroup(
          child: WearScrollView(
            children: [
              const WearPageHeader(title: 'Sign in'),
              TextField(
                controller: _server,
                enabled: !loading,
                decoration: const InputDecoration(labelText: 'Server address', hintText: 'https://'),
                keyboardType: TextInputType.url,
                autocorrect: false,
                enableSuggestions: false,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _username,
                enabled: !loading,
                decoration: const InputDecoration(labelText: 'Username'),
                autofillHints: const [AutofillHints.username],
                autocorrect: false,
                enableSuggestions: false,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _password,
                enabled: !loading,
                decoration: const InputDecoration(labelText: 'Password'),
                autofillHints: const [AutofillHints.password],
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
              ),
              const SizedBox(height: 12),
              if (signIn.hasError)
                Text(
                  wearRequestError(signIn.error!),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              FilledButton(
                onPressed: loading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        await ref
                            .read(wearSignInProvider.notifier)
                            .signIn(
                              serverAddress: _server.text,
                              username: _username.text,
                              password: _password.text,
                              headers: Map.of(_headers),
                            );
                        if (mounted) {
                          _password.clear();
                        }
                      },
                child: loading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: YaabsaCircularProgressIndicator(strokeWidth: 2, size: 20),
                      )
                    : const Text('Sign in'),
              ),
              TextButton(onPressed: loading ? null : _addHeader, child: const Text('Add server header')),
              for (final name in _headers.keys)
                TextButton(
                  onPressed: loading
                      ? null
                      : () {
                          setState(() {
                            _headers.remove(name);
                          });
                        },
                  child: Text('Remove $name', maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
