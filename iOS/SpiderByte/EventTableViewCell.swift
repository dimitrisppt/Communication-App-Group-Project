//
//  EventTableViewCell.swift
//  SpiderByte
//
//  Created by Kymani Lawrence on 10/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


/**
  This class contains the outlets for the cells (rows) of the event Table View.
 */
class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    var announcementKey: String?
    var announcementRef: DatabaseReference!
}
