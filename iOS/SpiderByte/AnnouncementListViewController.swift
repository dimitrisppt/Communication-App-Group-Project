//
//  AnnouncementListViewController.swift
//  SpiderByte
//
//  Created by Alin Fulga on 26/02/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabaseUI
import FontAwesomeIconFactory
import HTagView

/**
 View controller that contains the list of announcements in the form of a table.
*/
class AnnouncementListViewController: UIViewController, UITableViewDelegate, HTagViewDelegate, HTagViewDataSource {
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    var availableAnnouncements: NSMutableArray = []
    var hiddenCells: NSMutableArray = []
    var allAnnouncements = [Announcement]()
    
    @IBOutlet weak var tagView: HTagView!
    @IBOutlet weak var tableView: UITableView!
    
    let identifier = "announcement"
    let tags = ["General", "Important", "Careers", "Modules"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        
        initialiseTagView()
        initialiseTableCellNib()
        initialiseData()
        checkUserRegistered()

    }
    /**
     Set attributes for tag view, a horizontal list of tags, and initialize it to have the first tag selected.
    */
    private func initialiseTagView() {
        tagView.delegate = self
        tagView.dataSource = self
        tagView.marg = 7
        tagView.btwTags = 12
        tagView.btwLines = 1
        tagView.tagFont = UIFont.systemFont(ofSize: 15)
        tagView.tagMainBackColor = UIColor(hexString: "#009688")
        tagView.tagSecondBackColor = UIColor.white
        tagView.tagSecondTextColor = UIColor(hexString: "#009688")
        tagView.tagContentEdgeInsets = UIEdgeInsets(top: 10, left: 4, bottom: 10, right: 4)
        tagView.tagMaximumWidth = .HTagAutoWidth
        tagView.tagBorderColor = UIColor(hexString: "#009688").cgColor
        tagView.tagBorderWidth = 1
        tagView.selectTagAtIndex(0)
    }
    /**
    Register the "AnnouncementTableViewCell" nib as the current design for the table cells.
    */
    private func initialiseTableCellNib() {
        
        let nib = UINib(nibName: "AnnouncementTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        tableView.scrollsToTop = false
    }
    /**
     Check if conditions needed to show the announcement to the user are satisfied
     @param: announcement
    */
    private func isAnnouncementVisbile(announcement: Announcement) -> Bool {
        let searchText = (self.tabBarController as! TabBarViewController).getSearchText().lowercased()
        if announcement.mailingList.count >= 0 &&
            (announcement.mailingList.contains((self.tabBarController as! TabBarViewController).getEmail()) ||
                announcement.mailingList.isEqual(["all"])) && (announcement.title.lowercased().contains(searchText) || announcement.content.lowercased().contains(searchText) || announcement.author.lowercased().contains(searchText) || searchText.isEmpty){
            if let tag = tags.index(of: announcement.tag.localizedLowercase.localizedCapitalized) {
                if self.tagView.selectedIndices.contains(tag) {
                    return true
                }
            }
        }
        return false
    }
    /**
     Retrieve data from Firebase, containing all the fields for the announcements, setting the cells for
     the announcements that are visible to the user, and have the tags the user selected, and also the keywords of the search,
     in case the search is not empty
     
     @return cell    -returns the cell after all the announcement data for it have been added.
     */
    func initialiseData() {
        dataSource?.unbind()
        dataSource = AnnouncementDataSource(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
            let emptyCell = UITableViewCell()
            emptyCell.selectionStyle = .none
            emptyCell.isHidden = true
            self.hiddenCells.add(indexPath.row)
            self.availableAnnouncements.remove(indexPath)
            guard let announcement = Announcement(snapshot: snap) else { return emptyCell }
            if self.isAnnouncementVisbile(announcement: announcement) {
                self.hiddenCells.remove(indexPath.row)
                self.availableAnnouncements.add(indexPath)
                let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! AnnouncementTableViewCell
                if let decodedImage = Data(base64Encoded: announcement.photoB64, options: .ignoreUnknownCharacters) {
                    cell.authorImage.image =  UIImage(data: decodedImage)
                    cell.authorImage.clipsToBounds = true
                    cell.authorImage.layer.masksToBounds = true
                    cell.authorImage.layer.cornerRadius = cell.authorImage.frame.width / 2
                }
                cell.author.text = announcement.author
                if !announcement.readingList.contains((self.tabBarController as! TabBarViewController).getEmail()) { // Announcement not read results in bold text
                    cell.title.font = UIFont.boldSystemFont(ofSize: 17.0)
                    cell.content.font = UIFont.boldSystemFont(ofSize: 15.0)
                }
                else {
                    cell.title.font = UIFont.systemFont(ofSize: 17.0)
                    cell.content.font = UIFont.systemFont(ofSize: 15.0)
                }
                cell.title.text = announcement.title
                cell.content.text = announcement.content
                cell.dateTime.text = self.formatDate(inputString: announcement.dateTime)
                tableView.separatorStyle = .singleLine
                tableView.backgroundView = nil
                return cell
            }
            if self.availableAnnouncements.count == 0 { // When there are no announcements, display a different view in the center of the screen
                tableView.backgroundView = self.createCenterViewNoData(tableView: tableView)
                tableView.separatorStyle = .none
            }
            else {
                tableView.separatorStyle = .singleLine
                tableView.backgroundView = nil
            }
            return emptyCell
        }

        dataSource?.bind(to: tableView)
        tableView.reloadData()
        
    }
    /**
     The function checks if the email of the user is already in the app-users table in the database, and if not, the user is added.
    */
    private func checkUserRegistered() {
        let appUsersRef = ref.child("app-users")
        appUsersRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var appUsers = currentData.value as? [String : AnyObject] {
                var appUsersList = appUsers["iOS"] as? NSMutableArray ?? []
                
                if appUsersList == ["none"] {
                    appUsersList = [(self.tabBarController as! TabBarViewController).getEmail()]
                }
                else {
                    if !appUsersList.contains((self.tabBarController as! TabBarViewController).getEmail()) {
                        appUsersList.add((self.tabBarController as! TabBarViewController).getEmail())
                    }
                }
                
                appUsers["iOS"] = appUsersList as AnyObject?
                
                // Set value and report transaction success
                currentData.value = appUsers
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialiseData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if availableAnnouncements.contains(indexPath) {
            performSegue(withIdentifier: "announcementDetail", sender: indexPath)
        }
    }
    /** Function to deal with the height of a row of a table view,
     to make sure the row that doesnt have anything should be hidden.
     
     @param tableView
     @param indexPath
     
     @return a non negative floating point.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if hiddenCells.contains(indexPath.row) {
            return 0
        }
        return 100
    }
    /**
     Function to decide the query for the Firebase Database based on the sorting order of announcements.
     @return query for the Firebase Database
     */
    private func getQuery() -> DatabaseQuery {
        if (self.tabBarController as! TabBarViewController).getAnnouncementOrder() == 1 {
            return ((ref?.child("announcements"))?.queryOrdered(byChild: "priority"))!
        }
        else if (self.tabBarController as! TabBarViewController).getAnnouncementOrder() == 2 {
            return ((ref?.child("announcements"))?.queryOrdered(byChild: "title"))!
        }
        else if (self.tabBarController as! TabBarViewController).getAnnouncementOrder() == 3 {
            return ((ref?.child("announcements"))?.queryOrdered(byChild: "author"))!
        }
        return (ref?.child("announcements"))!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath: IndexPath = sender as? IndexPath else { return }
        guard let detail: AnnouncementDetailViewController = segue.destination as? AnnouncementDetailViewController else {
            return
        }
        if let dataSource = dataSource {
            detail.announcementKey = dataSource.snapshot(at: indexPath.row).key
            detail.email = (self.tabBarController as! TabBarViewController).getEmail()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    private func calculateImageWidth(tableView: UITableView) -> CGFloat {
        return tableView.bounds.width/2-40
    }
    private func calculateImageHeight(tableView: UITableView) -> CGFloat {
        return tableView.bounds.height/2-120
    }
    private func calculateLabelWidth(tableView: UITableView) -> CGFloat {
        return tableView.bounds.width/2-150
    }
    private func calculateLabelHeight(tableView: UITableView) -> CGFloat {
        return tableView.bounds.height/2-70
    }
    /**
     Function creating an image and a message to display in the case there are no announcements found based on the current criteria.
     @param tableView table to display the view in
     @return UIView containing an image an a message
    */
    private func createCenterViewNoData(tableView: UITableView) -> UIView {
        let noDataView = UIView()
        let noDataImage = UIImageView(frame: CGRect(x: calculateImageWidth(tableView: tableView), y: calculateImageHeight(tableView: tableView), width: 70, height: 70))
        let factory = FontAwesomeIconFactory.init()
        let icon = factory.createImage(NIKFontAwesomeIcon.frownO)
        let colorIcon = icon.withRenderingMode(.alwaysTemplate)
        noDataImage.image = colorIcon
        noDataImage.tintColor = UIColor(hexString: "#009688")
        let noDataLabel = UILabel(frame: CGRect(x: calculateLabelWidth(tableView: tableView), y: calculateLabelHeight(tableView: tableView), width: 300, height: 100))
        noDataLabel.text = "No Announcements Available"
        noDataLabel.textColor = UIColor(hexString: "#009688")
        noDataLabel.textAlignment = .center
        noDataView.addSubview(noDataImage)
        noDataView.addSubview(noDataLabel)
        return noDataView
    }
    /**
     Returns the type of tags of a tag view
     @param tagView
     @param index
     @return select type is used.
    */
    func tagView(_ tagView: HTagView, tagTypeAtIndex index: Int) -> HTagType {
        return .select
    }
    /**
     Returns the title of tags of a tag view
     @param tagView
     @param index
     @return title of each tag.
     */
    func tagView(_ tagView: HTagView, titleOfTagAtIndex index: Int) -> String {
        return tags[index]
    }
    /**
     Returns the number of tags
     @param tagView
     @return number of tags.
     */
    func numberOfTags(_ tagView: HTagView) -> Int {
        return tags.count
    }
    /**
     Refresh Firebase Data when a tag is pressed.
     @param tagView
     @param selectedIndices
    */
    func tagView(_ tagView: HTagView, tagSelectionDidChange selectedIndices: [Int]) {
        initialiseData()
    }
    /**
     Function called when cancel is pressed (not implemented).
     @param tagView
     @param index
     */
    func tagView(_ tagView: HTagView, didCancelTagAtIndex index: Int) {

    }
    private func formatDate(inputString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        dateFormatter.timeZone = Calendar.current.timeZone
        let date = dateFormatter.date(from: inputString)
        if let validDate = date {
            return timeAgoSince(validDate)
        }
        return timeAgoSince(Date())
        
    }
    func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
        
    }

}

