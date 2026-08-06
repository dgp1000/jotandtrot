import Foundation
import Capacitor
import UIKit

/// Minimal native share sheet. JS: nativeCall("Share", "share", { text })
@objc(SharePlugin)
public class SharePlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "SharePlugin"
    public let jsName = "Share"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "share", returnType: CAPPluginReturnPromise)
    ]

    @objc func share(_ call: CAPPluginCall) {
        let text = call.getString("text") ?? ""
        DispatchQueue.main.async {
            guard let vc = self.bridge?.viewController else { call.reject("no view controller"); return }
            let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            av.popoverPresentationController?.sourceView = vc.view
            av.completionWithItemsHandler = { _, completed, _, _ in call.resolve(["shared": completed]) }
            vc.present(av, animated: true)
        }
    }
}
