//
//  LogoView.swift
//  Fun
//
//  Created by 임준협 on 12/29/23.
//

import SwiftUI
import Macaw
import SVGView
struct Icon: View {
    var body: some View {
        Image("LogoSVG")
            .resizable()
    }
}

#Preview {
    Icon()
}
