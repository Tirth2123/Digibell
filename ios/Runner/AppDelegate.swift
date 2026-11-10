import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import PushKit
import flutter_callkit_incoming

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, PKPushRegistryDelegate {
  var voipRegistry: PKPushRegistry?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
    UNUserNotificationCenter.current().delegate = self
    application.registerForRemoteNotifications()

    // Setup VOIP PushKit
    let mainQueue = DispatchQueue.main
    voipRegistry = PKPushRegistry(queue: mainQueue)
    voipRegistry?.delegate = self
    voipRegistry?.desiredPushTypes = [.voIP]

    // Register plugins immediately so SwiftFlutterCallkitIncomingPlugin.sharedInstance
    // is initialized and available even on cold-start background VoIP wakeups.
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Foundation.Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // Handle updated VoIP push credentials
  func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
    let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
    print("VoIP Device Token: \(deviceToken)")
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(deviceToken)
  }

  func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
    print("didInvalidatePushTokenFor VoIP")
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
  }

  // Handle incoming VoIP pushes even when killed or in background
  func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
    guard type == .voIP else {
      completion()
      return
    }

    let payloadDict = payload.dictionaryPayload
    var callData = payloadDict
    if let dataDict = payloadDict["data"] as? [String: Any] {
      callData = dataDict
    } else if let dataStr = payloadDict["data"] as? String,
              let data = dataStr.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
      callData = json
    }

    // iOS CallKit force-unwraps UUID(uuidString: data.uuid)! inside
    // SwiftFlutterCallkitIncomingPlugin; guarantee a valid RFC-4122 UUID.
    let rawId = callData["callId"] as? String ?? payloadDict["id"] as? String ?? ""
    let id = UUID(uuidString: rawId)?.uuidString ?? UUID().uuidString
    let nameCaller = callData["callerName"] as? String ?? payloadDict["nameCaller"] as? String ?? "Someone"
    let handle = callData["callerPhone"] as? String ?? payloadDict["handle"] as? String ?? nameCaller
    let callType = callData["type"] as? String ?? payloadDict["type"] as? String ?? "audioCall"
    let isVideo = (callType == "videoCall" || (payloadDict["isVideo"] as? Bool ?? false))

    let data = flutter_callkit_incoming.Data(id: id, nameCaller: nameCaller, handle: handle, type: isVideo ? 1 : 0)
    data.duration = 45000
    data.extra = payloadDict as NSDictionary

    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)

    // CallKit's reportNewIncomingCall is asynchronous.
    // Defer completion by 1.5 seconds so the system provider completes
    // presenting the native incoming call UI before iOS suspends the app.
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      completion()
    }
  }
}

