//
//  Post.swift
//  Continuum
//
//  Created by Bethany Wride on 10/15/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import UIKit
import CloudKit

struct PostStrings {
    static let recordTypeKey = "Post"
    static let timestampKey = "timestamp"
    static let captionKey = "caption"
    static let commentsKey = "comments"
    static let photoAssetKey = "photoAsset"
    static let commentCountKey = "commentCount"
}

class Post {
    var photoData: Data?
    let timestamp: Date
    var caption: String
    var comments: [Comment]
    var commentCount: Int
    var recordID: CKRecord.ID
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var photoAsset: CKAsset? {
        guard photoData != nil else { return nil }
        let tempDirectory = NSTemporaryDirectory()
        let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
        let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension(".jpg")
        do {
            try photoData?.write(to: fileURL)
        } catch {
            print("Error writing photoData to file URL in Post photoAsset: \(error.localizedDescription) \n---\n \(error)")
        }
        return CKAsset(fileURL: fileURL)
    }
    
    init(timestamp: Date = Date(), caption: String, comments: [Comment] = [], commentCount: Int = 0, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), photo: UIImage?) {
        self.timestamp = timestamp
        self.caption = caption
        self.comments = comments
        self.commentCount = commentCount
        self.recordID = recordID
        self.photo = photo
    }
} // End of class

// MARK: - Class Extensions
extension Post {
    convenience init?(ckRecord: CKRecord) {
        guard let caption = ckRecord[PostStrings.captionKey] as? String,
            let timestamp = ckRecord[PostStrings.timestampKey] as? Date,
            let commentCount = ckRecord[PostStrings.commentCountKey] as? Int
//            var comments = ckRecord[PostStrings.commentsKey] as? [Comment]
            else { return nil }
        var photo: UIImage?
        if let photoAsset = ckRecord[PostStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                photo = UIImage(data: data)
            } catch {
                print("Error transforming data into photo: \(error.localizedDescription) \n---\n \(error)")
            }
        }
        // Fix comments
        self.init(timestamp: timestamp, caption: caption, commentCount: commentCount, recordID: ckRecord.recordID, photo: photo)
    }
} // End of extension

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

extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: PostStrings.recordTypeKey, recordID: post.recordID)
        self.setValuesForKeys([
            PostStrings.timestampKey : post.timestamp,
            PostStrings.captionKey : post.caption
        ])
        if let asset = post.photoAsset {
        self.setValue(asset, forKey: PostStrings.photoAssetKey)
        }
    }
}
