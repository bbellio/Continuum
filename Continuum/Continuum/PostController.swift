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
    var publicCloudDatabase = CKContainer.default().publicCloudDatabase
    
// MARK: - CRUD
    // Create
    func createPostWith(image: UIImage, caption: String, completion: @escaping (_ post: Post?) -> Void) {
        let newPost = Post(caption: caption, photo: image)
        let recordForNewPost = CKRecord(post: newPost)
        publicCloudDatabase.save(recordForNewPost) { (savedRecord, error) in
            if let error = error {
                print("Error saving record to database : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
            }
            guard let unwrappedSavedRecord = savedRecord,
                let savedPost = Post(ckRecord: unwrappedSavedRecord)
                else { completion(nil) ; return }
            self.posts.append(savedPost)
            print("Created post successfully")
            completion(savedPost)
        }
    }
    
    func addComment(text: String, post: Post, completion: @escaping (_ comment: Comment?) -> Void) {
        let newComment = Comment(text: text, post: post)
        let recordForNewComment = CKRecord(comment: newComment)
        publicCloudDatabase.save(recordForNewComment) { (savedRecord, error) in
            if let error = error {
                print("Error saving comment record to database: \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
            }
            guard let unwrappedSavedRecord = savedRecord,
                let savedComment = Comment(ckRecord: unwrappedSavedRecord, post: post)
                else { completion(nil) ; return }
            post.commentCount += 1
            print("Successfully created new comment")
            completion(savedComment)
        }
    }
    
    // Read
    func fetchPosts(completion: @escaping (_ posts: [Post]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostStrings.recordTypeKey, predicate: predicate)
        publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in fetching posts : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            guard let unwrappedRecords = records else { completion(nil) ; return }
            let posts = unwrappedRecords.compactMap{ Post(ckRecord: $0) }
            self.posts = posts
        }
    }
    
    func fetchComments(for post: Post, completion: @escaping (_ comments: [Comment]?) -> Void) {
        let postReference = post.recordID
        let predicate = NSPredicate(format: "%K == %@", CommentStrings.postReferenceKey, postReference)
        let commentIDs = post.comments.compactMap( {$0.recordID} )
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: CommentStrings.recordTypeKey, predicate: compoundPredicate)
        publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in fetching comments : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            guard let unwrappedRecords = records else { completion(nil) ; return }
            let comments  = unwrappedRecords.compactMap{ Comment(ckRecord: $0, post: post) }
            completion(comments)
        }
    }
    
    // Update
    
    // Delete
    
} // End of class
