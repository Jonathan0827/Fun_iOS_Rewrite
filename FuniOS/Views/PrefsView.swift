//
//  AboutView.swift
//  Fun
//
//  Created by 임준협 on 1/8/24.
//

import SwiftUI
import AlertToast

struct PrefsThing<Content>: View where Content: View {
    var toRender: Content
    //    var toRenderTrail: Content!
    let isNav: Bool
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(uiColor: UIColor.systemGray6))
                .frame(height: 50)
            HStack {
                toRender
                    .foregroundStyle(.cprimary)
                Spacer()
                //                toRenderTrail
                //                    .foregroundStyle(.cprimary)
                if isNav {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.goodGray)
                }
            }
            .padding(.horizontal, 10)
        }
    }
    
}

struct PrefsView: View {
    @AppStorage("sub") private var sub: String = ""
    @AppStorage("name") private var name: String = ""
    @AppStorage("iURL") private var iURL: URL = URL(string: "https://")!
    @AppStorage("ShowConsole") var SC: Bool = false
    @State private var pImg: Image! = nil
    
    @State var showLogoutAlert = false
    @State var showAnalysisView = false
    @EnvironmentObject var vp: vps
    init() {
       UITableView.appearance().separatorStyle = .none
       UITableViewCell.appearance().backgroundColor = .green
       UITableView.appearance().backgroundColor = .green
    }
    var body: some View {
        
        NavigationView {
            ZStack {
                Color(.goodBG)
                    .ignoresSafeArea()
                ScrollView {
                    //                Image(systemName: "gear")
                    //                    .resizable()
                    //                    .frame(width: 80, height: 80, alignment: .center)
//                    List {
                    LazyVStack(alignment: .leading) {
                        Section(header: Label("계정", systemImage: "person").foregroundColor(.secondary).font(.caption)) {
                            NavigationLink(destination: AccountView(pImg: $pImg), label: {
                                
                                
                                PrefsThing(toRender:
                                            NavigationLink(destination: AccountView(pImg: $pImg), label: {
                                    Label{
                                        Text("\(name == "" ? "로그아웃 되었습니다" : name)")
                                            .fontWeight(.semibold)
                                    } icon: {
                                        if pImg != nil {
                                            pImg
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .cornerRadius(10)
                                        } else {
                                            Image(systemName: "person.circle")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                        }
                                    }
                                }), isNav: true)
                            })
                        }
                        .padding(.horizontal)
                        Section(header: Label("디버깅", systemImage: "gearshape.2").foregroundColor(.secondary).font(.caption)) {
                            NavigationLink(destination: AnalysisView(), label: {
                                PrefsThing(toRender: Label("오류 로그", systemImage: "hammer.fill")
                                , isNav: true)
                            })
                                .padding(.bottom, -5)
                            PrefsThing(toRender: Toggle(isOn: $SC) {
                                Label("콘솔", systemImage: "ladybug")
                            }, isNav: false)
//                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
//                        Section(header: Label("Console", systemImage: "ladybug")) {
//                            Toggle("Console", isOn: $SC)
//                        }
                        
                        
                    }
                    .backgroundStyle(Color.gray)
                    
//                    .foregroundColor(.cprimary)
//                    .onAppear{
//                        UITableView.appearance().backgroundColor = .goodBG
//                    }
//                    .listStyle(.insetGrouped)
                    .navigationTitle("설정")
//                    .sheet(isPresented: $showAnalysisView, content: {
//                        AnalysisView()
//                    })
                }
            }
        }
        
        .onAppear {
            if iURL.absoluteString != "https://" {
                getImage(iURL) { i in
                    pImg = Image(uiImage: i)
                }
            }
        }
        .onChange(of: SC) { nv in
            cMan.isVisible = nv
        }
    }
}

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
                        .shadow(color: sColor, radius: 5)
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
//                let a = {
//                    var b = 0
//                    colorA.forEach { i in
//                        b += Int(i)
//                    }
//                    return b
//                }
//                withAnimation {
//                    if a() < 380 {
//                        bColor = Color.white
//                    } else {
//                        bColor = Color.black
//                    }
//                }
            } else {
//                print("Image is blank - Using .goodGray for background", "AccountView", false)
//                withAnimation {
//                    aColor = Color(UIColor.goodGray)
//                    bColor = Color.primary
//                }
            }
        }
        .navigationTitle("계정 설정")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct LogoutView: View {
    @Binding var showLogOutView: Bool
    @State var showBtns = true
    var body: some View {
        ZStack {
            Color.goodBG.opacity(0.2).ignoresSafeArea()
            VStack {
                Text("로그아웃 하시겠습니까?")
                    .font(.title)
                    .fontWeight(.bold)
                if showBtns {
                    HStack {
                        Button(action: {
                            showLogOutView = false
                        }, label: {
                            Text("취소")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(width: 140, height: 50)
                                .background(RoundedRectangle(cornerRadius: 15).fill(.goodGray))
                        })
                        
                        .padding(.horizontal, 2.5)
                        Button(action: {
                            logOut()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                withAnimation {
                                    showBtns = false
                                }
                            })
                        }, label: {
                            Text("로그아웃")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(width: 110, height: 50)
                                .background(RoundedRectangle(cornerRadius: 15).fill(UIColor.systemRed.uc().opacity(0.2)))
                        })
                        .padding(.horizontal, 2.5)
                    }
                } else {
                    Label("로그아웃 되었습니다.", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(5)
                        .font(.caption)
                        .background {
                            Capsule()
                                .fill(UIColor.systemGreen.uc())
                        }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: {
                                showLogOutView = false
                            })
                        }
                }
            }
        }
        .foregroundColor(.cprimary)
        .interactiveDismissDisabled(true)
    }
}

