import Foundation
import Capacitor
import EventKit

/// Add the trip's schedule to the user's calendar.
/// JS: nativeCall("Calendar", "addEvents", { events: [{ title, notes?, date: "YYYY-MM-DD", startHour?, endHour? }] })
/// Events without startHour/endHour become all-day. Returns { added, denied? }.
@objc(CalendarPlugin)
public class CalendarPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "CalendarPlugin"
    public let jsName = "Calendar"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "addEvents", returnType: CAPPluginReturnPromise)
    ]

    private let store = EKEventStore()

    @objc func addEvents(_ call: CAPPluginCall) {
        let events = (call.getArray("events") ?? []).compactMap { $0 as? [String: Any] }
        guard !events.isEmpty else { call.reject("no events"); return }

        let finish: (Bool) -> Void = { granted in
            guard granted else { call.resolve(["added": 0, "denied": true]); return }
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            df.timeZone = TimeZone.current
            var added = 0
            for ev in events {
                guard let title = ev["title"] as? String,
                      let ds = ev["date"] as? String,
                      let day = df.date(from: ds) else { continue }
                let e = EKEvent(eventStore: self.store)
                e.title = title
                e.notes = ev["notes"] as? String
                e.calendar = self.store.defaultCalendarForNewEvents
                if let sh = ev["startHour"] as? Int, let eh = ev["endHour"] as? Int,
                   let start = Calendar.current.date(bySettingHour: sh, minute: 0, second: 0, of: day),
                   let end = Calendar.current.date(bySettingHour: eh, minute: 0, second: 0, of: day) {
                    e.startDate = start
                    e.endDate = end
                } else {
                    e.isAllDay = true
                    e.startDate = day
                    let span = max(1, (ev["days"] as? NSNumber)?.intValue ?? 1)
                    e.endDate = Calendar.current.date(byAdding: .day, value: span - 1, to: day) ?? day
                }
                do { try self.store.save(e, span: .thisEvent, commit: false); added += 1 } catch {}
            }
            do { try self.store.commit() } catch {}
            call.resolve(["added": added])
        }

        if #available(iOS 17.0, *) {
            store.requestWriteOnlyAccessToEvents { granted, _ in DispatchQueue.main.async { finish(granted) } }
        } else {
            store.requestAccess(to: .event) { granted, _ in DispatchQueue.main.async { finish(granted) } }
        }
    }
}
