//
//  SubmittedFeedbacks.swift
//  FuniOS
//
//  Created by 임준협 on 2/15/24.
//

import SwiftUI
import AlertToast
import Alamofire
import SwiftSoup

struct submittedFeedbacksView: View {
    @AppStorage("sub") var sub: String = ""
    @EnvironmentObject var vp: vps
    @State private var result = Dictionary<String, String>()
    @State private var isLoading: Bool = true
    @State private var rIsEmpty: Bool = false
    @Binding var hideTitle: Bool
    var body: some View {
//        ZStack {
//            Color.goodBG
        
            VStack {
                HStack {
                    Spacer()
                    Text("제출된 피드백 확인")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                        
                }
                    .background(.goodBG)
                NavigationView {
                if sub != "" {
                    VStack {
                        Spacer()
                        if isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.cprimary)
                                Spacer()
                            }
                        } else if !rIsEmpty {
                            ScrollView {
                                ForEach(result.sorted(by: >), id: \.key) { title, num in
                                    expandableView(title: title, num: num)
                                }
                            }
                        } else {
                            Text("피드백을 제출한 적이 없습니다.")
                        }
                        Spacer()
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
                    
                    //                }
                }
                //        }
            }
        }
        .background(.goodBG)
        .onAppear {
            withAnimation {
                hideTitle = true
            }
        }
    }
}

struct expandableView: View {
    let title: String
    let num: String
    @AppStorage("sub") var sub: String = ""
    @State private var doExpand = false
    @State private var comments = [String]()
    @State private var authors = [String]()
    @State private var loaded = false
    @State private var noCmts = false
    @State private var isLoading = true
    var body: some View {
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
            //                                            Image(systemName: "chevron.right")
            //                                                .foregroundColor(.secondary)
            //                                                .padding(.trailing, 10)
            //                                                .fontWeight(.light)
        }
        .background(.goodGray)
        .cornerRadius(15)
        .padding(.horizontal)
        .padding(.bottom, 5)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                doExpand.toggle()
            }
        }
        .sheet(isPresented: $doExpand) {
            ZStack {
                Color.goodBG.ignoresSafeArea()
                VStack {
                    Link(destination: URL(string: "https://github.com/Jonathan0827/Fun_iOS_Rewrite/issues/\(num)")!, label: {
                        HStack {
                            Spacer()
                            VStack(alignment: .leading) {
                                Text(title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.top, 30)
                                Text("https://github.com/Jonathan0827/Fun_iOS_Rewrite/issues/\(num)")
                                    .font(.caption2)
                                    .fontWeight(.light)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.goodGray)
                        )
                    })
                    .foregroundColor(.cprimary)
                    .padding()
                    if isLoading {
                        Spacer()
                        ProgressView()
                            .foregroundColor(.cprimary)
                            .frame(width: 50, height: 50)
                        Spacer()
                    }
                    if loaded {
                        ScrollView {
                            ForEach(comments.indices, id:  \.self) { i in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(comments[i])
                                            .font(.body)
                                            .fontWeight(.semibold)
                                        Text(authors[i])
                                            .font(.caption2)
                                            .fontWeight(.light)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(
                                        UnevenRoundedRectangle()
                                            .fill(.goodGray)
                                            .clipShape(
                                                .rect(
                                                    topLeadingRadius: 3,
                                                    bottomLeadingRadius: 15,
                                                    bottomTrailingRadius: 15,
                                                    topTrailingRadius: 15
                                                )
                                            )
                                        
                                    )
                                    .padding(.horizontal)
                                    .padding(.bottom, 5)
                                    Spacer()
                                }
                            }
                        }
                    }
                    if noCmts {
                        Spacer()
                        Text("댓글이 없습니다")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                .onAppear {
                    sendGET(auth: generateToken(sub).out, endpoint: "getcomments", sub: sub, params: ["issueID": num]) { r in
                        comments = r["comments"]! as! Array<String>
                        authors = r["authors"]! as! Array<String>
                        withAnimation {
                            if comments == [""] {
                                isLoading = false
                                noCmts = true
                            } else {
                                isLoading = false
                                loaded = true
                            }
                        }
                    }
                }
            }
        }
    }
}
