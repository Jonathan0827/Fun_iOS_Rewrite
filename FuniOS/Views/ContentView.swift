//
//  ContentView.swift
//  Fun
//
//  Created by 임준협 on 12/29/23.
//

import SwiftUI
import AlertToast
import Foundation

struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @AppStorage("sub") private var sub: String = ""
    @AppStorage("name") private var name: String = ""
    @AppStorage("email") private var email: String = ""
    @AppStorage("iURL") private var iURL: URL = URL(string: "https://")!
    @AppStorage("ShowConsole") var SC: Bool = false
//    @State var showTabBar = false
    @StateObject private var vp = vps()
    //    @AppStorage("caches") var caches: Dictionary<String, Any>
    //    @EnvironmentObject var alertWDB: alertWithDBtn
    //    @EnvironmentObject var alertWOB: alertWOBtn
    //    @EnvironmentObject var toastS: toastSuc
    //    @EnvironmentObject var toastW: toastWarn
    @State var tabSelection = 0
    let DIP = false
    var body: some View {
        
        ////            .toolbarBackground(Color(uiColor: .systemGray6), for: .tabBar)
        ////            .toolbarBackground(.visible, for: .tabBar)
        //        }
        NavigationView {
            if !DIP {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    //            VStack {
                    Color(.goodBG)
                        .ignoresSafeArea()
                    switch tabSelection {
                    case 0:
                        HomeView()
                            .tabItem {
                                Label("Home", systemImage: "house.fill")
                            }
                            .padding(.bottom, 50)
                            .environmentObject(vp)
                    case 1:
                        PrefsView()
                            .tabItem {
                                Label("Settings", systemImage: "gear")
                            }
                            .padding(.bottom, 50)
                            .environmentObject(vp)
                        //            case 2:
                        //                DevelopmentView()
                        //                    .tabItem {
                        //                        Label("Dev", systemImage: "hammer.fill")
                        //                    }
                        //                    .padding(.bottom, 50)
                    default:
                        Text("Why are you seeing this?")
                            .font(.title)
                            .foregroundColor(.red)
                            .onAppear {
                                cprint("Unknown View Presentation. tS: \(tabSelection)", "ContentView", true)
                                tabSelection = 0
                            }
                    }
                    //            TabView(selection: $tabSelection) {
                    //                Group {
                    //                    HomeView()
                    //                        .tag(0)
                    //                        .environmentObject(vp)
                    //                        .ignoresSafeArea()
                    //                    //                .environmentObject(alertWDB)[
                    //                    //                .environmentObject(alertWOB)
                    //                    //                .environmentObject(toastS)
                    //                    //                .environmentObject(toastW)]
                    //                    //                            .tabItem {
                    //                    //                                Label("Home", systemImage: "house.fill")
                    //                    //                            }
                    //
                    //
                    //                    PrefsView()
                    //                        .tag(1)
                    //                        .environmentObject(vp)
                    //                        .ignoresSafeArea()
                    //                    //                            .tabItem {
                    //                    //                                Label("Settings", systemImage: "gear")
                    //                    //                            }
                    //                    //                .environmentObject(alertWDB)
                    //                    //                .environmentObject(alertWOB)
                    //                    //                .environmentObject(toastS)
                    //                    //                .environmentObject(toastW)
                    //                    //                        DevelopmentView()
                    //                    //                            .tabItem {
                    //                    //                                Label("Dev", systemImage: "hammer.fill")
                    //                    //                            }
                    //                }
                    //            }
                    //            .toolbarBackground(Color.purple, for: .tabBar)
                    //                    .toolbar(.hidden, for: .tabBar)
                    //                    .ignoresSafeArea()
                    //            VStack {
                    //                Spacer()
                    if self.vp.showTabBar {
                        fancyTabBar(selectedTab: $tabSelection, tabs: [["Home": "house.fill"], ["Settings": "gear"]])
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.1), value: self.vp.showTabBar)
                            .ignoresSafeArea(.keyboard)
                    }
                    
                    //            }
                    if self.vp.showSignUp {
                        SignUpAlert()
                            .ignoresSafeArea()
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.1), value: true)
                            .environmentObject(vp)
                    }
                    
                }
            } else {
                feedbackView()
                    .environmentObject(vp)
            }

        }
                    .onAppear {
                        UITabBar.appearance().backgroundColor = UIColor.systemGray6
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                self.vp.showTabBar = true
                            }
                        }
                    }
        .toast(isPresenting: self.$vp.showToast, alert: {
            self.vp.toast
        })
        .onAppear {
            cMan.isVisible = SC
            cprint("""
 <혁명적인 언어 류희 프로그람!>
  ______ _    _ _   _
 |  ____| |  | | \\ | |
 | |__  | |  | |  \\| |
 |  __| | |  | | . ` |
 | |    | |__| | |\\  |
 |_|     \\____/|_| \\_|
 <혁명적인 언어 류희 프로그람!>
""")
            watchDog(&sub, &email, &iURL, &name, nv: nil)
            //            watchDog(nv: nil)
        }
        .onChange(of: sub, perform: { value in
            watchDog(&sub, &email, &iURL, &name, nv: value)
            
        })
        .onChange(of: email, perform: { value in
            watchDog(&sub, &email, &iURL, &name, nv: value)
        })
        .onChange(of: iURL, perform: { value in
            watchDog(&sub, &email, &iURL, &name, nv: value.absoluteString)
        })
        .onChange(of: name, perform: { value in
            watchDog(&sub, &email, &iURL, &name, nv: value)
        })
    }
}
