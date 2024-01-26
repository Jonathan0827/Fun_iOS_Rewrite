//
//  SignUpAlert.swift
//  Fun
//
//  Created by 임준협 on 1/25/24.
//

import SwiftUI

struct SignUpAlert: View {
    @EnvironmentObject private var vp: vps
    @State private var showBtns: Bool = true
    @State private var showLoading: Bool = false
    @State private var showSuccess: Bool = false
    @AppStorage("sub") private var sub: String = ""
    @AppStorage("name") private var name: String = ""
    @AppStorage("email") private var email: String = ""
    @AppStorage("iURL") private var iURL: URL = URL(string: "https://")!
    var body: some View {
        ZStack {
            Color.clear.opacity(0.5)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("가입되어 있지 않은 계정입니다")
                    .font(.title)
                    .bold()
                Text("가입 하시겠습니까?")
                    .font(.title2)
                    .padding()
                    .bold()
                HStack {
                    Spacer()
                    if showBtns {
                        Button(action: {
                            logoutKeyChain()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.vp.showTabBar = true
                                self.vp.showSignUp = false
                            }
                        }, label: {
                            Text("아니오")
                                .frame(width: 100)
                                .font(.headline)
                                .padding()
                                .foregroundColor(UIColor.systemRed.uc())
                                .background(RoundedRectangle(cornerRadius: 15).fill(UIColor.systemRed.uc().opacity(0.2)))
                        })
                        .padding()
                        Button(action: {
                            withAnimation {
                                
                                showLoading = true
                                showBtns = false
                            }
                            
                        }, label: {
                            Text("예")
                                .frame(width: 100)
                                .font(.headline)
                                .padding()
                                .foregroundColor(UIColor.systemBlue.uc())
                                .background(RoundedRectangle(cornerRadius: 15).fill(UIColor.systemBlue.uc().opacity(0.2)))
                        })
                    }
                    if showLoading {
                        ProgressView()
                            .foregroundColor(.cprimary)
                            .progressViewStyle(CircularProgressViewStyle())
                            .onAppear {
                                sendPOST(auth: generateToken(readKeyChain("sub")).out, endpoint: "signup", sub: readKeyChain("sub")) { _ in
//                                    if !(oV["wasUser"] as! Bool) {
                                    withAnimation {
                                        showLoading = false
                                        showSuccess = true
                                        
                                    }
//                                    } else {
//                                        withAnimation {
//                                            self.vp.showSignUp = false
//                                        }
//                                    }
                                }
                            }
                    }
                    if showSuccess {
                        Label("가입되었습니다!", systemImage: "checkmark.circle.fill")
                            .font(.title)
                            .bold()
                            .padding()
                            .foregroundColor(.cprimary)
//                            .background(RoundedRectangle(cornerRadius: 15).fill(Color(uiColor: UIColor.systemGreen).opacity(0.2)))
                            .onAppear {
                                sub = readKeyChain("sub")
                                name = readKeyChain("name")
                                email = readKeyChain("email")
                                iURL = URL(string: readKeyChain("iURL"))!
                                print(iURL)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        self.vp.showTabBar = true
                                        self.vp.showSignUp = false
                                    }
                                }
                            }
                    }
                    Spacer()
                }
                Spacer()
            }
//            .frame(width: 300, height: 200)
//            .background(RoundedRectangle(cornerRadius: 20).fill(.goodBG))
            
        }
    }
}
