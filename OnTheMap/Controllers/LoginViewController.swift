//
//  ViewController.swift
//  OnTheMap
//
//  Created by Tanvi Roy on 7/16/19.
//  Copyright © 2019 Tanvi Roy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func loginPressed(_ sender: Any) {
        if userName.text!.isEmpty || password.text!.isEmpty {
            self.handle_alert(title: "Login Unsuccessful", message: "Username/Password is empty")
        } else {
            UdacityClient.sharedInstance().createSession(username: self.userName.text ?? "", password: self.password.text ?? ""){ (success, errorString) in
                DispatchQueue.main.async {
                    if success{
                        DispatchQueue.main.async {
                            self.navigateToViews()
                            print("Successfully logged in!")
                        }
                    } else if errorString != nil {
                        DispatchQueue.main.async {
                            self.handle_alert(title: "Invalid email/password", message: errorString!.localizedDescription)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.handle_alert(title: "Login Unsuccessful", message: errorString!.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    func navigateToViews(){
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navView")
        self.present(controller, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        password.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
}

