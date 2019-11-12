//
//  SetImagViewController.swift
//  ParstagramApp
//
//  Created by Jose Alarcon Chacon on 11/12/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import Parse

class SetImagViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.layer.borderWidth = 0.1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.black.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
    }

    func submitPost() {
        let post = PFObject(className: "UserPhoto")
        post["author"] = PFUser.current()!
        
        let imageData = userImage.image!.pngData()
        let fileObject = PFFileObject(data: imageData!)
        post["image"] = fileObject
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved!")
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    @IBAction func setImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageInfo = info[.editedImage] as! UIImage
        let imageSize = CGSize(width: 300, height: 300)
        let scaleImage = imageInfo.af_imageScaled(to: imageSize)
        userImage.image = scaleImage
        submitPost()
        dismiss(animated: true, completion: nil)
    }
}
