//
//  DevMenu.swift
//  FuniOS
//
//  Created by 임준협 on 8/5/24.
//

import SwiftUI

struct DevMenu: View {
    @State private var customAPI = ""
    var body: some View {
        ZStack {
            Color(.goodBG)
                .ignoresSafeArea()
            VStack{
//                VStack {
                    TextField("Custom API URL", text: $customAPI)
                    Button("save reopen app to apply", action: {
                        saveKeyChain("apiPath", customAPI)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                              exit(0)
                             }
                        }

                    })
                    Button("clear reopen app to apply", action: {
                        deleteKeyChain("apiPath")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                              exit(0)
                             }
                        }

                    })
//                }
                Button("test api", action: {
                    cprint(readKeyChain("apiPath"))
                    sendTest() { r in
                        cprint(r, "sendTest")
                        cprint("Test complete. Please check test-*.log")
                    }
                })
//                .disabled(readKeyChain("apiPath") == "")
            }
        }
        .onAppear {
            customAPI = apiPath
        }
    }
}
