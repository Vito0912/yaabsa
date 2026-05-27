import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/admin/server_log_entry.dart';
import 'package:yaabsa/api/me/server_settings.dart';
import 'package:yaabsa/api/socket/abs_socket_client.dart';
import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';
import 'package:yaabsa/provider/core/socket_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

class AdminServerLogsView extends ConsumerStatefulWidget {
  const AdminServerLogsView({super.key});

  @override
  ConsumerState<AdminServerLogsView> createState() => _AdminServerLogsViewState();
}

class _AdminServerLogsViewState extends ConsumerState<AdminServerLogsView> {
  static const int _maxLogLines = 1000;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ServerLogEntry> _loadedLogs = <ServerLogEntry>[];

  ABSSocketClient? _socketClient;
  String? _activeUserId;
  String? _socketListenerId;
  String _searchText = '';
  String _visibleLogText = '';
  bool _isLoading = true;
  bool _isUpdatingLogLevel = false;
  bool _autoScroll = true;
  String? _errorMessage;
  LogLevel _listenerLogLevel = LogLevel.info;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_handleSearchTextChanged);
    _searchController.dispose();
    _scrollController.dispose();
    _detachSocketListener();
    _loadedLogs.clear();
    super.dispose();
  }

  void _handleSearchTextChanged() {
    final nextSearchText = _searchController.text.trim().toLowerCase();
    if (nextSearchText == _searchText) {
      return;
    }

    setState(() {
      _searchText = nextSearchText;
      _rebuildVisibleLogText();
    });
  }

  bool _isAdminType(String? userType) {
    final normalizedType = (userType ?? '').trim().toLowerCase();
    return normalizedType == 'admin' || normalizedType == 'root';
  }

  Future<void> _initializeForCurrentUser() async {
    _detachSocketListener();

    setState(() {
      _errorMessage = null;
      _isLoading = true;
      _loadedLogs.clear();
      _visibleLogText = '';
    });

    try {
      final api = ref.read(absApiProvider);
      final currentUser = ref.read(currentUserProvider).value;
      if (api == null) {
        throw StateError('No active API client.');
      }
      if (currentUser == null) {
        throw StateError('No active user.');
      }

      final loggerResponse = await api.getAdminApi().getLoggerData();
      final authResponse = await api.getMeApi().checkLogin();

      final resolvedServerLogLevel = authResponse.data?.serverSettings.logLevel;
      if (resolvedServerLogLevel == null) {
        throw StateError('Server did not return the current log level.');
      }

      final loadedLogs = loggerResponse.data?.currentDailyLogs ?? const <ServerLogEntry>[];
      final trimmedLogs = loadedLogs.length > _maxLogLines
          ? loadedLogs.sublist(loadedLogs.length - _maxLogLines)
          : loadedLogs;

      if (!mounted) {
        return;
      }

      setState(() {
        _listenerLogLevel = resolvedServerLogLevel;
        _loadedLogs
          ..clear()
          ..addAll(trimmedLogs);
        _rebuildVisibleLogText();
      });

      _attachSocketListener();
      _scheduleScrollToBottom(animated: false);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Failed to load logs: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  ABSSocketClient _ensureSocketClient() {
    final existing = _socketClient;
    if (existing != null) {
      return existing;
    }

    final created = ref.read(absSocketClientProvider);
    _socketClient = created;
    return created;
  }

  void _attachSocketListener() {
    if (_socketListenerId != null) {
      return;
    }

    final socketClient = _ensureSocketClient();
    socketClient.setServerLogListenerLevel(_listenerLogLevel.value);

    _socketListenerId = socketClient.addServerLogListener((payload) {
      final entry = _parseServerLogEntry(payload);
      if (entry == null || !mounted) {
        return;
      }

      setState(() {
        _loadedLogs.add(entry);
        if (_loadedLogs.length > _maxLogLines) {
          _loadedLogs.removeRange(0, _loadedLogs.length - _maxLogLines);
        }
        _rebuildVisibleLogText();
      });

      if (_autoScroll) {
        _scheduleScrollToBottom();
      }
    });
  }

  void _detachSocketListener() {
    final socketClient = _socketClient;
    final listenerId = _socketListenerId;
    if (socketClient == null || listenerId == null) {
      return;
    }

    socketClient.removeServerLogListener(listenerId);
    _socketListenerId = null;
  }

  ServerLogEntry? _parseServerLogEntry(Map<String, dynamic> payload) {
    try {
      return ServerLogEntry.fromJson(payload);
    } catch (_) {
      return null;
    }
  }

  Future<void> _updateServerLogLevel(LogLevel nextLogLevel) async {
    if (_listenerLogLevel == nextLogLevel || _isUpdatingLogLevel) {
      return;
    }

    setState(() {
      _isUpdatingLogLevel = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw StateError('No active API client.');
      }

      await api.getAdminApi().updateServerSettings(
        settingsUpdate: ServerSettings(id: "server-settings", logLevel: nextLogLevel),
      );

      if (!mounted) {
        return;
      }

      await _initializeForCurrentUser();
    } on DioException catch (error) {
      if (!mounted) {
        return;
      }

      final responseError = error.response?.data;
      final serverMessage = responseError is String ? responseError : null;

      setState(() {
        _errorMessage = serverMessage == null || serverMessage.isEmpty
            ? 'Failed to update server log level: ${error.message ?? error.runtimeType}'
            : 'Failed to update server log level: $serverMessage';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Failed to update server log level: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingLogLevel = false;
        });
      }
    }
  }

  void _scheduleScrollToBottom({bool animated = true}) {
    if (!_autoScroll) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      final maxScroll = _scrollController.position.maxScrollExtent;
      if (animated) {
        _scrollController.animateTo(maxScroll, duration: const Duration(milliseconds: 120), curve: Curves.easeOut);
      } else {
        _scrollController.jumpTo(maxScroll);
      }
    });
  }

  String _formatLogLine(ServerLogEntry log) {
    final source = (log.source ?? '').trim();
    final sourcePart = source.isEmpty ? '' : ' $source';
    return '[${log.timestamp}] ${log.levelName}$sourcePart ${log.message}';
  }

  void _rebuildVisibleLogText() {
    final levelFilteredLogs = _loadedLogs.where((log) => log.level >= _listenerLogLevel.value);

    final searchableLogs = _searchText.isEmpty
        ? levelFilteredLogs
        : levelFilteredLogs.where((log) {
            final searchable = '${log.timestamp} ${log.levelName} ${log.source ?? ''} ${log.message}'.toLowerCase();
            return searchable.contains(_searchText);
          });

    final buffer = StringBuffer();
    var isFirst = true;
    for (final log in searchableLogs) {
      if (!isFirst) {
        buffer.writeln();
      }
      isFirst = false;
      buffer.write(_formatLogLine(log));
    }

    _visibleLogText = buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          _detachSocketListener();
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('No active user. Sign in to view server logs.'),
          );
        }

        if (!_isAdminType(currentUser.type)) {
          _detachSocketListener();
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('This page requires an admin account.'),
          );
        }

        if (_activeUserId != currentUser.id) {
          _activeUserId = currentUser.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_initializeForCurrentUser());
          });
        }

        final viewportHeight = MediaQuery.sizeOf(context).height;
        final logsContainerHeight = (viewportHeight - 260).clamp(240.0, 1200.0);

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search logs',
                        isDense: true,
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 170,
                    child: YaabsaExpressiveDropdownField<int>(
                      key: ValueKey<int>(_listenerLogLevel.value),
                      value: _listenerLogLevel.value,
                      decoration: const InputDecoration(
                        labelText: 'Server Log Level',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      options: LogLevel.values
                          .map(
                            (level) => YaabsaDropdownOption<int>(value: level.value, label: level.name.toUpperCase()),
                          )
                          .toList(growable: false),
                      onChanged: _isUpdatingLogLevel
                          ? null
                          : (value) {
                              if (value != null) {
                                unawaited(
                                  _updateServerLogLevel(LogLevel.values.firstWhere((level) => level.value == value)),
                                );
                              }
                            },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: _autoScroll,
                    onChanged: (value) {
                      setState(() {
                        _autoScroll = value ?? true;
                      });
                      if (_autoScroll) {
                        _scheduleScrollToBottom(animated: false);
                      }
                    },
                  ),
                  const Text('Auto-scroll'),
                  const Spacer(),
                  if (_isUpdatingLogLevel)
                    const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                ],
              ),
              if (_errorMessage != null && _errorMessage!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
              SizedBox(
                height: logsContainerHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.6)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _visibleLogText.isEmpty
                      ? const Center(child: Text('No logs found for the current search.'))
                      : Scrollbar(
                          controller: _scrollController,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: SelectableText(
                              _visibleLogText,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                height: 1.3,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text('Failed to load user data: $error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}
