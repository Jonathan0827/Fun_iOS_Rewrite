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
    let isNav: Bool
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(uiColor: UIColor.systemGray6))
//                .fill(.goodGray)
                .frame(height: 45)
            HStack {
                toRender
                    .foregroundStyle(.cprimary)
                Spacer()
                if isNav {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
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
                                                .frame(width: 27, height: 27)
                                        }
                                    }
                                }), isNav: true)
                            })
                        }
                        .padding(.horizontal)
                        Section(header: Label("피드백", systemImage: "bubble.left.and.exclamationmark.bubble.right").foregroundColor(.secondary).font(.caption)) {
                            Button(action: {
                                vp.showFeedback = true
                            }, label: {
                                PrefsThing(toRender: Label("피드백 제출", systemImage: "paperplane.fill"), isNav: false)
                            })
                        }
                        .padding(.horizontal)
                        Section(header: Label("고급", systemImage: "gearshape.2").foregroundColor(.secondary).font(.caption)) {
                            PrefsThing(toRender: Toggle(isOn: $SC) {
                                Label("콘솔", systemImage: "ladybug")
                            }, isNav: false)
                            .padding(.bottom, -5)
                            NavigationLink(destination: AnalysisView(), label: {
                                PrefsThing(toRender: Label("오류 로그", systemImage: "text.document.fill")
                                , isNav: true)
                            })
                                .padding(.bottom, -5)
                            NavigationLink(destination: DevMenu(), label: {
                                PrefsThing(toRender: Label("개발자 메뉴", systemImage: "hammer.fill")
                                , isNav: true)
                            })
                        }
                        .padding(.horizontal)
                    }
                    .backgroundStyle(Color.gray)
                    .navigationTitle("설정")
                }
            }
        }
        .sheet(isPresented: $vp.showFeedback, content: {
            feedbackView()
        })
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

