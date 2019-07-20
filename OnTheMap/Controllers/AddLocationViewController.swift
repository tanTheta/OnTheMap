//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/19/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var mediaUrl: UITextField!
    
   
    var objectId: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        location.delegate = self
        mediaUrl.delegate = self
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func findLocation(_ sender: Any) {
        let newLocation = location.text
        geocodePosition(newLocation: newLocation ?? "")
    }
    
    private func geocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.handle_alert(message: error.localizedDescription, title: "Unable to find location")
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.loadCurrentLocation(location.coordinate)
                } else {
                    self.handle_alert(message: "Please try again later.", title: "Error")
                }
            }
        }
    }
    
    private func loadCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "submitLocation") as! SubmitLocationViewController
        controller.student = getStudentDetails(coordinate)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func getStudentDetails(_ coordinate: CLLocationCoordinate2D) -> Student {
        var student = [
            "uniqueKey": UdacityClient.Auth.accountKey,
            "firstName": UdacityClient.Auth.firstName,
            "lastName": UdacityClient.Auth.lastName,
            "mapString": location.text!,
            "mediaURL": mediaUrl.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            ] as [String: AnyObject]
        
        if let objectId = objectId {
            student["objectId"] = objectId as AnyObject
        }
        return Student(student)
    }
    
    func handle_alert(message: String, title: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
