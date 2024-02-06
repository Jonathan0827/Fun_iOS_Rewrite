//
//  Feedback.swift
//  FuniOS
//
//  Created by 임준협 on 2/6/24.
//

import SwiftUI
import AlertToast

struct feedbackView: View {
    @AppStorage("sub") private var sub: String = ""
    @AppStorage("name") private var name: String = ""
    @AppStorage("email") private var email: String = ""
    @State private var title = ""
    @State private var message = ""
    @State private var agreements = [false, false]
    @State private var type = 0
    @EnvironmentObject var vp: vps
    var body: some View {
        VStack {
            Spacer()
            Text("피드백 제출")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("보안과 관련된 피드백은 security@reacts.kro.kr로 보내주세요")
                .font(.caption)
                .fontWeight(.light)
                .padding(.bottom)
            TextField("제목", text: $title)
                
                .frame(height: 50)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 20).fill(.goodGray))
                .padding(.bottom, 5)
                .padding(.horizontal, 20)
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                
                
                TextEditor(text: $message)
                    .scrollContentBackground(.hidden)
                    .frame(height: 250)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 10)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.goodGray))
                    .padding(.horizontal, 20)
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
                Text("기능").tag(1)
                Text("기타").tag(2)
                Text("보안").tag(3)
            })
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            Spacer()
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
                    sendPOST(auth: generateToken(sub).out, endpoint: "report", sub: sub, params: ["title": title, "message": message]) { r in
                        print(r["issueURL"])
                        print(r["reported"])
                    }
                }
            }, label: {
                Text(type != 3 ? "제출" : "이메일 열기")
                //                    .font(type != 3 ? .title : .callout )
                    .fontWeight(.bold)
                    .frame(width: 300)
                    .padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 20)
                        .fill(((title == "" || message == "") && type != 3 ) ? UIColor.systemGray4.uc() : UIColor.systemBlue.uc())
                    )
            })
            .disabled((title == "" || message == "") && type != 3 )
        }
        .onAppear {
            if sub == "" {
                vp.toast = AlertToast(displayMode: .hud, type: .systemImage("xmark.circle.fill", UIColor.systemRed.uc()), title: "로그인이 필요한 서비스입니다.", subTitle: "설정에서 로그인할 수 있습니다.")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    withAnimation {
                        vp.showToast = true
                    }
                })
                vp.showFeedback = false
            }
        }
    }
}

