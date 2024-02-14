
//
//  Feedback.swift
//  FuniOS
//
//  Created by 임준협 on 2/6/24.
//

import SwiftUI
import AlertToast
import Alamofire
import SwiftSoup
struct feedbackView: View {
    @State var feedbackType: Int = 3
    @State var didSelectType = false
    @FocusState private var isEditingTitle
    @FocusState private var isEditingBody
    @State var hideTitle = false
    @State var feedbackViewTitle = ""
    var body: some View {
        ZStack {
            Color.goodBG.ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isEditingTitle = false
                        isEditingBody = false
                    }
                }
            
            //                    } else if feedbackType == 1 {
            //                    emailFeedbackView()
            VStack {
                Spacer()
                if !hideTitle {
                    Text("피드백 제출")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("보안과 관련된 피드백은 security@reacts.kro.kr로 보내주세요")
                        .font(.caption)
                        .fontWeight(.light)
                        .padding(.bottom)
                    //                    Spacer()
                }
                //            if didSelectType {
                switch feedbackType {
                case 1:
                    Text("이메일 앱으로 리다이렉트 됩니다")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.bottom)
                case 2:
                    //                    inApp
                    inAppFeedbackView(isEditingTitle: $isEditingTitle, isEditingBody: $isEditingBody)
                case 3:
                    //                    Get Feedbacks
                    submittedFeedbacksView()
                case 4:
                    //                    Testing
                    inAppFeedbackView(isEditingTitle: $isEditingTitle, isEditingBody: $isEditingBody, showSuccess: true)
                default:
                    VStack {
                        Text("피드백을 보낼 방식을 선택 해주세요")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        HStack {
                            Button(action: {
                                withAnimation {
                                    feedbackType = 1
                                    didSelectType = true
                                    
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    withAnimation {
                                        feedbackViewTitle = "이메일 "
                                    }
                                })
                            }, label: {
                                //                                Text("이메일")
                                Label("이메일", systemImage: "envelope.fill")
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(width: 150, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.goodGray))
                            })
                            .padding(.horizontal, 2.5)
                            Button(action: {
                                withAnimation {
                                    feedbackType = 2
                                    didSelectType = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    withAnimation {
                                        feedbackViewTitle = "인앱 "
                                    }
                                })
                            }, label: {
                                //                                Text("인앱 피드백")
                                Label("인앱 피드백", systemImage: "paperplane.fill")
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(width: 150, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.goodGray))
                                
                            })
                            .padding(.horizontal, 2.5)
                        }
                        Button(action: {
                            withAnimation {
                                feedbackType = 3
                                didSelectType = true
                            }
                        }, label: {
                            //                            Text("제출된 피드백 확인")
                            Label("제출된 피드백 확인", systemImage: "list.bullet.rectangle.portrait.fill")
                                .fontWeight(.bold)
                                .padding()
                                .frame(width: 310, height: 50)
                                .background(RoundedRectangle(cornerRadius: 15).fill(Color.goodGray))
                        })
                        Button("Do TEST", action: {
                            feedbackType = 4
                        })
                    }
                    .foregroundColor(.cprimary)
                }
                //            } else {
                
                //            ZStack {
                
                //                    if feedbackType == 0 {
                
                Spacer()
            }
            //            }
        }
        .onChange(of: isEditingTitle) { nV in
            if nV {
                withAnimation {
                    hideTitle = true
                }
            } else {
                if !isEditingBody {
                    withAnimation {
                        hideTitle = false
                    }
                }
            }
        }
        .onChange(of: isEditingBody) { nV in
            if nV {
                withAnimation {
                    hideTitle = true
                }
            } else {
                if !isEditingTitle {
                    withAnimation {
                        hideTitle = false
                    }
                }
            }
        }
    }
}

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
                                Text("..? 이거 나오면 안되는데")
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
                            Picker("피드백 종류", selection: $type, content: {
                                Text("버그").tag(0)
                                Text("기능 제안").tag(1)
                                Text("기타").tag(2)
                                Text("보안").tag(3)
                            })
                            .pickerStyle(.segmented)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
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
                                    ProgressView()
                                        .fontWeight(.bold)
                                        .frame(width: 300)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(RoundedRectangle(cornerRadius: 20)
                                            .fill(UIColor.systemGray4.uc())
                                        )
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

struct submittedFeedbacksView: View {
    @AppStorage("sub") var sub: String = ""
    @EnvironmentObject var vp: vps
    @State private var result = Dictionary<String, String>()
    @State private var isLoading: Bool = true
    @State private var rIsEmpty: Bool = false
    var body: some View {
//        ZStack {
//            Color.goodBG
            if sub != "" {
                NavigationView {
                    VStack {
                        Spacer()
                        if isLoading {
                            ProgressView()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.cprimary)
                        } else {
                            ScrollView {
                                ForEach(result.sorted(by: >), id: \.key) { title, num in
                                    NavigationLink(destination: {
                                        Text("WIP")
                                    }, label: {
                                        HStack {
                                            VStack(alignment: .leading){
                                                Text(title)
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.cprimary)
                                                Text("https://github.com/Jonathan0827/Fun_iOS_Rewrite/issues/\(num)")
                                                    .font(.caption2)
                                                    .fontWeight(.light)
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding(.leading, 10)
                                            .padding(.vertical, 5)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.secondary)
                                                .padding(.trailing, 10)
                                                .fontWeight(.light)
                                        }
                                        .background(.goodGray)
                                        .cornerRadius(15)
                                        .padding(.horizontal)
                                        .padding(.bottom, 5)
                                    })
                                }
                            }
                        }
                        Spacer()
                    }
                    .navigationBarBackButtonHidden(true)
                }
                .background(.goodBG)
                .onAppear {
                    sendGET(auth: generateToken(sub).out, endpoint: "getreports", sub: sub) { r in
                        let res = (r["reports"] as? String).cin()
                        if res == "" {
                            rIsEmpty = true
                            withAnimation {
                                isLoading = false
                            }
                        } else {
                            let _result = res.components(separatedBy: ",")
                            //                            result = res.components(separatedBy: ",")
                            _result.forEach { i in
                                AF.request("https://github.com/Jonathan0827/Fun_iOS_Rewrite/issues/\(i)").responseString { iR in
                                    do {
                                        //                                    let a = try JSONSerialization.jsonObject(with: iR.value!, options: [])
                                        //                                    dump(iR.value)
                                        let a = iR.result
                                        switch a {
                                        case .success(let html) :
                                            //                                        print(html.replacingOccurrences(of: "\n", with: ""))
                                            let htmlWOLB = html.replacingOccurrences(of: "\n", with: "")
                                            let htmlSoup: Document = try SwiftSoup.parseBodyFragment(htmlWOLB)
                                            let title: Elements = try htmlSoup.select("title")
                                            var a = Array<[Any]>()
                                            for i in title {
                                                a.append(i.getChildNodes())
                                            }
                                            let sepTitle = String(describing: a[0][0]).description.components(separatedBy: " · ")
                                            print(sepTitle)
                                            result[sepTitle[0]] = sepTitle[1].replacingOccurrences(of: "Issue #", with: "")
                                            withAnimation {
                                                isLoading = false
                                            }
                                        case .failure(_):
                                            print("?????????")
                                        }
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        }
                    }
                }
                
            } else {
//                ZStack {
//                    Color.goodBG.ignoresSafeArea()
                    VStack {
                        Spacer()
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
                        Spacer()
                    }
                    .background(.goodBG)
//                }
            }
//        }
    }
}

