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
    @IBOutlet weak var signInB: UIButton!
    @IBOutlet weak var signUpB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInB.layer.borderColor = UIColor.clear.cgColor
        signInB.layer.borderWidth = 0.1
        signInB.layer.cornerRadius = 5
        signUpB.layer.borderColor = UIColor.clear.cgColor
        signUpB.layer.borderWidth = 0.5
        signUpB.layer.cornerRadius = 5
        let background = CAGradientLayer().backgroundGradientColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
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


extension CAGradientLayer {

    func backgroundGradientColor() -> CAGradientLayer {
        let topColor = UIColor(red: (0/255.0), green: (153/255.0), blue:(5/255.0), alpha: 1)
        let bottomColor = UIColor(red: (0/255.0), green: (153/255.0), blue:(255/255.0), alpha: 1)

        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]

        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]

        return gradientLayer

    }
}
