//
//  Session.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/16/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import Foundation
struct SessionRequest: Codable {
    
    let userName: String
    let password: String
    
    enum CodingKeys : String, CodingKey {
        case userName
        case password
    }
}

struct SessionResponse: Codable {
    let account : [String:String]
    let registered :Bool
    let key : String
    let session: [String:String]
    let id : String
    let expiration : String
}

struct CreateSessionResponse: Codable {
    let account: Account
    let session: Session
}

struct DeleteSessionResponse: Codable {
    let session: Session
}

struct Session: Codable {
    let id: String
    let expiration: String
}

struct Account: Codable {
    let registered: Bool
    let key: String
}
