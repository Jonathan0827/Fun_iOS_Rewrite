//
//  UserStuffs.swift
//  Fun
//
//  Created by 임준협 on 1/11/24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

func googleLogin(doReturn: @escaping (UserData) -> Void) {
    guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
    cprint("Starting Login...", "Google Login", false)
    // 로그인 진행
    GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
        guard let result = signInResult else {
            //                    isAlert = true
            cprint("Login Failed: \(error?.localizedDescription ?? "Unknown Error")", "Google Login", true)
            return
        }
        guard let profile = result.user.profile else { return }
        let data = UserData(iURL: profile.imageURL(withDimension: 180)!, sub: result.user.userID!, email: profile.email, name: profile.name)
        saveKeyChain("sub", data.sub)
        saveKeyChain("name", data.name)
        saveKeyChain("email", data.email)
        saveKeyChain("iURL", data.iURL.absoluteString)
        doReturn(data)
//        sub = data.sub
//        email = data.email
//        name = data.name
//        iURL = data.iURL
    }
}
func apiLogin(_ sub: String, doReturn: @escaping(Dictionary<String, Any>) -> Void) {
    sendGET(auth: generateToken(sub).out, endpoint: "login", sub: sub) { r in
        doReturn(r)
    }
}
class UserData: ObservableObject {
    @Published var iURL: URL
    @Published var sub: String
    @Published var email: String
    @Published var name: String
    init(iURL: URL, sub: String, email: String, name: String) {
        self.iURL = iURL
        self.sub = sub
        self.email = email
        self.name = name
    }
}
