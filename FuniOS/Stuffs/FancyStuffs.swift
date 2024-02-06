//
//  FancyStuffs.swift
//  Fun
//
//  Created by 임준협 on 1/24/24.
//

import Foundation
import SwiftUI

struct fancyTextField: TextFieldStyle {
    let isEditing: Bool
    @Environment(\.colorScheme) var colorScheme
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 15)
//                    .fill(Color(UIColor.goodGray))
                    .fill(.goodGray)
            )
            .scaleEffect(isEditing ? 1.05 : 0.9)
    }
}
struct fancyButton: ButtonStyle {
    let bbtn: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10)
            .padding(.horizontal, 25)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(bbtn ? Color(UIColor.systemBlue) : Color(UIColor.goodGray))
            )
            .foregroundStyle(bbtn ? Color(.white) : Color(.secondaryLabel))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)

    }
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
