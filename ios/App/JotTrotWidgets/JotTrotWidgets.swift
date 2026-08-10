import WidgetKit
import SwiftUI
import ActivityKit

@main
struct JotTrotWidgetsBundle: WidgetBundle {
    var body: some Widget {
        TripActivityWidget()
    }
}

struct TripActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TripActivityAttributes.self) { context in
            // Lock screen / banner
            LockScreenView(context: context)
                .activityBackgroundTint(Color(red: 0.07, green: 0.09, blue: 0.13))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.emoji)
                        .font(.title2)
                        .padding(.leading, 4)
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("UP NEXT")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(context.state.stopName)
                            .font(.headline)
                            .lineLimit(1)
                        if !context.state.detail.isEmpty {
                            Text(context.state.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    ProgressText(done: context.state.stopsDone, total: context.state.stopsTotal)
                }
            } compactLeading: {
                Text(context.state.emoji)
            } compactTrailing: {
                ProgressText(done: context.state.stopsDone, total: context.state.stopsTotal)
                    .font(.caption2)
            } minimal: {
                Text(context.state.emoji)
            }
        }
    }
}

private struct LockScreenView: View {
    let context: ActivityViewContext<TripActivityAttributes>

    var body: some View {
        HStack(spacing: 12) {
            Text(context.state.emoji)
                .font(.largeTitle)
            VStack(alignment: .leading, spacing: 2) {
                Text("UP NEXT · \(context.attributes.tripName)")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(context.state.stopName)
                    .font(.headline)
                    .lineLimit(2)
                if !context.state.detail.isEmpty {
                    Text(context.state.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
            ProgressText(done: context.state.stopsDone, total: context.state.stopsTotal)
        }
        .padding(14)
        .foregroundStyle(.white)
    }
}

private struct ProgressText: View {
    let done: Int
    let total: Int

    var body: some View {
        if total > 0 {
            VStack(spacing: 1) {
                Text("\(done)/\(total)")
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                Text("stops")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
