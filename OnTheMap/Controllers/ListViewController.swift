//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/17/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit
class ListViewController: UITableViewController{
    
    
    @IBOutlet weak var studentListView: UITableView!    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        UdacityClient.sharedInstance().getStudentLocations{ (data, error) in
            if((error) != nil){
                DispatchQueue.main.async {
                    print ("Error")
                }
            }else{
                DispatchQueue.main.async {
                    UdacityClient.sharedInstance().storeData(data: data)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath as IndexPath)
//            as! StudentTableViewCell
//
//        let student = UdacityClient.sharedInstance().students[indexPath.row]
//        cell.studentName?.text = student.firstName
//        cell.studentUrl?.text = student.mediaURL
//        return cell
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UdacityClient.sharedInstance().students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        let student = UdacityClient.sharedInstance().students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = UdacityClient.sharedInstance().students[indexPath.row]
        guard let url = URL(string: "\(student.mediaURL)"), !url.absoluteString.isEmpty else {
            self.handle_alert(title: "Invalid Link", message: "Cannot open the link")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

