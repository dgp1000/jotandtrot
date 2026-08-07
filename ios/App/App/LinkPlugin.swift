import Foundation
import Capacitor

/// Universal links (https://jotandtrot.com/join/CODE). JS: Link.addListener("appUrlOpen") + Link.getLaunchUrl()
@objc(LinkPlugin)
public class LinkPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "LinkPlugin"
    public let jsName = "Link"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "getLaunchUrl", returnType: CAPPluginReturnPromise)
    ]

    static var launchUrl: String?
    static weak var instance: LinkPlugin?

    override public func load() { LinkPlugin.instance = self }

    /// Called from AppDelegate; keeps the URL for cold starts where JS isn't listening yet.
    static func handle(_ url: URL) {
        launchUrl = url.absoluteString
        instance?.notifyListeners("appUrlOpen", data: ["url": url.absoluteString])
    }

    @objc func getLaunchUrl(_ call: CAPPluginCall) {
        call.resolve(["url": LinkPlugin.launchUrl ?? ""])
    }
}
