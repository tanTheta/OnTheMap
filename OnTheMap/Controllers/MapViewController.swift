//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/17/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserInfo()
    }
    
    func getUserInfo(){
        UdacityClient.sharedInstance().getStudentLocations{ (data, error) in
            if((error) != nil){
                DispatchQueue.main.async {
                    print ("Error")
                }
            }else{
                DispatchQueue.main.async {
                    UdacityClient.sharedInstance().storeData(data: data)
                    self.createPins(data: UdacityClient.sharedInstance().students)
                }
            }
        }
    }

    func createPins(data:[Student]){
        var annotations = [MKPointAnnotation]()
        
        for student in data {
            let lat = CLLocationDegrees(student.latitude!)
            let long = CLLocationDegrees(student.longitude!)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName ?? "") \(student.lastName ?? "")"
            annotation.subtitle = student.mediaURL!
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let annotation = view.annotation, let urlString = annotation.subtitle {
                if let url = URL(string: urlString!) {
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
}
