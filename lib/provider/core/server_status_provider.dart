import 'dart:async';

import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'server_status_provider.g.dart';

const Duration _connectedInterval = Duration(minutes: 10);
const Duration _disconnectedInterval = Duration(minutes: 1);

@Riverpod(keepAlive: true)
Stream<bool> serverStatus(Ref ref) {
  final controller = StreamController<bool>();
  Timer? timer;
  bool lastStatus = false;
  final connectivity = Connectivity();

  Future<void> checkStatus() async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (lastStatus) {
        controller.add(false);
        lastStatus = false;
      }
      timer?.cancel();
      timer = Timer.periodic(_disconnectedInterval, (_) => checkStatus());
      return;
    }

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      if (lastStatus) {
        controller.add(false);
        lastStatus = false;
      }
      timer?.cancel();
      timer = Timer.periodic(_disconnectedInterval, (_) => checkStatus());
      return;
    }

    try {
      await absApi.getMeApi().getPing();
      if (!lastStatus) {
        controller.add(true);
        lastStatus = true;
      }
      timer?.cancel();
      timer = Timer.periodic(_connectedInterval, (_) => checkStatus());
    } on DioException {
      if (lastStatus) {
        controller.add(false);
        lastStatus = false;
      }
      timer?.cancel();
      timer = Timer.periodic(_disconnectedInterval, (_) => checkStatus());
    } catch (e) {
      if (lastStatus) {
        controller.add(false);
        lastStatus = false;
      }
      timer?.cancel();
      timer = Timer.periodic(_disconnectedInterval, (_) => checkStatus());
    }
  }

  checkStatus();

  final connectivitySubscription = connectivity.onConnectivityChanged.listen((
    result,
  ) {
    timer?.cancel();
    checkStatus();
  });

  ref.listen(absApiProvider, (previous, next) {
    if (identical(previous, next) &&
        previous?.dio.options.baseUrl == next?.dio.options.baseUrl) {
      if ((previous == null && next != null) ||
          (previous != null && next == null)) {
      } else {
        return;
      }
    }
    timer?.cancel();
    checkStatus();
  });

  ref.onDispose(() {
    timer?.cancel();
    controller.close();
    connectivitySubscription.cancel();
  });

  return controller.stream;
}
