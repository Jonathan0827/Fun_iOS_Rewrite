//
//  ConsoleStuffs.swift
//  Fun
//
//  Created by 임준협 on 1/24/24.
//

import Foundation
import LocalConsole

let cMan = LCManager.shared
func cprint(_ msg: Any, _ from: String? = nil, _ isError: Bool? = nil) {
    let oData = "\(from != nil ? "\(from!): " : "")\(msg) \(isError != nil ? isError! ? "🔴" : "🟢" : "")"
    Swift.print(oData)
    cMan.print(oData)
    if isError.cin() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let result = formatter.string(from: date)
//        addUserDefaultS("errLogs", "\(from.cin()) \(result): \(msg)")
        updateDocument("error.log", "\(from.cin()) \(result): \(msg)")
    }
}
func dPrint(_ v: Any) {
    Swift.print("\(type(of: v))\nDump")
    Swift.dump(v)
}
