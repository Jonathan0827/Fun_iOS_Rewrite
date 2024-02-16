//
//  FetchFunAPI.swift
//  Fun
//
//  Created by 임준협 on 12/20/23.
//

import Foundation
import Alamofire
struct DecodableType: Decodable { let url: String }

func sendTest(local: Bool) -> Dictionary<String, Any> {
    let jwt = makeJWT(clm: JWTClaims(iss: "FunAuthorization", sub: "123", exp: tmk(s: 5)))
    let aes = makeAES(d: jwt)
    
    if aes.success {
        var a = Dictionary<String, Any>()
        AF.request((local ? "http://localhost:4000/test" : "https://api.reacts.kro.kr/test" ), method: .post, parameters: ["sub": "123"], encoding: JSONEncoding.default,headers: ["Authorization": aes.out]).responseData { res in
//            debugPrint(res)
//            let removeCharacters: Set<Character> = ["\n", " ", ";"]
//            a.removeAll(where: { removeCharacters.contains($0) })
            do {
                a = try JSONSerialization.jsonObject(with: res.value!, options: []) as! [String: Any]
                print(a["test"] ?? "Got no data for \"test\"")
            } catch {
                debugPrint(error)
            }
        }
        return a
    } else {
        return ["error": aes.out]
    }
    
}
struct P: Codable {
    let problems: [Problem]
}
struct Problem: Codable {
    let quiz: String
    let answer: [String]
    let e: Bool
}
let apiPath = "https://api.reacts.kro.kr" // Production server
//let apiPath = "http://localhost:4000" // Local server for debugging
func sendPOST(auth: String, endpoint: String, sub: String, params: [String: Any]? = nil, doReturn: @escaping (Dictionary<String, Any>) -> Void) {
    cprint("Starting Job: Send POST to \(endpoint)", "sendPOST", false)
    let headers: HTTPHeaders = [
        "Authorization": auth
    ]
    var a = Dictionary<String, Any>() 
    var p = Dictionary<String, Any>()
    p = ["sub": sub]
    if params != nil {
        cprint("Param is not empty. Adding to 'p'", "sendPOST", false)
        params!.forEach { i in
            p[i.key] = i.value
        }
    }
    AF.request("\(apiPath)/\(endpoint)", method: .post, parameters: p, encoding: JSONEncoding.default, headers: headers).responseData { res in
        //            let removeCharacters: Set<Character> = ["\n", " ", ";"]
        //            a.removeAll(where: { removeCharacters.contains($0) })
        if TARGET_IPHONE_SIMULATOR == 1 {
            debugPrint(res)
        }
        do {
            cprint("Success! Returning...", "sendPOST", false)
            a = try JSONSerialization.jsonObject(with: res.value!, options: []) as! [String: Any]
            a["success"] = true
            doReturn(a)
        } catch {
            cprint("Error! Error message: \(error.localizedDescription) Returning...", "sendPOST", true)
            a = ["error": error, "success": false] as Dictionary
            doReturn(a)
        }
    }
//    return a
}
func sendGET(auth: String, endpoint: String, sub: String, params: [String: Any]? = nil,doReturn: @escaping (Dictionary<String, Any>) -> Void) {
    cprint("Starting Job: Send GET to \(endpoint)", "sendGET", false)
    let headers: HTTPHeaders = [
        "Authorization": auth
    ]
    var a = Dictionary<String, Any>()
    var p = ""
    if params != nil {
        cprint("Param is not empty. Adding to URL", "sendGET", false)
        params!.forEach { i in
            p += "&\(i.key)=\(i.value)"
        }
        
    }
    cprint("URL is \(apiPath)/\(endpoint)?sub=\(sub)\(p)", "sendGET", false)
    AF.request("\(apiPath)/\(endpoint)?sub=\(sub)\(p)", method: .get, encoding: JSONEncoding.default, headers: headers).responseData { res in
        if TARGET_IPHONE_SIMULATOR == 1 {
            debugPrint(res)
        }
        //            let removeCharacters: Set<Character> = ["\n", " ", ";"]
        //            a.removeAll(where: { removeCharacters.contains($0) })
        do {
            a = try JSONSerialization.jsonObject(with: res.value!, options: []) as! [String: Any]
            a["success"] = true
            cprint("Success! Returning...", "sendGET", false)
            doReturn(a)
        } catch {
            debugPrint(error)
            a = ["error": error, "success": false] as Dictionary<String, Any>
            cprint("Error! Error message: \(error.localizedDescription) Returning...", "sendGET", true)
            doReturn(a)
        }
    }
    
//    return a
}

func getQuests(doReturn: @escaping ([Problem]) -> Void) {
    var vtr = [Problem]()
    
    AF.request("https://raw.githubusercontent.com/Team-WAVE-x/Stop-uncle/master/src/ajegag.json").responseData { res in
        do {
            let a = try JSONSerialization.jsonObject(with: res.value!, options: []) as! [String: [Any]]
            let b = a["problems"]!
            var c = [Problem]()
            b.forEach { i in
                let p = i as! [String: Any]
                c.append(Problem(quiz: p["quiz"] as! String, answer: p["answer"] as! [String], e: false))
            }
            print(c.count, "PsC")
            vtr = c
            
            doReturn(vtr)
            
        } catch {
            print(error)
            vtr = [Problem(quiz: "문제를 가져오는 중 오류가 발생하였습니다", answer: ["\(error)"], e: true)]
            
            doReturn(vtr)
        }
    }
}
