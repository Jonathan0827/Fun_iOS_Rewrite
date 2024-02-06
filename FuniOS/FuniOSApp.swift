//
//  FuniOSApp.swift
//  FuniOS
//
//  Created by 임준협 on 1/26/24.
//

import SwiftUI
import MijickPopupView
@main
struct FuniOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .implementPopupView()
        }
    }
}
