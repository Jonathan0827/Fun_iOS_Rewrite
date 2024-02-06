//
//  LogOutView.swift
//  FuniOS
//
//  Created by 임준협 on 2/6/24.
//

import SwiftUI

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
