//
//  CustomCell.swift
//  SpiderByte
//
//  Created by Maiwand Maidanwal on 24/02/2018.
//  Copyright © 2018 Maiwand Maidanwal. All rights reserved.
//

import UIKit
import JTAppleCalendar

/**  This is our class for our custom cell of the calendar, we are using the JTAppleCell from its library
 and we have outlets linking the date label and selected view.
 */

class CustomCell: JTAppleCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
}


