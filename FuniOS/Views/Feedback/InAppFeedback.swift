//
//  InAppFeedback.swift
//  FuniOS
//
//  Created by 임준협 on 2/15/24.
//
import SwiftUI
import AlertToast

struct inAppFeedbackView: View {
    @AppStorage("sub") private var sub: String = ""
    @AppStorage("name") private var name: String = ""
    @AppStorage("email") private var email: String = ""
    @State private var title = ""
    @State private var message = ""
    @State private var agreements = [false, false]
    @State private var type = 0
    @State private var isURL = ""
    var isEditingTitle: FocusState<Bool>.Binding
    var isEditingBody: FocusState<Bool>.Binding
    @State var showConfirm = true
    @EnvironmentObject var vp: vps
    @State var showSuccess: Bool = false
    @State private var result: Dictionary<String, Any> = [:]
    @State private var loading: Bool = false
    @State var showSuccessSymbol: Bool = false
    var body: some View {
        //        ScrollView {
//        ZStack {
//            Color.goodBG.ignoresSafeArea()
//                .onTapGesture {
//                    withAnimation {
//                        isEditingTitle.wrappedValue = false
//                        isEditingBody.wrappedValue = false
//                    }
//                }
            if sub != "" {
//                NavigationView {
//                    NavigationLink(isActive: $showSuccess, destination: {
                if showSuccess {
                        VStack {
                            HStack {
//                                Spacer()a
//                                if showSuccessSymbol {
                                    Image(systemName: "checkmark.circle.fill")
//                                        .resizable()
                                        .symbolRenderingMode(.monochrome)
                                        .font(.system(size: 30))
                                        .transition(.scale)
//                                }
                                
                                Text("감사합니다!")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 2.5)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                            withAnimation {
                                                showSuccessSymbol.toggle()
                                            }
                                        }
                                    }
//                                Spacer()
                            }
                            if isURL != "" {
                                Link("피드백 열기", destination: URL(string: isURL)!)
                                    .font(.caption)
                            } else {
                                Text(":(")
                            }
                        }
                        .background(.goodBG)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                                withAnimation {
                                    vp.showFeedback = false
                                }
                            })
                        }
                                                }
//                        .navigationBarBackButtonHidden(true)
//                    }, label: {
//                        EmptyView()
//                    })
                else {
                    ZStack {
                        if !showSuccess {
                            Color.goodBG.ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation {
                                        isEditingTitle.wrappedValue = false
                                        isEditingBody.wrappedValue = false
                                    }
                                }
                        }
                        VStack {
                            //                    NavigationLink(isActive: $showSuccess, destination: {
                            //                        Text("success")
                            //                    }, label: {
                            //                        EmptyView()
                            //                    })
                            //                Text("인앱 피드백")
                            //                    .font(!(isEditingBody.wrappedValue || isEditingTitle.wrappedValue) ? .largeTitle : .headline)
                            //                    .fontWeight(.bold)
                            
                            TextField("제목", text: $title)
                            
                                .frame(height: 50)
                                .padding(.horizontal)
                                .background(RoundedRectangle(cornerRadius: 15).fill(.goodGray))
                                .padding(.bottom, 5)
                                .padding(.horizontal, 20)
                                .focused(isEditingTitle)
                                .submitLabel(.next)
                                .onSubmit {
                                    isEditingBody.wrappedValue = true
                                }
                            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                                
                                
                                TextEditor(text: $message)
                                    .scrollContentBackground(.hidden)
                                    .frame(height: 250)
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 10)
                                    .background(RoundedRectangle(cornerRadius: 20).fill(.goodGray))
                                    .padding(.horizontal, 20)
                                    .focused(isEditingBody)
                                if message == "" {
                                    Text("내용")
                                        .foregroundColor(Color.label)
                                    //                        .foregroundColor(.secondary)
                                        .padding(.all)
                                        .padding(.horizontal, 20)
                                }
                            }
//                            Picker("피드백 종류", selection: $type, content: {
//                                Text("버그").tag(0)
//                                Text("기능 제안").tag(1)
//                                Text("기타").tag(2)
//                                Text("보안").tag(3)
//                            })
//                            .pickerStyle(.segmented)
//                            .padding(.horizontal, 20)
//                            .padding(.vertical, 5)
                            Spacer()
                            //                if showConfirm {
                            Button(action: {
                                if type == 3 {
                                    var components = URLComponents()
                                    components.scheme = "mailto"
                                    components.path = "security@react.kro.kr"
                                    components.queryItems = [
                                        URLQueryItem(name: "subject", value: title),
                                        URLQueryItem(name: "body", value: message)
                                    ]
                                    guard let url = components.url else {
                                        print("Failed to create mailto URL")
                                        return
                                    }
                                    
                                    UIApplication.shared.open(url)
                                } else {
                                    withAnimation {
                                        loading = true
                                    }
                                    title = title.replacingOccurrences(of: " · ", with: "( · )")
                                    sendPOST(auth: generateToken(sub).out, endpoint: "report", sub: sub, params: ["title": title, "message": message, "name": name]) { r in
                                        isURL = r["issueURL"] as! String
                                        result = r
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            withAnimation {
                                                showSuccess = true
                                            }
                                        }
                                    }
                                }
                            }, label: {
                                if !loading {
                                    Text(type != 3 ? "제출" : "이메일 열기")
                                        .fontWeight(.bold)
                                        .frame(width: 300)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(RoundedRectangle(cornerRadius: 20)
                                            .fill(((title == "" || message == "") && type != 3 ) ? UIColor.systemGray4.uc() : UIColor.systemBlue.uc())
                                        )
                                } else {
                                    HStack {
                                        
                                        ProgressView()
                                            .fontWeight(.bold)
                                            .frame(width: 300)
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(RoundedRectangle(cornerRadius: 20)
                                                .fill(UIColor.systemGray4.uc())
                                            )
                                    }
                                }
                                //                    .font(type != 3 ? .title : .callout )
                                
                            })
                            .disabled(((title == "" || message == "") && type != 3 ) || loading)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                        }
                    }
                    //            }
                    .onChange(of: isEditingBody.wrappedValue) { nV in
                        withAnimation {
                            showConfirm = !(isEditingTitle.wrappedValue || nV)
                        }
                    }
                    .onChange(of: isEditingTitle.wrappedValue) { nV in
                        withAnimation {
                            showConfirm = !(isEditingBody.wrappedValue || nV)
                        }
                    }
                }
                
                
            } else {
//                ZStack {
//                    Color.goodBG
//                        .onTapGesture {
//                            withAnimation {
//                                isEditingTitle.wrappedValue = false
//                                isEditingBody.wrappedValue = false
//                            }
//                        }
                    VStack {
//                        Spacer()
                        Text("로그인이 필요한 서비스입니다.")
                            .font(.title)
                            .fontWeight(.bold)
                            .onAppear {
                                vp.toast = AlertToast(displayMode: .hud, type: .systemImage("xmark.circle.fill", UIColor.systemRed.uc()), title: "로그인이 필요한 서비스입니다.", subTitle: "설정 또는 홈에서 로그인할 수 있습니다.")
                                vp.showFeedback = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                    withAnimation {
                                        vp.showToast = true
                                    }
                                })
                            }
//                        Spacer()
//                    }
                }.background(.goodBG)
            }
//        }
    }
}
