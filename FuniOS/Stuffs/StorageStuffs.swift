//
//  StorageStiffs.swift
//  Fun
//
//  Created by 임준협 on 1/24/24.
//

import Foundation

func saveUserDefault(_ key: String, _ value: Any) {
    UserDefaults.standard.set(value, forKey: key)
}
func addUserDefaultS(_ key: String, _ value: String) {
    let oD = UserDefaults.standard.string(forKey: key)
    UserDefaults.standard.set("\(oD ?? "")**SPR**\(value)", forKey: key)
}
func readUserDefault(_ key: String) -> Any? {
    return UserDefaults.standard.object(forKey: key)
}
func sepUserDefaultS(_ key: String) -> [String] {
    let oD = UserDefaults.standard.string(forKey: key)
    if oD == nil {
        return [""]
    } else {
        return oD!.components(separatedBy: "**SPR**")
    }
}
func deleteUserDefault(_ key: String) {
    UserDefaults.standard.removeObject(forKey: key)
}
func saveDocument(_ fileName: String, _ data: String) {
    let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let file = doc.appendingPathComponent(fileName)
    do {
        try Data(data.utf8).write(to: file)
        cprint("Wrote to \(file.path)", "saveDocument", false)
    } catch {
        cprint(error.localizedDescription, "saveDocument", true)
    }
}
func readDocument(_ fileName: String) -> String {
    let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let file = doc.appendingPathComponent(fileName)
    do {
        return try String(data: Data(contentsOf: file), encoding: .utf8).cin()
    } catch {
//        cprint(error.localizedDescription, "readDocument", true)
        if error.localizedDescription == "The file “\(fileName)” couldn’t be opened because there is no such file." {
            cprint("No such file \(fileName)", "readDocument", false)
        } else {
            cprint(error.localizedDescription, "readDocument", true)
        }
        return ""
    }
}
func deleteDocument(_ fileName: String) {
    let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let file = doc.appendingPathComponent(fileName)
    do {
        try FileManager.default.removeItem(at: file)
    } catch {
        cprint(error.localizedDescription, "deleteDocument", true)
    }
}
func checkDocument(_ fileName: String) -> Bool {
    let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let file = doc.appendingPathComponent(fileName)
    return FileManager.default.fileExists(atPath: file.path)
}
func updateDocument(_ fileName: String, _ data: String) {
    let oD = readDocument(fileName)
    saveDocument(fileName, "\(oD)**SPR**\(data)")
}
func sepDocument(_ fileName: String) -> [String] {
    let oD = readDocument(fileName)
    if oD == "" {
        return [""]
    } else {
        return oD.components(separatedBy: "**SPR**")
    }
}
func urlDocument(_ fileName: String) -> URL {
    let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let file = doc.appendingPathComponent(fileName)
    return file ?? URL(string: "file://")!
}
