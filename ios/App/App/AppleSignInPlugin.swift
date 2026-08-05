import Foundation
import Capacitor
import AuthenticationServices

/// Minimal built-in Sign in with Apple plugin — no external dependency.
/// JS: Capacitor.Plugins.AppleSignIn.authorize({ nonce: <sha256 of raw nonce> })
@objc(AppleSignInPlugin)
public class AppleSignInPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "AppleSignInPlugin"
    public let jsName = "AppleSignIn"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "authorize", returnType: CAPPluginReturnPromise)
    ]
    private var savedCall: CAPPluginCall?

    @objc func authorize(_ call: CAPPluginCall) {
        savedCall = call
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        if let nonce = call.getString("nonce") { request.nonce = nonce }
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        DispatchQueue.main.async { controller.performRequests() }
    }
}

extension AppleSignInPlugin: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let cred = authorization.credential as? ASAuthorizationAppleIDCredential,
              let tokenData = cred.identityToken,
              let token = String(data: tokenData, encoding: .utf8) else {
            savedCall?.reject("No identity token returned"); savedCall = nil; return
        }
        savedCall?.resolve([
            "identityToken": token,
            "givenName": cred.fullName?.givenName ?? "",
            "familyName": cred.fullName?.familyName ?? "",
            "email": cred.email ?? ""
        ])
        savedCall = nil
    }

    public func authorizationController(controller: ASAuthorizationController,
                                        didCompleteWithError error: Error) {
        savedCall?.reject("canceled", "1001", error)
        savedCall = nil
    }

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.bridge?.webView?.window ?? ASPresentationAnchor()
    }
}
