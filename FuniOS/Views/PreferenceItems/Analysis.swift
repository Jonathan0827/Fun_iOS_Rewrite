//
//  Analysis.swift
//  FuniOS
//
//  Created by 임준협 on 2/6/24.
//

import SwiftUI
import AlertToast

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
                .frame(width: 330, height: 300, alignment: .leading)
//                .padding(5)
                .background(RoundedRectangle(cornerRadius: 15).fill(.goodGray))
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                HStack {
                    Button(action: {
                        UIPasteboard.general.string = errLogsStr
                        self.vp.toast = AlertToast(displayMode: .hud, type: .systemImage("checkmark.circle.fill", .green), title: "클립보드에 복사되었습니다")
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
