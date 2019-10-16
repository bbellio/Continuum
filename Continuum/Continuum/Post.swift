//
//  Post.swift
//  Continuum
//
//  Created by Bethany Wride on 10/15/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import UIKit

class Post {
    var photoData: Data?
    let timestamp: Date
    var caption: String
    var comments: [Comment] 
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    init(timestamp: Date = Date(), caption: String, comments: [Comment] = [], photo: UIImage?) {
        self.timestamp = timestamp
        self.caption = caption
        self.comments = comments
        self.photo = photo
    }
} // End of class

class Comment {
    var text: String
    var timestamp: Date
    weak var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post?) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
} // End of class

// MARK: - Class Extensions
extension Post: SearchableProtocol {
    func matches(searchTerm: String) -> Bool {
        if caption.lowercased().contains(searchTerm) {
            return true
        } else {
            for comment in comments {
                if comment.matches(searchTerm: searchTerm) {
                    return true
                }
            }
        }
        return false
    } // End of function
} // End of extension

extension Comment: SearchableProtocol {
    func matches(searchTerm: String) -> Bool {
        return text.lowercased().contains(searchTerm)
    }
}
