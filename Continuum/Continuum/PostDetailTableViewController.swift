//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Bethany Wride on 10/15/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
// MARK: - Global Variables
    var post: Post? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
// MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    
// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
// MARK: - Actions
    @IBAction func commentButtonTapped(_ sender: Any) {
        presentCommentAlert()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let caption = post?.caption,
            let image = post?.photo
            else { return }
        let activityController = UIActivityViewController(activityItems: [caption, image] , applicationActivities: nil)
        present(activityController, animated: true)
    }
    
    @IBAction func followPostButtonTapped(_ sender: Any) {
    }
    
// MARK: - Custom Functions
    func updateViews() {
        guard let post = post else { return }
        postImageView.image = post.photo
        self.title = post.caption
    }
    
    func presentCommentAlert() {
        let alertController = UIAlertController(title: "Add a New Comment", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Your comment here..."
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let commentAction = UIAlertAction(title: "Comment", style: .default) { (_) in
            guard let text = alertController.textFields?.first?.text,
                !text.isEmpty,
                let post = self.post
                else { return }
            PostController.sharedInstance.addComment(text: text, post: post) { (comment) in
//                post.comments.append(comment)
            }
            self.tableView.reloadData()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(commentAction)
        present(alertController, animated: true)
    } // End of function
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let post = post else { return 0 }
        return post.comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        let comment = post?.comments[indexPath.row]
        cell.textLabel?.text = comment?.text
        cell.detailTextLabel?.text = comment?.timestamp.stringValue()
        return cell
    }
} // End of class
