//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/17/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentUrl: UILabel!
}

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UdacityClient.sharedInstance().students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath as IndexPath)
            as! StudentTableViewCell
        
        let student = UdacityClient.sharedInstance().students[indexPath.row]
        cell.studentName?.text = student.firstName
        cell.studentUrl?.text = student.mediaURL
        print(student.mediaURL)
        return cell
    }
}

