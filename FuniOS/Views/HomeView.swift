//
//  Home.swift
//  Fun
//
//  Created by 임준협 on 12/29/23.
//

import SwiftUI
import SVGView
import GoogleSignIn
import GoogleSignInSwift
import AlertToast

struct HomeView: View {
    @AppStorage("sub") private var sub: String = ""
    @AppStorage("name") private var name: String = ""
    @AppStorage("email") private var email: String = ""
    @AppStorage("iURL") private var iURL: URL = URL(string: "https://")!
    @State var reloadView = false
    @State var showAlert = false
    @State var showBanner = false
    @State var showHud = false
    @State var alertToShow: Alert = Alert(title: Text(""))
    @State var bannerToShow: AlertToast = AlertToast(type: .regular, title: "", subTitle: "")
    @State var hudToShow: AlertToast = AlertToast(type: .regular, title: "", subTitle: "")
    @State private var showSignUp = false
    @Binding var showTabBar: Bool
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var vp: vps
//    @EnvironmentObject var alertWDB: alertWithDBtn
//    @EnvironmentObject var alertWOB: alertWOBtn
//    @EnvironmentObject var toastS: toastSuc
//    @EnvironmentObject var toastW: toastWarn
    var body: some View {
        NavigationView {
            ZStack {
                Color(.goodBG)
                    .ignoresSafeArea()
                VStack {
                    AccountWidget(data: UserData(iURL: iURL, sub: sub, email: email, name: name), reload: reloadView)
                    NavigationLink(destination: PSView()) {
                        PSWidget()
                            .foregroundStyle(.cprimary)
                    }
                    //                NavigationLink(destination: PSView()) {
                    //                    Text("문제 풀이")
                    //                }
                    //                .buttonStyle(fancyButton(bbtn: true))
                    //                Button(action: {
                    //                    googleLogin() { d in
                    //                        sub = d.sub
                    //                        name = d.name
                    //                        email = d.email
                    //                        iURL = d.iURL
                    //                    }
                    //                }, label: {
                    //                    Text("로그인")
                    //                })
                    //                .buttonStyle(fancyButton(bbtn: false))
                    Spacer()
                    Divider()
//                    Button("Test Alert", action: {
//                        //                    alertWDB = alertWithDBtn(showAlert: true, alertTitle: "Test", alertMsg: "Test", alertButton: "Test")
//                        alertToShow = makeAlert(title: "Test", message: "Test", btnMsg: "b1")
//                        showAlert = true
//                    })
//                    Button("Test banner", action: {
//                        bannerToShow = makeBanner(title: "Toast", message: "I like to eat French Toast", image: "checkmark.message.fill", iColor: .cprimary)
//                        withAnimation {
//                            showBanner = true
//                        }
//                    })
//                    Button("Test hud", action: {
//                        self.vp.toast = AlertToast(displayMode: .hud, type: .systemImage("checkmark.circle.fill", Color(UIColor.systemGreen)), title: "로그인 성공!")
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                            withAnimation {
//                                self.vp.showToast = true
//                            }
//                        })
//                    })
//                    Button(action: {
////                        withAnimation() {
////                            showSignUp = true
////                        }
////                        ContentView().hideTabBar()
//                        withAnimation {
//                            self.vp.showTabBar = false
//                            self.vp.showSignUp = true
//                        }
//                    }, label: {
//                        Text("SignUp View")
//                    })
//                    Button(action: {
//                        GIDSignIn.sharedInstance.signOut()
//                        sub = ""
//                        name = ""
//                        email = ""
//                        iURL = URL(string: "https://")!
//                        logoutKeyChain()
//                        //                    saveKeyChain("sub", sub)
//                        //                    saveKeyChain("name", name)
//                        //                    saveKeyChain("email", email)
//                        //                    saveKeyChain("iURL", iURL.absoluteString)
//                        print(iURL)
//                    }, label: {
//                        Text("Remove Login Credentials")
//                    })
//
//                    Button(action: {
//                        cprint("------------------<LoginData>------------------")
//                        cprint(sub)
//                        cprint(name)
//                        cprint(email)
//                        cprint(iURL)
//                        cprint("-----------------------------------------------")
//                    }, label: {
//                        Text("Print login credentials")
//                    })
                    Spacer()
                    Text("Build: \(currentBuildNumber())")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text("Version: \(currentVersion())")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .navigationTitle("Fun")
            }
        }
        .alert(isPresented: $showAlert) {
            alertToShow
        }
        .toast(isPresenting: $showBanner, duration: 2.0) {
            makeBanner(title: "Toast", message: "I like to eat French Toast", image: "checkmark.message.fill", iColor: .cprimary)
        }
        .toast(isPresenting: $showHud, duration: 2.0) {
            hudToShow
        }
//        .alert(isPresented: $showWDB, content: {
//            Alert(title: Text(alertWDB.alertTitle), message: Text(alertWDB.alertMsg), dismissButton: .default(Text(alertWDB.alertButton)))
//        })
//        .alert(isPresented: $alertWOB.showAlert, content: {
//            Alert(title: Text(alertWOB.alertTitle), message: Text(alertWOB.alertMsg))
//        })
//        .toast(isPresenting: $toastS.showToast, alert: {
//            AlertToast(displayMode: .hud, type: .systemImage("checkmark.circle.fill", Color.green), title: toastS.toastMsg, subTitle: toastW.toastMsg)
//        })
//        .toast(isPresenting: $toastW.showToast, alert: {
//            AlertToast(displayMode: .hud, type: .systemImage("exclamationmark.triangle.fill", Color(uiColor: UIColor.systemOrange)), title: toastW.toastMsg, subTitle: toastW.toastMsg)
//        })
    }
    
}
