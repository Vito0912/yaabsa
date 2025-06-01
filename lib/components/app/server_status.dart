import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServerStatus extends ConsumerWidget {
  const ServerStatus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverStatus = ref.watch(serverStatusProvider);
    final serverReachable = serverStatus.value ?? false;
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: serverReachable ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        serverReachable ? "Server is reachable" : "Server is unreachable",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
