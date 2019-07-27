//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/17/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit


class TabBarViewController: UITabBarController {
    @IBAction func logoutPressed(_ sender: Any) {
        UdacityClient.sharedInstance().deleteSession  { (success, errorString) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated:true,completion:nil)
                }
            } else {
                print(errorString as Any)
            }
        }
    }
    @IBAction func refresh(_ sender: Any) {
            let mapView = self.viewControllers![0] as! MapViewController
            mapView.getUserInfo()
    }
}
