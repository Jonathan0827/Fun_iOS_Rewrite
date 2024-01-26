//
//  CheckIfNil.swift
//  Fun
//
//  Created by 임준협 on 1/24/24.
//

import Foundation

extension String? {
    func cin() -> String {
        return self != nil ? self! : ""
    }
}
extension URL? {
    func cin() -> URL {
        return self != nil ? self! : URL(string: "https://")!
    }
}
extension Void? {
    func cin() -> Void {
        return self != nil ? self! : ()
    }
}
extension Bool? {
    func cin() -> Bool {
        return self != nil ? self! : false
    }
}
