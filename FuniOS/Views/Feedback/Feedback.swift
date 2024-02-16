
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
    @State var feedbackType: Int = 0
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
                        .onAppear {
                            UIApplication.shared.open(URL(string: "mailto:")!)
                        }
                case 2:
                    inAppFeedbackView(isEditingTitle: $isEditingTitle, isEditingBody: $isEditingBody)
                case 3:
                    submittedFeedbacksView(hideTitle: $hideTitle)
//                case 4:
//                    //                    Testing
//                    inAppFeedbackView(isEditingTitle: $isEditingTitle, isEditingBody: $isEditingBody, showSuccess: true)
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
//                        Button("Do TEST", action: {
//                            feedbackType = 4
//                        })
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
