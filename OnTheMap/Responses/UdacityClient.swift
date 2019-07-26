//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/16/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import Foundation
class UdacityClient : NSObject {
    
    struct Auth {
        static var sessionId: String? = nil
        static var accountKey = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case addLocation
        case getStudentLocations
        case getCurrentUserProfile
        case session
        case signUp
        case updateLocation
        
        var stringValue: String {
            switch self {
            case .addLocation:
                return Endpoints.base + "/StudentLocation"
            case .getStudentLocations:
                return Endpoints.base + "/StudentLocation?limit=100&order=-updatedAt"
            case .getCurrentUserProfile:
                return Endpoints.base + "/users/" + Auth.accountKey
            case .session:
                return Endpoints.base + "/session"
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            case .updateLocation:
                return Endpoints.base + "/StudentLocation/" + Auth.objectId
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    var students : [Student]
    
    override init() {
    self.students = []
    super.init()
    }
    
    func createSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(CreateSessionResponse.self, from: newData)
                Auth.sessionId = responseObject.session.id
                Auth.accountKey = responseObject.account.key
                self.getCurrentUser { (success, errorString) in
                    guard (errorString == nil) else{
                        completion(false, errorString)
                        return
                        }
                    }
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    
    func deleteSession(completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                _ = try decoder.decode(DeleteSessionResponse.self, from: newData)
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    
    func getCurrentUser(completion: @escaping (Bool, Error?) -> Void){
        let request = URLRequest(url: Endpoints.getCurrentUserProfile.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(CurrentUser.self, from: newData)
                Auth.firstName = responseObject.firstName
                Auth.lastName = responseObject.lastName
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    
    func getStudentLocations(completion:@escaping ([Student], Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getStudentLocations.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(StudentResults.self, from: data)
                completion(responseObject.results, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    func updateStudentLocations(student: PostLocation, completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.addLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey ?? "")\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString ?? "")\", \"mediaURL\": \"\(student.mediaURL ?? "")\",\"latitude\": \(student.latitude ?? 0.0), \"longitude\": \(student.longitude ?? 0.0)}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                _ = try decoder.decode(AddLocationResponse.self, from: data)
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }

    
    func addStudentLocations(student: PostLocation, completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.addLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaURL)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                _ = try decoder.decode(AddLocationResponse.self, from: data)
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    
    func storeData(data:[Student]){
        self.students = []
        for student in data{
            self.students.append(student)
        }
    }
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
}
