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
    @Published var showFeedback: Bool = false
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
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
 
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(lineWidth: 2)
                .frame(width: 25, height: 25)
                .cornerRadius(5.0)
                .overlay {
                    Image(systemName: configuration.isOn ? "checkmark" : "")
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
 
            configuration.label
 
        }
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

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image(systemName: "arrowtriangle.left.fill")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color("mode"))
                .padding(.trailing, -5)
                .font(.system(size: 8))
            Text("뒤로 가기")
                .foregroundColor(Color("mode"))
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color("cprimary"))
        .clipShape(.capsule)
    }
    }
}
