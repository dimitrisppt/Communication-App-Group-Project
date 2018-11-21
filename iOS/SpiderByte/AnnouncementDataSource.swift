//
//  AnnouncementDataSource.swift
//  SpiderByte
//
//  Created by Alin Fulga on 19/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import UIKit
import FirebaseDatabaseUI
import FontAwesomeIconFactory

/**  This class contains the functions for the data source of the announcement page of our iOS application.
 */
class AnnouncementDataSource: FUITableViewDataSource {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.count)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
