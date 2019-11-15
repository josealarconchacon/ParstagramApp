//
//  CameraViewController.swift
//  ParstagramApp
//
//  Created by Jose Alarcon Chacon on 11/10/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var postB: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentField.placeholder = "Wite about your post"
        postB.layer.borderWidth = 0.05
        postB.layer.cornerRadius = 10
        postB.backgroundColor = UIColor.white
        postB.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.1
        imageView.layer.cornerRadius = 10
    }
    @IBAction func submitButton(_ sender: Any) {
        submitPost()
    }
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func submitPost() {
        let post = PFObject(className: "Posts")
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
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
    
    @IBAction func gestureOnCameraButton(_ sender: Any) {
        picker()
    }
    
    func picker() {
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
        imageView.image = scaleImage
        dismiss(animated: true, completion: nil)
    }
}
