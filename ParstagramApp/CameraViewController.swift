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

enum ImageToEdit {
    case setImage
}

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var postB: UIButton!
    private var settingImage: ImageToEdit?
    private var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentField.placeholder = "Wite about your post"
        postB.layer.borderWidth = 0.09
        postB.layer.cornerRadius = 10
        postB.backgroundColor = UIColor.white
        postB.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 0.1
        imageView.layer.cornerRadius = 10
    }
    
    @IBAction func tapGesture(_ sender: Any) {
       settingImage = .setImage
        let alert = UIAlertController(title: "Selecte", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.camera()
        }
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.photoLibrary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
        }
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            present(myPickerController, animated: true, completion: nil)
        }
    }
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            present(myPickerController, animated: true, completion: nil)
        }
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
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("original image not available")
            return }
        let imageSize = CGSize(width: 300, height: 300)
        let scaleImage = originalImage.af_imageAspectScaled(toFill: imageSize)
        if settingImage == .setImage {
            selectedImage = scaleImage
            imageView.image = scaleImage

        } else {
            print("No Image was selected for the profile")
        }
        dismiss(animated: true, completion: nil)
    }
}
