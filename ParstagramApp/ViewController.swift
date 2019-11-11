//
//  ViewController.swift
//  ParstagramApp
//
//  Created by Jose Alarcon Chacon on 11/10/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signIn(_ sender: Any) {
        let userName = usernameField.text!
        let password = passwordField.text!
        PFUser.logInWithUsername(inBackground: userName, password: password) { (user, error) in
            if user != nil {
                 self.performSegue(withIdentifier: "segue", sender: nil)
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text!
        user.password = passwordField.text!
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "segue", sender: nil)
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
}

