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
    @State private var pImg: Image!
    @State private var showLogOutView = false
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
                            NavigationLink(destination: AccountView(), label: {
                                
                                
                                PrefsThing(toRender:
                                            NavigationLink(destination: AccountView(), label: {
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
        .alert("로그아웃 하시겠습니까?", isPresented: $showLogoutAlert) {
            Button("로그아웃", role: .destructive) {
                showLogOutView = true
            }
            Button("취소", role: .cancel) {
                showLogoutAlert = false
            }
        }
        .onAppear {
            if iURL.absoluteString == "https://" {
                pImg = Image(systemName: "person.circle")
            } else {
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
    var body: some View {
        ZStack{
            Color(.goodBG)
                .ignoresSafeArea()
            VStack {
                Text("개발 중 입니다.")
            }
        }
        .navigationTitle("계정 설정")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton())
    }
}

struct LogoutView: View {
    var body: some View {
        VStack {
            
        }
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
