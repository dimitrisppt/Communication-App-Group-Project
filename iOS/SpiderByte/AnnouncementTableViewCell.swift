//
//  AnnouncementTableViewCell.swift
//  SpiderByte
//
//  Created by Alin Fulga on 26/02/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

/**  The following class contains the outlets for the announcement table view, and for its rows.
 */
class AnnouncementTableViewCell: UITableViewCell {


    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var dateTime: UILabel!
    var announcementKey: String?
    var announcementRef: DatabaseReference!
}
