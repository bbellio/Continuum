//
//  PostController.swift
//  Continuum
//
//  Created by Bethany Wride on 10/15/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import CloudKit
import UIKit

class PostController {
// MARK: - Global variables
    static let sharedInstance = PostController()
    var posts: [Post] = []
    
// MARK: - CRUD
    // Create
    func createPostWith(image: UIImage, caption: String, completion: @escaping (_ post: Post) -> Void) {
        let newPost = Post(caption: caption, photo: image)
        posts.append(newPost)
    }
    
// MARK: - Additional Functionality
    func addComment(text: String, post: Post, completion: @escaping (_ comment: Comment) -> Void) {
        let newComment = Comment(text: text, post: post)
        post.comments.append(newComment) 
    }
    
} // End of class
