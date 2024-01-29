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
    @State var viewSize = [CGSize]()
    @State private var sd: Bool = true
    @Binding var showTabBar: Bool
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var vp: vps
    var body: some View {
        NavigationView {
            ZStack {
                Color(.goodBG)
                    .ignoresSafeArea()
                VStack {
                    AccountWidget(data: UserData(iURL: iURL, sub: sub, email: email, name: name), reload: reloadView)
                    
                    PSWidget()
                        .foregroundStyle(.cprimary)
                        .saveSize(in: $viewSize)
                    if TARGET_IPHONE_SIMULATOR == 1 {
                        Toggle("Enable Debug Buttons", isOn: $sd)
                    }
                    if TARGET_IPHONE_SIMULATOR == 1 && sd {
                        Button(action: {
                            dPrint(viewSize)
                        }, label: {
                            Text("View Sizes")
                        })
                        Button(action: {
                            dPrint(vp)
                        }, label: {
                            Text("View Properties")
                        })
                        Button(action: {
                            cprint("------------------<LoginData>------------------")
                            cprint(sub)
                            cprint(name)
                            cprint(email)
                            cprint(iURL)
                            cprint("-----------------------------------------------")
                        }, label: {
                            Text("Print login credentials")
                        })
                        Button(action: {
                            logoutKeyChain()
                            
                        }, label: {
                            Text("Remove login credentials")
                        })
                    }
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
    }
    
}
