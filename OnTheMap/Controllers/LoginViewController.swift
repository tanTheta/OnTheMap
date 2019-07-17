//
//  ViewController.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/16/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{


    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    

    @IBAction func loginPressed(_ sender: Any) {
        UdacityClient.createSession(username: self.userName.text ?? "", password: self.password.text ?? "", completion: handleSessionResponse)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    func handleSessionResponse(success:Bool, error:Error?){
        if success{
            DispatchQueue.main.async {
                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! UIViewController
                self.navigationController?.setViewControllers([viewController], animated: false)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = ""
        password.text = ""
    }

}

