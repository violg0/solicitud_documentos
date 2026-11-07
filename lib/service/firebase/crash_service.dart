import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashService {
  const CrashService();

  Future<void> configure() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    // Flutter framework errors
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Async errors outside the framework
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  Future<void> setUserIdentifier(String uid) =>
      FirebaseCrashlytics.instance.setUserIdentifier(uid);

  Future<void> recordNonFatal(
    Object error,
    StackTrace stack, {
    String? reason,
  }) => FirebaseCrashlytics.instance.recordError(
    error,
    stack,
    reason: reason,
    fatal: false,
  );

  Future<T> registrar<T>(Future<T> Function() operacion, String reason) async {
    try {
      return await operacion();
    } catch (e, s) {
      try {
        await recordNonFatal(e, s, reason: reason);
      } catch (_) {}
      rethrow;
    }
  }

  void simulateFatalCrash() => FirebaseCrashlytics.instance.crash();
}
