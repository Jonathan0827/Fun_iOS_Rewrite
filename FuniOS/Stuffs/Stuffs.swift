//
//  Stuffs.swift
//  Fun
//
//  Created by 임준협 on 12/30/23.
//

import Foundation
import SwiftUI
import UIKit
import AlertToast

class vps: ObservableObject {
    @Published var showTabBar: Bool = false
    @Published var showSignUp: Bool = false
    @Published var alert: Alert = makeAlert(title: "")
    @Published var toast: AlertToast = AlertToast(displayMode: .hud, type: .regular, title: "Fun", subTitle: "환영합니다")
    @Published var showAlert: Bool = false
    @Published var showToast: Bool = false
}
struct fancyTabBar: View {
    @Binding var selectedTab: Int
    @State var vs1 = [CGSize]()
    @State private var vw1: [CGFloat] = [0, 0, 0]
    let tabs: [Dictionary<String, String>]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(uiColor: .systemGray6))
                .frame(height: 50)
                .padding(.vertical, 20)
                .padding(.horizontal, 15)
//            RoundedRectangle(cornerRadius: 25)
//                .fill(Color(uiColor: UIColor.systemBlue))
//                .frame(width: vw1[selectedTab] + 10, height: 40)
            HStack {
                Spacer()
                ForEach(tabs, id: \.self) { t in
                    HStack {
                        Image(systemName: t.depart()[1] as! String)
                            .font(.system(size: 15))
                        Text(t.depart()[0] as! String)
                            .font(.system(size: 15))
                    }
                    .saveSize(in: $vs1)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 10)
//                    .background(tabs.firstIndex(of: t) == selectedTab ? Color.blue : Color.clear)
                    .foregroundColor(tabs.firstIndex(of: t) == selectedTab ? Color.cprimary : Color(uiColor: .systemGray))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tabs.firstIndex(of: t)!
                        }
//                        dPrint(vs1)
//                        dPrint(vs1[selectedTab])
                        vw1.append(vs1[selectedTab].width)
                    }
//                    .cornerRadius(25)
                    Spacer()
                }
            }
        }
        .padding(.bottom, -25)
        .padding(.horizontal, 15)
        .ignoresSafeArea()
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

func getImage(_ url: URL, doReturn: @escaping (UIImage) -> Void) {
    DispatchQueue.global().async {
        guard let imageData = try? Data(contentsOf: url) else { return }
        cprint("Returning image from URL", "Image Fetcher", false)
        doReturn(UIImage(data: imageData)!)
    }
}

struct SCalc: ViewModifier {
    
    @Binding var size: [CGSize]
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear // we just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            size.append(proxy.size)
                        }
                }
            )
    }
}

