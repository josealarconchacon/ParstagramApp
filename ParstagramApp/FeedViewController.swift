//
//  FeedViewController.swift
//  ParstagramApp
//
//  Created by Jose Alarcon Chacon on 11/10/19.
//  Copyright © 2019 Jose Alarcon Chacon. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import Alamofire

class FeedViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    var userposts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        queryPost()
    }
    
    func queryPost() {
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    func queryPostImage() {
        let query = PFQuery(className: "UserPosts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.userposts = posts!
                self.tableView.reloadData()
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        cell.captionLabel.text = post["caption"] as? String

        let imageFile = post["image"] as! PFFileObject
        let imgUrlString = imageFile.url!
        let url = URL(string: imgUrlString)
        cell.photoImageView.af_setImage(withURL: url!)
        
        let image = post["image"] as! PFFileObject
        let imgUrl = image.url!
        let setUrl = URL(string: imgUrl)
        cell.userImageView.af_setImage(withURL: setUrl!)
    
        
        cell.userImageView.layer.borderWidth = 0.1
        cell.userImageView.layer.masksToBounds = false
        cell.userImageView.layer.borderColor = UIColor.black.cgColor
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.height/2
        cell.userImageView.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
