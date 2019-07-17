//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/16/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import Foundation
class UdacityClient : NSObject {
    
    var students : [Student]
    
    override init() {
        self.students = []
        super.init()
    }

    
    enum Endpoints {
        static let base = "https://www.udacity.com/api/"
        
        case createSession
        case deleteSession
        case getUser//(String)
        
        
        var stringValue: String {
            switch self {
            case .createSession: return Endpoints.base + "session"
            case .deleteSession: return Endpoints.base + "session"
            //            case .getUser(let userId): return Endpoints.base + "users/\(userId)"
            case .getUser: return Endpoints.base //+ "users/\(userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    
    func createSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.createSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            //            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func deleteSession(completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.deleteSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            //            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func getUser(userId: String, completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.getUser.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            //            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func getStudentLocations(completion:@escaping ([Student], Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
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
    
    func postStudentLocations(completion: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = (
            "{\"uniqueKey\": \"1234\", \"firstName\": \"Tanvi\", \"lastName\": \"Roy\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8))
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
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
