import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    UNUserNotificationCenter.current().delegate = self
    registerNotificationCategories()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func registerNotificationCategories() {
    let pause = UNNotificationAction(
      identifier: "pause",
      title: "Pause",
      options: []
    )
    let resume = UNNotificationAction(
      identifier: "resume",
      title: "Resume",
      options: []
    )
    let cancel = UNNotificationAction(
      identifier: "cancel",
      title: "Cancel",
      options: [.destructive]
    )
    let tracking = UNNotificationCategory(
      identifier: "tracking",
      actions: [pause, cancel],
      intentIdentifiers: [],
      options: []
    )
    let paused = UNNotificationCategory(
      identifier: "tracking_paused",
      actions: [resume, cancel],
      intentIdentifiers: [],
      options: []
    )
    UNUserNotificationCenter.current().setNotificationCategories([tracking, paused])
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
