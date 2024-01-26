//
//  UnknownStuffs.swift
//  Fun
//
//  Created by 임준협 on 1/24/24.
//

import Foundation
import AlertToast
import SwiftUI

class alertWithDBtn: ObservableObject {
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMsg = ""
    @Published var alertButton = ""
//    init(showAlert: Bool, alertTitle: String, alertMsg: String, alertButton: String) {
//        self.showAlert = showAlert
//        self.alertTitle = alertTitle
//        self.alertMsg = alertMsg
//        self.alertButton = alertButton
//    }
}
class alertWOBtn: ObservableObject {
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMsg = ""
//    init(showAlert: Bool, alertTitle: String, alertMsg: String) {
//        self.showAlert = showAlert
//        self.alertTitle = alertTitle
//        self.alertMsg = alertMsg
//    }
}
class toastSuc: ObservableObject {
    @Published var showToast = false
    @Published var toastTitle = ""
    @Published var toastMsg = ""
//    init(showToast: Bool, toastTitle: String, toastMsg: String) {
//        self.showToast = showToast
//        self.toastTitle = toastTitle
//        self.toastMsg = toastMsg
//    }
}
class toastWarn: ObservableObject {
    @Published var showToast = false
    @Published var toastTitle = ""
    @Published var toastMsg = ""
//    init(showToast: Bool, toastTitle: String, toastMsg: String) {
//        self.showToast = showToast
//        self.toastTitle = toastTitle
//        self.toastMsg = toastMsg
//    }
}
func makeAlert(title: String, message: String? = nil, btnMsg: String? = nil, btnMsg1: String? = nil, btnAction: Void? = nil, btnAction1: Void? = nil) -> Alert {
    if btnMsg != nil && btnMsg1 != nil {
        cprint("Type 1", "makeAlert", false)
        return Alert(title: Text(title), message: Text(message.cin()), primaryButton: .default(Text(btnMsg!), action: {btnAction.cin()}), secondaryButton: .default(Text(btnMsg1!), action: {btnAction1.cin()}))
//        return Alert(title: Text(title), message: Text(message.cin()))
    } else if btnMsg != nil && btnMsg1 == nil {
        cprint("Type 2", "makeAlert", false)
        return Alert(title: Text(title), message: Text(message.cin()), dismissButton: .default(Text(btnMsg!), action: {btnAction.cin()}))
    } else {
        cprint("Type 3", "makeAlert", false)
        return Alert(title: Text(title), message: Text(message.cin()))
    }
}
func makeBanner(title: String, message: String? = nil, image: String? = nil, iColor: Color? = nil) -> AlertToast {
    if image != nil {
        return AlertToast(displayMode: .banner(.slide), type: .systemImage(image!, iColor!), title: title, subTitle: message.cin())
    } else {
        return AlertToast(displayMode: .banner(.slide), type: .regular, title: title, subTitle: message.cin())
    }
}
func makeHUD(title: String, message: String? = nil, image: String? = nil, iColor: Color? = nil) -> AlertToast {
    if image != nil {
        return AlertToast(displayMode: .hud, type: .systemImage(image!, iColor!), title: title, subTitle: message.cin())
    } else {
        return AlertToast(displayMode: .hud, type: .regular, title: title, subTitle: message.cin())
    }
}
