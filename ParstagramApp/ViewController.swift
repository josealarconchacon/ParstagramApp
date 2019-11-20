//
//  ViewController.swift
//  ParstagramApp
//
//  Created by Jose Alarcon Chacon on 11/10/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInB: UIButton!
    @IBOutlet weak var signUpB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        signInB.layer.borderColor = UIColor.clear.cgColor
        signInB.layer.borderWidth = 0.1
        signInB.layer.cornerRadius = 5
        signUpB.layer.borderColor = UIColor.clear.cgColor
        signUpB.layer.borderWidth = 0.5
        signUpB.layer.cornerRadius = 5
        let background = CAGradientLayer().backgroundGradientColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func hideKeyboard() {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
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
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification ||
           notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -100
        } else {
            view.frame.origin.y = 0
        }
     }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         hideKeyboard()
         return true
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
        let topColor = UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0)
        let bottomColor = UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]

        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]

        return gradientLayer

    }
}
