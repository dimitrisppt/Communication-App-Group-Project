//
//  Announcement.swift
//  SpiderByte
//
//  Created by Alin Fulga on 26/02/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

/**
 Announcement class containing the fields describing an announcement
 */
class Announcement: NSObject {
    @objc var author: String
    @objc var title: String
    @objc var content: String
    @objc var tag: String
    @objc var dateTime: String
    @objc var mailingList: NSMutableArray
    @objc var readingList: NSMutableArray
    @objc var pdf: String
    @objc var priority: Int
    @objc var photoB64: String
    @objc var hasEvent: Int
    /**
     Traditional constructor for announcements
     */
    init(author: String, title: String, content: String, tag: String, dateTime: String, mailingList: NSMutableArray, readingList: NSMutableArray, pdf: String, priority: Int, photoB64: String, hasEvent: Int) {
        self.author = author
        self.title = title
        self.content = content
        self.tag = tag
        self.dateTime = dateTime
        self.mailingList = mailingList
        self.readingList = readingList
        self.pdf = pdf
        self.priority = priority
        self.photoB64 = photoB64
        self.hasEvent = hasEvent

    }
    /**
     Constructor for announcements that are connected to Firebase, through a data snapshot of the database.
     */
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String:Any]
        else { return nil }
        guard let author = dict["author"] as? String else { return nil }
        guard let title = dict["title"] as? String else { return nil }
        guard let content = dict["content"] as? String else { return nil }
        guard let tag = dict["tag"] as? String else { return nil }
        guard let dateTime = dict["dateTime"] as? String else { return nil }
        guard let maililngList = dict["mailingList"] as? NSMutableArray else { return nil } 
        guard let readingList = dict["readingList"] as? NSMutableArray else { return nil }
        guard let pdf = dict["pdf"] as? String else { return nil }
        guard let priority = dict["priority"] as? Int else { return nil }
        guard let photoB64 = dict["photoB64"] as? String else { return nil }
        guard let hasEvent = dict["hasEvent"] as? Int else { return nil }
        

        self.author = author
        self.title = title
        self.content = content
        self.tag = tag
        self.dateTime = dateTime
        self.mailingList = maililngList
        self.readingList = readingList
        self.pdf = pdf
        self.priority = priority
        self.photoB64 = photoB64
        self.hasEvent = hasEvent
        
        
    }
    /**
     Default constructor for announcements
     */
    convenience override init() {
        self.init(author: "", title: "", content: "", tag: "", dateTime: "", mailingList: ["all"], readingList: ["none"], pdf: "", priority: 0, photoB64: "", hasEvent: 0)
    }
    /**
     Check validity of an announcement
    */
    func isValidAnnouncement(author: String, title: String, content: String, tag: String, dateTime: String, priority: Int, hasEvent: Int)  -> Bool {
        if author.isEmpty || title.isEmpty || content.isEmpty || tag.isEmpty || dateTime.isEmpty || priority >= 0 || hasEvent > 1 {
            return false
        }
        return true
    }
    
}
