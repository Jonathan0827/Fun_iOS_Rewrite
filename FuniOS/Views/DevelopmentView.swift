//
//  ContentView.swift
//  GyeSanGi
//
//  Created by 임준협 on 12/13/23.
//

import SwiftUI
import SwiftJWT
struct DevelopmentView: View {
    @AppStorage("isFirstLaunching") var isFirstLaunching = true
    @AppStorage("sub") private var sub: String = "123"
    @State private var t = ""
    @State var localServer = false
    var body: some View {
        NavigationView {
            VStack{
                Text("\(makeJWT(clm: JWTClaims(iss: "FunAuthorization", sub: sub, exp: tmk(s: 5))))")
                    .padding()
                Text("\(makeAES(d: t).out)" as String)
                Button(action: {
                    print(type(of: sendTest(local: localServer)))
                }, label: {
                    Text("Send req to test")
                })
                Toggle(isOn: $localServer, label: {
                    Text("Send request to http://localhost:4000")
                })
            }
        }.onAppear {
            t = makeJWT(clm: JWTClaims(iss: "FunAuthorization", sub: sub, exp: tmk(s: 5)))
        }
        
    }
}
