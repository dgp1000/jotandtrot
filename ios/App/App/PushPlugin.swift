import Foundation
import Capacitor
import UserNotifications
import UIKit

/// Minimal push-registration plugin. JS: register() then poll getToken().
@objc(PushPlugin)
public class PushPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "PushPlugin"
    public let jsName = "Push"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "register", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getToken", returnType: CAPPluginReturnPromise)
    ]
    static var deviceToken: String? = nil

    @objc func register(_ call: CAPPluginCall) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                if granted { UIApplication.shared.registerForRemoteNotifications() }
                call.resolve(["granted": granted])
            }
        }
    }

    @objc func getToken(_ call: CAPPluginCall) {
        call.resolve(["token": PushPlugin.deviceToken ?? ""])
    }
}
