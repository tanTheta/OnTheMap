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
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    let updatedAt: String
}

struct UdacityUser {
    let udacity: [User]
}

struct User {
    let userName: String = ""
    let password: String = ""
}

