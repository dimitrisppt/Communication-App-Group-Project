//
//  Event.swift
//  SpiderByte
//
//  Created by Kymani Lawrence on 10/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

/**
 Event class containing the fields describing an event
*/

class Event: NSObject {
    @objc var desc: String
    @objc var title: String
    @objc var day: String
    @objc var location: String
    @objc var starttime: String
    @objc var endtime: String
    @objc var mailingList: NSMutableArray
    @objc var priority: Int
    
    /**
     Traditional constructor for events
    */
    
    init(desc: String, title: String, day: String, location: String, starttime: String, endtime: String, mailingList: NSMutableArray, priority: Int) {
        self.desc = ""
        self.title = ""
        self.day = ""
        self.location = ""
        self.starttime = ""
        self.endtime = ""
        self.mailingList = []
        self.priority = 0
        
    }
    
    /**
     Constructor for events that are connected to Firebase, through a data snapshot of the database.
    */
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String:Any]
            else { return nil }
        guard let desc = dict["desc"] as? String else { return nil }
        guard let title = dict["title"] as? String else { return nil }
        guard let day = dict["day"] as? String else { return nil }
        guard let location = dict["location"] as? String else { return nil }
        guard let starttime = dict["starttime"] as? String else { return nil }
        guard let endtime = dict["endtime"] as? String else { return nil }
        guard let maililngList = dict["mailingList"] as? NSMutableArray else { return nil }
        guard let priority = dict["priority"] as? Int else { return nil }
        

        self.desc = desc
        self.title = title
        self.day = day
        self.location = location
        self.starttime = starttime
        self.endtime = endtime
        self.mailingList = maililngList
        self.priority = priority
    }
    
    /**
    Default constructor for events
    */
    convenience override init() {
        self.init(desc: "", title: "", day: "", location: "", starttime: "", endtime: "", mailingList: [""], priority: 0)
    }
    /**
     Check validity of an event.
    */
    func isValidEvent(desc: String, title: String, day: String, location: String, starttime: String, priority: Int, endtime: String)  -> Bool {
        if desc.isEmpty || title.isEmpty || day.isEmpty || location.isEmpty || starttime.isEmpty || priority >= 0 || endtime.isEmpty {
            return false
        }
        return true
    }
    
}
