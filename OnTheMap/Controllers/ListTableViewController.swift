//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/17/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit
class studentCellView: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var url: UILabel!
}

class ListTableViewController: UITableViewController{
    
    @IBOutlet weak var studentList: UILabel!
    
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
                    UdacityClient.sharedInstance().students = data
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UdacityClient.sharedInstance().students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! studentCellView
        let student = UdacityClient.sharedInstance().students[indexPath.row]
        cell.name.text = "\(student.firstName ?? "") \(student.lastName ?? "")"
        cell.url.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = UdacityClient.sharedInstance().students[indexPath.row]
        let app = UIApplication.shared
        if let urlString = student.mediaURL {
            if let url = URL(string: urlString) {
                if app.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    self.handle_alert(title: "Invalid URL", message: "Unable to open URL")
                }
            } else {
                self.handle_alert(title: "Invalid URL", message: "Unable to open URL")
            }
        }
    }
}

