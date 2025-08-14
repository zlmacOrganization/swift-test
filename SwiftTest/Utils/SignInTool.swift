//
//  SignInTool.swift
//  FangYouQuan
//
//  Created by ZhangLiang on 2020/6/29.
//  Copyright © 2020 sujp01. All rights reserved.
//

import UIKit
import AuthenticationServices

final class SignInTool: NSObject {
    static let shareInstance = SignInTool()
    
    private override init() {
        
    }
    
    func signInWithApple() {
        if #available(iOS 13.0, *) {
            SwiftNotice.wait()
            
            let provider = ASAuthorizationAppleIDProvider()
            
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            performAuthRequest(request: request)
        }
    }
    
    @available(iOS 13.0, *)
    private func performAuthRequest(request: ASAuthorizationAppleIDRequest) {
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
}

//MARK: - ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension SignInTool: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return getKeyWindow() ?? UIWindow()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        SwiftNotice.clear()
        debugPrint("credential: \(authorization.credential) ++++")
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = credential.user
            
            guard let identityToken = credential.identityToken else { return }
                        
            let token = String(data: identityToken, encoding: .utf8)
            debugPrint("token: \(token ?? "")")
            
            do {
                try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
            } catch {
                print("Unable to save userIdentifier to keychain.")
            }
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            debugPrint("user: \(passwordCredential.user), passowrd: \(passwordCredential.password)")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        SwiftNotice.clear()
        debugPrint("didCompleteWithError: \(error.localizedDescription)")
        
        if let e = error as? ASAuthorizationError {
            switch e.code {
            case .canceled:
                SwiftNotice.showText("User did cancel authorization.")
                debugPrint("User did cancel authorization.")
                return
            case .failed:
                SwiftNotice.showText("Authorization failed.")
                debugPrint("Authorization failed.")
            case .invalidResponse:
                SwiftNotice.showText("Authorization returned invalid response.")
                debugPrint("Authorization returned invalid response.")
            case .notHandled:
                SwiftNotice.showText("Authorization not handled.")
                debugPrint("Authorization not handled.")
            case .unknown:
                if controller.authorizationRequests.contains(where: { $0 is ASAuthorizationPasswordRequest }) {
                    SwiftNotice.showText("Unknown error with password auth, trying to request for appleID auth..")
                    debugPrint("Unknown error with password auth, trying to request for appleID auth..")

                    let requestAppleID = ASAuthorizationAppleIDProvider().createRequest()
                    requestAppleID.requestedScopes = [.email, .fullName]
                    requestAppleID.requestedOperation = .operationImplicit
                    performAuthRequest(request: requestAppleID)
                    return
                } else {
                    SwiftNotice.showText("Unknown error for appleID auth.")
                    debugPrint("Unknown error for appleID auth.")
                }
            default:
                SwiftNotice.showText("Unsupported error code.")
                debugPrint("Unsupported error code.")
            }
        }
    }
}
