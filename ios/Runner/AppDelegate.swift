import Flutter
import Security
import UIKit
import UserNotifications

let sharedFlutterEngine = FlutterEngine(name: "SharedEngine", project: nil, allowHeadlessExecution: true)

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var authSecretMigrationChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    sharedFlutterEngine.run()
    GeneratedPluginRegistrant.register(with: sharedFlutterEngine)
    configureAuthSecretMigrationChannel()
    UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func configureAuthSecretMigrationChannel() {
    let channel = FlutterMethodChannel(
      name: "de.vito0912.yaabsa/auth_secret_migration",
      binaryMessenger: sharedFlutterEngine.binaryMessenger
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "migrateAccessibility" else {
        result(FlutterMethodNotImplemented)
        return
      }

      guard
        let arguments = call.arguments as? [String: Any],
        let key = arguments["key"] as? String,
        !key.isEmpty
      else {
        result(FlutterError(code: "invalid_arguments", message: "Missing key", details: nil))
        return
      }

      let query: [CFString: Any] = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: key,
        kSecAttrService: "flutter_secure_storage_service",
        kSecAttrSynchronizable: false,
      ]
      let attributes: [CFString: Any] = [
        kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
      ]
      let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

      if status == errSecSuccess {
        result(nil)
        return
      }

      result(
        FlutterError(
          code: "keychain_migration_failed",
          message: "Keychain update failed with status \(status)",
          details: status,
        )
      )
    }
    authSecretMigrationChannel = channel
  }
}
