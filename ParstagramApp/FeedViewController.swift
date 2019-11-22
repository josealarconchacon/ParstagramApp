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
import MessageInputBar

class FeedViewController: UIViewController, MessageInputBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    let commentBar = MessageInputBar()
    var showCommentBar = false
    
    var window: UIWindow?
    var posts = [PFObject]()
    var selectedPost: PFObject!
    var user = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.image = UIImage(named: "send")
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(heyboardWillBeHiden), name: UIResponder.keyboardWillHideNotification, object: nil)
        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])
        tableView.tableFooterView = UIView()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showCommentBar
    }
    
    @objc func heyboardWillBeHiden(note: Notification) {
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        queryPost()
    }
    
    func queryPost() {
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.author"])
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

    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Create a comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()
        selectedPost.add(comment, forKey: "comments")
        selectedPost.saveInBackground { (success, error) in
           if success {
                print("Comment saved")
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
        tableView.reloadData()
        // clear and dissmis input
        commentBar.inputTextView.text = nil
        showCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    @IBAction func signOutButton(_ sender: Any) {
        let alert = UIAlertController(title: user!.username, message: "Would you like to logout", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //
        }
        let logOut = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
            PFUser.logOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: "ViewController")
            let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
            sceneDelegate.window?.rootViewController = destination
        }
        alert.addAction(logOut)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
            let user = post["author"] as? PFUser
            cell.usernameLabel.text = user!.username! + " "
            cell.captionLabel.text = post["caption"] as? String
            let imageFile = post["image"] as! PFFileObject
            let imgUrlString = imageFile.url!
            let url = URL(string: imgUrlString)
            cell.photoImageView.af_setImage(withURL: url!)
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        if indexPath.row == comments.count + 1 {
            showCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            selectedPost = post
        }
    }
}

