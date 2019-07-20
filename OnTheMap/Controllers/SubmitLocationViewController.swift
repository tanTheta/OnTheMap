//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/19/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit
import MapKit

class SubmitLocationViewController: UIViewController {
    var student: PostLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let studentDetails = student {
            showLocations(studentDetails: studentDetails)
        }
    }

    @IBOutlet weak var mapView: MKMapView!
   
    
    @IBAction func submitNewLocation(_ sender: Any) {
        if let studentDetails = student {
            if UdacityClient.Auth.objectId == "" {
                UdacityClient.sharedInstance().addStudentLocations(student: studentDetails) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! TabBarViewController
                            self.navigationController?.setViewControllers([viewController], animated: false)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.handle_alert(message: error?.localizedDescription ?? "", title: "Error")
                        }
                    }
                }
            } else {
                let alert = UIAlertController(title: "", message: "Overwrite location?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
                    UdacityClient.sharedInstance().updateStudentLocations(student: studentDetails) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! TabBarViewController
                                self.navigationController?.setViewControllers([viewController], animated: false)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.handle_alert(message: error?.localizedDescription ?? "", title: "Error")
                            }
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: nil)
                    }
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    
    private func showLocations(studentDetails: PostLocation){
        mapView.removeAnnotations(mapView.annotations)
        let lat = studentDetails.latitude
        let lon = studentDetails.longitude
            let coordinate =  CLLocationCoordinate2DMake(lat, lon)
            let annotation = MKPointAnnotation()
            annotation.title = "\(studentDetails.firstName) \(studentDetails.lastName)"
            annotation.subtitle = studentDetails.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    func handle_alert(message: String, title: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
