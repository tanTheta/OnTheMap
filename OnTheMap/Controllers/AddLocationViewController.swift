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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func cancel(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! TabBarViewController
        self.navigationController?.setViewControllers([viewController], animated: false)
    }

    @IBAction func findLocation(_ sender: Any) {
        if location.text!.isEmpty{
            self.handle_alert(title: "Location Field Empty", message: "Please enter your Location")
        }else if mediaUrl.text!.isEmpty{
            self.handle_alert(title: "URL Field Empty", message: "Please enter a URL")
        }else{
        forwardGeocoding(location.text!)
        }
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
    private func loadCurrentLocation(location: PostLocation) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "submitLocation") as! SubmitLocationViewController
        controller.student = location
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
