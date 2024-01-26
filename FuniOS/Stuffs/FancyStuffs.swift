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
