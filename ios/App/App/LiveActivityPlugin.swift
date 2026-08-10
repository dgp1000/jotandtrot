import Foundation
import Capacitor
#if canImport(ActivityKit)
import ActivityKit
#endif

/// Lock-screen Live Activity for today's plan.
/// JS: nativeCall("LiveActivity", "show", { tripName, dayLabel, stopName, detail, emoji, stopsDone, stopsTotal })
///     nativeCall("LiveActivity", "end", {})
/// `show` starts the activity if none exists, otherwise updates it in place.
@objc(LiveActivityPlugin)
public class LiveActivityPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "LiveActivityPlugin"
    public let jsName = "LiveActivity"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "show", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "end", returnType: CAPPluginReturnPromise),
    ]

    @objc func show(_ call: CAPPluginCall) {
        guard #available(iOS 16.2, *) else { call.resolve(["active": false]); return }
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { call.resolve(["active": false]); return }

        let state = TripActivityAttributes.ContentState(
            stopName: call.getString("stopName") ?? "",
            detail: call.getString("detail") ?? "",
            emoji: call.getString("emoji") ?? "📍",
            stopsDone: call.getInt("stopsDone") ?? 0,
            stopsTotal: call.getInt("stopsTotal") ?? 0
        )
        // stale after 12h so an abandoned activity dims instead of lying forever
        let content = ActivityContent(state: state, staleDate: Date().addingTimeInterval(12 * 3600))

        Task {
            if let existing = Activity<TripActivityAttributes>.activities.first {
                await existing.update(content)
                call.resolve(["active": true])
                return
            }
            do {
                let attrs = TripActivityAttributes(
                    tripName: call.getString("tripName") ?? "",
                    dayLabel: call.getString("dayLabel") ?? ""
                )
                _ = try Activity.request(attributes: attrs, content: content)
                call.resolve(["active": true])
            } catch {
                call.resolve(["active": false, "error": error.localizedDescription])
            }
        }
    }

    @objc func end(_ call: CAPPluginCall) {
        guard #available(iOS 16.2, *) else { call.resolve(); return }
        Task {
            for activity in Activity<TripActivityAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            call.resolve()
        }
    }
}
