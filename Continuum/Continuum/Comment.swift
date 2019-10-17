//
//  Comment.swift
//  Continuum
//
//  Created by Bethany Wride on 10/17/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import Foundation
import CloudKit

struct CommentStrings {
    static let recordTypeKey = "Comment"
    static let textKey = "text"
    static let timestampKey = "timestamp"
    static let postReferenceKey = "postReference"
}

// MARK: - Class Declaration
class Comment {
    var text: String
    var timestamp: Date
    weak var post: Post?
    var recordID: CKRecord.ID
    var postReference: CKRecord.Reference? {
        guard let post = post else { return nil }
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    init(text: String, timestamp: Date = Date(), post: Post?, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.text = text
        self.timestamp = timestamp
        self.recordID = recordID
        self.post = post
    }
} // End of class

// MARK: - Class Extensions
extension Comment: SearchableProtocol {
    func matches(searchTerm: String) -> Bool {
        return text.lowercased().contains(searchTerm)
    }
}

extension Comment {
    convenience init?(ckRecord: CKRecord, post: Post) {
        guard let text = ckRecord[CommentStrings.textKey] as? String,
            let timestamp = ckRecord[CommentStrings.timestampKey] as? Date
            else { return nil }
        self.init(text: text, timestamp: timestamp, post: post, recordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(comment: Comment) {
        self.init(recordType: CommentStrings.recordTypeKey, recordID: comment.recordID)
        self.setValuesForKeys([
            CommentStrings.textKey : comment.text,
            CommentStrings.timestampKey : comment.timestamp
        ])
        if let reference = comment.postReference {
            self.setValue(reference, forKey: CommentStrings.postReferenceKey)
        }
    }
}