struct AnalysisView: View {
    @State private var errLogsStr = ""
    @EnvironmentObject var vp: vps
    var body: some View {
        ZStack{
            Color(.goodBG)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("오류 로그")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, -3)
                ScrollView {
                    Text(errLogsStr)
                        .font(.system(.caption2, design: .monospaced))
                        .padding()
                }
                .frame(width: 300, height: 300, alignment: .leading)
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 15).fill(.goodGray))
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                HStack {
                    Button(action: {
                        UIPasteboard.general.string = errLogsStr
                        self.vp.toast = AlertToast(displayMode: .hud, type: .systemImage("checkmark.circle.fill", .green), title: "복사됨")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.vp.showToast = true
                        }
                    }, label: {
                        //                        Text("복사")
                        Label("복사", systemImage: "list.bullet.clipboard")
                            .fontWeight(.bold)
                            .frame(width: 158.5)
                            .padding(.vertical)
                            .background(RoundedRectangle(cornerRadius: 15).fill(.goodGray))
                        
                    })
                    .padding(.horizontal, 2.5)
                    //                Button(action: {
                    ////                    let av = UIActivityViewController(activityItems: [errLogsStr], applicationActivities: nil)
                    ////                    UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                    //                }, label: {
                    //                        Text("공유")
                    ShareLink(item: urlDocument("error.log")) {
                        Label("공유", systemImage: "square.and.arrow.up")
                            .fontWeight(.bold)
                            .frame(width: 158.5)
                            .padding(.vertical)
                            .background(RoundedRectangle(cornerRadius: 15).fill(.goodGray))
                    }
                    .padding(.horizontal, 2.5)
                    //                })
                }
                .foregroundColor(.cprimary)
                Button(action: {
                    saveDocument("error.log", "")
                    let errLogsArr = sepDocument("error.log")
                    if errLogsArr == [""] {
                        errLogsStr = "현재까지 로그된 오류가 없습니다."
                    } else {
                        errLogsArr.forEach { v in
                            errLogsStr += "\(v)\n"
                        }
                    }
                }, label: {
                    Label("로그 삭제", systemImage: "trash")
                        .frame(width: 300)
                        .font(.headline)
                        .padding()
                        .foregroundColor(UIColor.systemRed.uc())
                        .background(RoundedRectangle(cornerRadius: 15).fill(UIColor.systemRed.uc().opacity(0.2)))
                })
                .padding(5)
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            
            let errLogsArr = sepDocument("error.log")
            if errLogsArr == [""] {
                errLogsStr = "현재까지 로그된 오류가 없습니다."
            } else {
                errLogsArr.forEach { v in
                    errLogsStr += "\(v)\n"
                }
            }
        }
    }
}
