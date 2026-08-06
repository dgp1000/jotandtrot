import UIKit
import Capacitor
import WebKit

class MyViewController: CAPBridgeViewController {
    override open func capacitorDidLoad() {
        bridge?.registerPluginInstance(AppleSignInPlugin())
        hideKeyboardAccessoryBar()
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // the WKContent view can attach after capacitorDidLoad — re-apply to be sure
        hideKeyboardAccessoryBar()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.hideKeyboardAccessoryBar()
        }
    }

    /// Remove WKWebView's keyboard accessory bar (the ↑ ↓ ✓ strip above the keyboard).
    /// Standard runtime technique: swap the WKContent view's class for a subclass whose
    /// inputAccessoryView is nil.
    private func hideKeyboardAccessoryBar() {
        guard let webView = bridge?.webView else { return }
        guard let target = webView.scrollView.subviews.first(where: {
            String(describing: type(of: $0)).hasPrefix("WKContent")
        }) else { return }
        let className = "\(type(of: target))_NoAccessoryBar"
        var newClass: AnyClass? = NSClassFromString(className)
        if newClass == nil {
            newClass = objc_allocateClassPair(type(of: target), className, 0)
            guard let created = newClass else { return }
            if let original = class_getInstanceMethod(UIView.self, #selector(getter: UIView.inputAccessoryView)) {
                let block: @convention(block) (AnyObject) -> UIView? = { _ in nil }
                class_addMethod(created, #selector(getter: UIView.inputAccessoryView),
                                imp_implementationWithBlock(block),
                                method_getTypeEncoding(original))
            }
            objc_registerClassPair(created)
        }
        if let cls = newClass { object_setClass(target, cls) }
    }
}
