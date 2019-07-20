//
//  Student.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/16/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import Foundation
struct StudentResults: Codable {
    let results: [Student]
}

struct Student : Codable{
    let firstName: String?
    let lastName: String?
    let longitude: Double?
    let latitude: Double?
    let mapString: String?
    let mediaURL: String?
    let uniqueKey: String?
    let objectId: String?
    let createdAt: String?
    let updatedAt: String?
    
    init(_ dictionary: [String: AnyObject]) {
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.objectId = dictionary["objectId"] as? String ?? ""
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
    }
}

struct UdacityUser {
    let udacity: [User]
}

struct User {
    let userName: String = ""
    let password: String = ""
}

struct CurrentUser: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
    
}

struct AddLocationResponse: Codable {
    let createdAt: String?
    let objectId: String?
}

struct UpdateLocationResponse: Codable {
    let updatedAt: String?
}

