import Foundation
#if canImport(ActivityKit)
import ActivityKit

/// Shared between the app target and the JotTrotWidgets extension —
/// both must compile the exact same definition for the activity to render.
@available(iOS 16.2, *)
struct TripActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        /// e.g. "Senso-ji Temple"
        var stopName: String
        /// e.g. "20 min walk · afternoon" — one short line under the name
        var detail: String
        /// emoji for the stop kind (🏯 🍜 🛏️ …)
        var emoji: String
        /// progress through today's plan
        var stopsDone: Int
        var stopsTotal: Int
    }

    /// Fixed for the life of the activity
    var tripName: String
    var dayLabel: String
}
#endif
