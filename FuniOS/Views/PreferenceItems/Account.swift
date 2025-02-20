//
//  Items.swift
//  FuniOS
//
//  Created by 임준협 on 2/6/24.
//

import SwiftUI
import AlertToast

struct AccountView: View {
    @AppStorage("name") private var name: String = ""
    @AppStorage("iURL") private var iURL: URL = URL(string: "https://")!
    @AppStorage("sub") private var sub: String = ""
    @AppStorage("email") private var email: String = ""
    @State private var showLogOutView = false
    @Binding var pImg: Image!
    @State private var score: Int!
    @State private var sColor: Color = .black
    @EnvironmentObject var vp: vps
    var body: some View {
        ZStack{
            Color(.goodBG)
                .ignoresSafeArea()
            VStack {
                if pImg != nil {
                    pImg
                        .resizable()
                        .frame(width: 150, height: 150)
                        .cornerRadius(150)
//                        .shadow(color: sColor, radius: 5)
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 150, height: 150)
                        
                }
                Text(name == "" ? "로그아웃 되었습니다" : name)
                    .font(.title3)
                    .fontWeight(.bold)
                if sub != "" {
                    Text((score != nil) ? "점수: \(score)점" : "점수: 로딩 중...")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("\(email)")
                        .font(.caption)
                        .fontWeight(.light)
                        .textCase(.uppercase)
                }
                ScrollView {
                    VStack {
                        if sub == "" {
                            PrefsThing(toRender: Label("로그인", systemImage: "link.icloud.fill"), isNav: false)
                                .onTapGesture {
                                    googleLogin() { d in
                                        apiLogin(d.sub) { r in
                                            if (r["isUser"] as! Bool) {
                                                cprint("Logged in", "apiLogin", false)
                                                iURL = d.iURL
                                                sub = d.sub
                                                email = d.email
                                                name = d.name
                                                self.vp.toast = AlertToast(displayMode: .hud, type: .systemImage("checkmark.circle.fill", Color(UIColor.systemGreen)), title: "로그인 성공!")
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                                    withAnimation {
                                                        self.vp.showToast = true
                                                    }
                                                })
                                            } else {
                                                cprint("User not found", "apiLogin", false)
                                                withAnimation {
                                                    self.vp.showSignUp = true
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                        if sub != "" {
                            PrefsThing(toRender: Label("로그아웃", systemImage: "xmark.icloud.fill"), isNav: false)
                                .onTapGesture {
                                    showLogOutView = true
                                }
                        }
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showLogOutView, content: {
            LogoutView(showLogOutView: $showLogOutView)
        })
        
        .onAppear {
            if iURL.absoluteString == "https://" {
                pImg = Image(systemName: "person.circle")
            } else {
                getImage(iURL) { i in
                    pImg = Image(uiImage: i)
                }
            }
            if sub != "" {
                let a = generateToken(sub)
                if a.success {
                    sendGET(auth: a.out, endpoint: "getscore", sub: sub) { r in
                        score = r["score"] as? Int
                    }
                } else {
                    let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                    UIViewController().present(alert, animated: true)
                }
            }
        }
        .onChange(of: sub) { nd in
            print("user id changed")
            score = nil
            if nd != "" {
                let a = generateToken(nd)
                sendGET(auth: a.out, endpoint: "getscore", sub: nd) { r in
                    score = r["score"] as? Int
                    print(r)
                }
            }
            
            print("re-fetched score, applyng...")
        }
        .onChange(of: iURL) { nd in
            cprint("Image URL changed", "AccountView", false)
            if nd.absoluteString != "" && nd != URL(string: "https://")!{
                print("Getting Image", "AccountView", false)
                getImage(nd) { i in
                    pImg = Image(uiImage: i)
//                        withAnimation {
//                            aColor = Color((img?.asUIImage().averageColor(&colorA))!)
//                        }
                }
            } else {
//                    image.fromURLString("https://httpcats.com/404.jpg") { i in
//                        img = Image(uiImage: i)
//                    }
//                    getImage(URL(string: "https://httpcats.com/404.jpg")!) { i in
//                        img = Image(uiImage: i)
//
//                    }
                pImg = nil
            }
            
        }
        .onChange(of: pImg) { ni in
            print("Image changed", "AccountView", false)
            if ni != Image("") {
                print("Image is regular image - Getting average color", "AccountView", false)
                withAnimation {
                    sColor = Color(uiColor: ni?.asUIImage().averageColorWOVtc() ?? UIColor.black)
                }
            }
        }
        .navigationTitle("계정 설정")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}




