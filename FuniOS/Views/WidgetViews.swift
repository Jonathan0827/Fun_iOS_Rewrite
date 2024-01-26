//
//  WidgetViews.swift
//  Fun
//
//  Created by 임준협 on 1/24/24.
//

import Foundation
import SwiftUI
import AlertToast

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image(systemName: "arrowtriangle.left.fill") // set image here
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color("mode"))
                .padding(.trailing, -5)
                .font(.system(size: 8))
            Text("뒤로 가기")
                .foregroundColor(Color("mode"))
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color("cprimary"))
        .clipShape(.capsule)
    }
    }
}

struct AccountWidget: View {
    @ObservedObject var data: UserData
    @State var reload: Bool
    @State private var img: Image!
    @State private var aColor: Color = Color.goodGray
    @State private var colorA: Array<UInt8> = []
    @State private var bColor: Color!
    @State var score: Int!
    @AppStorage("sub") private var sub: String = ""
    @AppStorage("name") private var name: String = ""
    @AppStorage("email") private var email: String = ""
    @AppStorage("iURL") private var iURL: URL = URL(string: "https://")!
    @EnvironmentObject var vp: vps
    var body: some View {
        HStack {
            Spacer()
            if data.iURL != URL(string: "https://")! {
                AsyncImage(url: data.iURL) { image in
                    image
                        .resizable()
                        .frame(width: 95, height: 95)
                        .cornerRadius(43)
                        .onAppear {
                            img = image
                            withAnimation {
                                aColor = Color((img?.asUIImage().averageColor(&colorA))!)
                            }
                            let a = {
                                var b = 0
                                colorA.forEach { i in
                                    b += Int(i)
                                }
                                return b
                            }
                            withAnimation {
                                if a() < 380 {
                                    bColor = Color.white
                                } else {
                                    bColor = Color.black
                                }
                            }
                        }
                } placeholder: {
                    ZStack {
                        ProgressView()
                            .foregroundColor(.primary)
                            .zIndex(1)
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: 95, height: 95)
                            .hidden()
                            .zIndex(0)
                    }
                }
                Spacer()
            }
            
            VStack(alignment: .leading) {
                if data.sub != "" {
                    Text(data.name)
                        .lineLimit(3)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text((score != nil) ? "점수: \(score)점" : "점수: 로딩 중...")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(data.email)
                        .font(.caption)
                        .fontWeight(.ultraLight)
                        .textCase(.uppercase)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: 95, height: 95)
                            .hidden()
                            .zIndex(0)
                        VStack {
                            Text("로그아웃 되었습니다.")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.vertical,20)
                            Button(  action: {
                                googleLogin() { d in
//                                    iURL = d.iURL
//                                    sub = d.sub
//                                    email = d.email
//                                    name = d.name
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
                            }, label: {
                                HStack {
                                    Text("로그인 하기")
                                    Image(systemName: "arrowtriangle.right.fill")
                                }
                                .font(.caption)
                                .foregroundStyle(Color(UIColor.systemBlue))
                            })
                        }
                        .zIndex(1)
                    }
                }
            }
            Spacer()
        }
    
//            .refreshable {
//                reload.toggle()
//            }
            .onAppear {
                if data.sub != "" {
                    let a = generateToken(data.sub)
                    if a.success {
                        sendGET(auth: a.out, endpoint: "getscore", sub: data.sub) { r in
                            score = r["score"] as? Int
                        }
                    } else {
                        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                        UIViewController().present(alert, animated: true)
                    }
                }
            }
            .onChange(of: data.sub) { nd in
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
            .onChange(of: data.iURL) { nd in
                cprint("Image URL changed", "AccountWidget", false)
                if nd.absoluteString != "" && nd != URL(string: "https://")!{
                    print("Getting Image", "AccountWidget", false)
                    getImage(nd) { i in
                        img = Image(uiImage: i)
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
                    img = Image("")
                }
                
            }
            .onChange(of: img) { ni in
                print("Image changed", "AccountWidget", false)
                if ni != Image("") {
                    print("Image is regular image - Getting average color", "AccountWidget", false)
                    withAnimation {
                        aColor = Color((ni?.asUIImage().averageColor(&colorA))!)
                    }
                    let a = {
                        var b = 0
                        colorA.forEach { i in
                            b += Int(i)
                        }
                        return b
                    }
                    withAnimation {
                        if a() < 380 {
                            bColor = Color.white
                        } else {
                            bColor = Color.black
                        }
                    }
                } else {
                    print("Image is blank - Using .goodGray for background", "AccountWidget", false)
                    withAnimation {
                        aColor = Color(UIColor.goodGray)
                        bColor = Color.primary
                    }
                }
            }
            .padding(.vertical,20)
//            .background(aColor.opacity(0.9))
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(aColor)
                    .frame(height: 140)
                    
            )
            .foregroundColor(bColor)
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.5), radius: 15)
            .padding(20)
//        }
//        .padding()
    }
}
struct PSWidget: View {
    @State var pCount: Int = 0
    @State var showQC: Bool = false
    var body: some View {
        HStack {
            Spacer()
            VStack{
                Spacer()
                Text("문제 풀이")
                    .font(.title)
                    .fontWeight(.bold)
                if showQC {
                    Text("\(pCount)개의 문제를 풀어보세요!")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            Spacer()
        }
        .onAppear {
            getQuests { qL in
                pCount = qL.count
                withAnimation {
                    showQC = true
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(UIColor.goodGray))
                .frame(height: 140)
        )
        
        .cornerRadius(30)
        .shadow(color: .black.opacity(0.5), radius: 20)
        .padding(.horizontal,20)
    }
}
