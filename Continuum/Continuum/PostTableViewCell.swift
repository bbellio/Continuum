//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Bethany Wride on 10/15/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
// MARK: - Variables
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
// MARK: - Outlets
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
// MARK: - Custom Functions
    func updateViews() {
        guard let post = post else { return }
        postImageView.image = post.photo
        captionLabel.text = post.caption
        commentsLabel.text = "Comments: \(post.comments.count)"
    }
} // End of class
