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
        forwardGeocoding(location.text!)
    }
    func forwardGeocoding(_ address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        guard (error == nil) else {
            print("Unable to Forward Geocode Address (\(String(describing: error)))")
            handle_alert(title: "Geocode Error", message: "Unable to Forward Geocode Address")
            return
        }
        
        if let placemarks = placemarks, placemarks.count > 0 {
            let placemark = placemarks[0]
            if let location = placemark.location {
                let coordinate = location.coordinate
                print("coordinates")
                print(placemark)
                 var user = PostLocation.init(uniqueKey: UdacityClient.Auth.accountKey, firstName: UdacityClient.Auth.firstName, lastName: UdacityClient.Auth.lastName, mapString: ("\(placemark.locality!),\(placemark.administrativeArea!)"), mediaURL: mediaUrl.text, latitude: coordinate.latitude, longitude: coordinate.longitude)
                loadCurrentLocation(location: user)
            } else {
                handle_alert(title: "User Data", message: "No Matching Location Found")
            }
        }
    }
//    private func geocodePosition(newLocation: String) {
//        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
//            if let error = error {
//                self.handle_alert(message: error.localizedDescription, title: "Unable to find location")
//            } else {
//                var location: CLLocation?
//
//                if let marker = newMarker, marker.count > 0 {
//                    location = marker.first?.location
//                }
//
//                if let location = location {
//                    self.loadCurrentLocation(location.coordinate)
//                } else {
//                    self.handle_alert(message: "Please try again later.", title: "Error")
//                }
//            }
//        }
//    }
    
    private func loadCurrentLocation(location: PostLocation) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "submitLocation") as! SubmitLocationViewController
        controller.student = location
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
//    private func getStudentDetails(_ coordinate: CLLocationCoordinate2D) -> PostLocation {
//        var user = PostLocation.init(uniqueKey: UdacityClient.Auth.accountKey, firstName: UdacityClient.Auth.firstName, lastName: UdacityClient.Auth.lastName, mapString: <#T##String?#>, mediaURL: <#T##String?#>, latitude: <#T##Double?#>, longitude: <#T##Double?#>)(,
//                                     firstName: String? = nil,
//                                     lastName: String? = nil,
//                                     mapString: String? = nil,
//                                     mediaURL: String? = nil,
//                                     latitude: Double? = nil,
//                                     longitude: Double? = nil)
//        var student = [
//            "uniqueKey": UdacityClient.Auth.accountKey,
//            "firstName": UdacityClient.Auth.firstName,
//            "lastName": UdacityClient.Auth.lastName,
//            "mapString": location.text!,
//            "mediaURL": mediaUrl.text!,
//            "latitude": coordinate.latitude,
//            "longitude": coordinate.longitude,
//            ] as [String: AnyObject]
//
//        if let objectId = objectId {
//            student["objectId"] = objectId as AnyObject
//        }
//        return PostLocation(student)
//    }
//
    func handle_alert(title: String,message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
