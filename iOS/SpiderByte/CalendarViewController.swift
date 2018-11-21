//
//  calendarViewController.swift
//  SpiderByte
//
//  Created by Maiwand Maidanwal on 24/02/2018.
//  Copyright © 2018 Maiwand Maidanwal. All rights reserved.
//



import UIKit
import JTAppleCalendar
import Firebase
import FirebaseDatabaseUI
import FontAwesomeIconFactory

/**
 The Calendar View Controller class, for all the implementation of the functionality
 of the calendar page of the app.
 */

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var eventTableView: UITableView!


    // Declare relevant global fields
    
    let outsideMonthColor =  UIColor(hexString: "#E6E6E6")
    let monthColor = UIColor(colorWithHexValue: 0x584a66)
    let selectedMonthColor = UIColor.white
    let currentDateSelectedViewColor = UIColor.blue
    let identifier = "event"

    let formatter = DateFormatter()
    let todaysDate = Date()
    var eventsFromtheServer: [String:String] = [:]
    var selectedDate = Date()
    
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    var availableEvents: NSMutableArray = []
    var hiddenCells: NSMutableArray = []
    var filteredEvents = [Event]()
    var allEvents = [Event]()
    var eventDates: NSMutableArray = []


    /**
     This method is called after the view controller has loaded, and its contents are loaded right after.
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([ Date() ])
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        
        initialiseTableCellNib()
        initialiseData()
        setupCalendarView()
    }
    
  /**
   Method sets up the basic parts of the calendar, and removes spacing to accomodate for circle upon date selection.
 */
    
    func setupCalendarView(){
        
        //calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // set up year and month labels
        calendarView.visibleDates{ visibleDates in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    /**
        Method deals with the color of the text of date label, before, after and upon selection.
     
     @param view  - parameter taking JTAppleCell
     
     @param cellState - parameter for checking the cellstate of each state at a given time.
 */
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState){
        formatter.dateFormat = "yyyy-MM-dd"
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        guard let validCell = view as? CustomCell else{ return}
        
        if validCell.selectedView.isHidden == false {
            validCell.dateLabel.textColor = selectedMonthColor
        }
        else {
            if cellState.dateBelongsTo == .thisMonth{
                validCell.dateLabel.textColor = monthColor
            }else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
        if todaysDateString == monthDateString{

            if validCell.selectedView.isHidden == false {
                validCell.dateLabel.textColor = selectedMonthColor
            }else{
                
                validCell.dateLabel.textColor = UIColor(hexString: "#009688")
            
            }
        }
    }
    
    /**
     This method deals with the selection of a cell.
     simple upon selection condition.
     
     @param view
     
     @param cellState
 */
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else {return}
        
        if validCell.isSelected && cellState.dateBelongsTo == .thisMonth{
            validCell.selectedView.isHidden = false
        }else{
            validCell.selectedView.isHidden = true
            validCell.isSelected = false
        }
        
    }
    
    /**
     This function changes the text color and size of the dot from the calendar events.
     
     @param view
     @param color
    */
    func handleCellDotColor(view: JTAppleCell?, color: UIColor) {
        if let cellTextString = (view as? CustomCell)?.dateLabel.text {
            let cellText = NSMutableAttributedString(string: cellTextString)
            cellText.createBoldColoredText(textToFind: ".", color:  color)
            cellText.createBoldColoredText(textToFind: " ", color:  color)
            (view as! CustomCell).dateLabel.attributedText = cellText
        }
    }
    
    /**
     Default included method
 */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



/**
    Below are the addition extensions to this file.
 */



extension CalendarViewController: JTAppleCalendarViewDataSource{

 /**
        This function configures the calendar itself, aligning it to current timezone, as well as the formats
     of the date.
     
     @return  parameters - Defines the parameters which configures the calendar.
 */
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2050 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    /**  Function sets up the views of the calendar, and for the year and month label.
     
     @param visibleDates The date range set for the calendar.
 */
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
    }
}

/** Extensions for the ViewDelegate.
 */
extension CalendarViewController: JTAppleCalendarViewDelegate{
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    /**
        To display the cell.
     
     @param calendar
     
     @param date
     
     @param cellState
     
     @param indexPath
     
       @return cell   For the returning variable of this function, the cell.
 */
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell

        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
  
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.8
        var cellTextString = cellState.text + "\r\n "
        if eventDates.contains(date) {
            cellTextString = cellState.text + "\r\n."
        }
        let cellText = NSMutableAttributedString(string: cellTextString)
        cellText.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, cellText.length))
        cellText.createBoldColoredText(textToFind: ".", color:  UIColor(hexString: "#009688"))
        cellText.createBoldColoredText(textToFind: " ", color:  UIColor(hexString: "#009688"))
        cell.dateLabel.attributedText = cellText
        cell.dateLabel.textAlignment = NSTextAlignment.center

        
        return cell
    }
    
    /** Function that upon selection will deal with the cell's color and selection.
 */
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {

        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        if cellState.dateBelongsTo == .thisMonth {
            selectedDate = date
            self.eventTableView.reloadData()
            handleCellDotColor(view: cell, color: UIColor.white)
        }
        else {
            handleCellDotColor(view: cell, color: UIColor(hexString: "#009688"))
        }
    
    }
    
    /** Function that upon de-selection will deal with the cell's color and de-selection.
     */
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {

        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellDotColor(view: cell, color: UIColor(hexString: "#009688"))

    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
        self.eventTableView.reloadData()
        self.calendarView.reloadData()
    }
}

/** Extensions for the delegate of the TableView which displays events on calendar page.
 */
extension CalendarViewController: UITableViewDelegate {
    
    private func initialiseTableCellNib() {
        let nib = UINib(nibName: "EventTableViewCell", bundle: nil)
        eventTableView.register(nib, forCellReuseIdentifier: identifier)
        eventTableView.delegate = self
    }
    
    /**
     Retrieve data from Firebase, containing all the fields for the events, setting the cells for
     the events that are visible to the user, and are selected in the calendar (or searched)
     
     @return cell    -returns the cell after all the events for it have been added.
    */
    func initialiseData() {
        dataSource?.unbind()
        eventDates = []
        dataSource = FUITableViewDataSource(query: getQuery()) { (eventTableView, indexPath, snap) -> UITableViewCell in
            
            let emptyCell = UITableViewCell()
            emptyCell.selectionStyle = .none
            emptyCell.isHidden = true
            self.hiddenCells.add(indexPath.row)
            self.availableEvents.remove(indexPath)
            guard let event = Event(snapshot: snap) else { return emptyCell }
            
            self.formatter.dateFormat = "yyyy-MM-dd"
            
            self.eventDates.add(self.formatter.date(from: event.day)!)
            
            // Check if the selected date is an actual date
            if let eventDate = self.formatter.date(from: event.day) {

               let searchText = (self.tabBarController as! TabBarViewController).getSearchText().lowercased()
                //the different conditions for which to deal with events, and to ensure it displays with search.
               if event.mailingList.count >= 0 &&
                (event.mailingList.contains((self.tabBarController as! TabBarViewController).getEmail()) ||
                    event.mailingList.isEqual(["all"])) && (event.title.lowercased().contains(searchText) || event.desc.lowercased().contains(searchText) || event.day.lowercased().contains(searchText) || event.location.lowercased().contains(searchText)) || (searchText.isEmpty && eventDate == self.selectedDate) {
                
                    self.hiddenCells.remove(indexPath.row)
                    self.availableEvents.add(indexPath)
                    let cell = eventTableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as! EventTableViewCell
                
                    cell.selectionStyle = .none
                    cell.descr.text = event.desc
                    cell.title.text = event.title
                    cell.day.text = event.day
                    cell.location.text = event.location
                    cell.time.text = event.starttime + " - " + event.endtime;
                    eventTableView.separatorStyle = .singleLine
                    eventTableView.backgroundView = nil
                    return cell
                }
                if self.availableEvents.count == 0 {
                    eventTableView.backgroundView = self.createCenterViewNoData(eventTableView: eventTableView)
                    eventTableView.separatorStyle = .none
                }
                else {
                    eventTableView.separatorStyle = .singleLine
                    eventTableView.backgroundView = nil
                }

            }
            return emptyCell
        }
        
        dataSource?.bind(to: eventTableView)
        calendarView.reloadData()
        self.eventTableView.reloadData()
    }
    
    // functions for calculating dimensions.
    private func calculateImageWidth(eventTableView: UITableView) -> CGFloat {
        return eventTableView.bounds.width/2-15
    }
    private func calculateImageHeight(eventTableView: UITableView) -> CGFloat {
        return eventTableView.bounds.height/2-50
    }
    private func calculateLabelWidth(eventTableView: UITableView) -> CGFloat {
        return eventTableView.bounds.width/2-72
    }
    private func calculateLabelHeight(eventTableView: UITableView) -> CGFloat {
        return eventTableView.bounds.height/2-20
    }
    
    /**
     Function to display the sign to the user that No events are available on a day that doesnt contain any.
 */
    private func createCenterViewNoData(eventTableView: UITableView) -> UIView {
        let noDataView = UIView()
        let noDataImage = UIImageView(frame: CGRect(x: calculateImageWidth(eventTableView: eventTableView), y: calculateImageHeight(eventTableView: eventTableView), width: 35, height: 35))
        let factory = FontAwesomeIconFactory.init()
        let icon = factory.createImage(NIKFontAwesomeIcon.frownO)
        let colorIcon = icon.withRenderingMode(.alwaysTemplate)
        noDataImage.image = colorIcon
        noDataImage.tintColor = UIColor(hexString: "#009688")
        let noDataLabel = UILabel(frame: CGRect(x: calculateLabelWidth(eventTableView: eventTableView), y: calculateLabelHeight(eventTableView: eventTableView), width: 150, height: 50))
        noDataLabel.text = "No Events Available"
        noDataLabel.textColor = UIColor(hexString: "#009688")
        noDataLabel.textAlignment = .center
        noDataView.addSubview(noDataImage)
        noDataView.addSubview(noDataLabel)
        return noDataView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialiseData()
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
     Function to decide the query for the Firebase Database based on the sorting order of events.
     @return query for the Firebase Database
    */
    private func getQuery() -> DatabaseQuery {
        if (self.tabBarController as! TabBarViewController).getEventOrder() == 1 {
            return ((ref?.child("event"))?.queryOrdered(byChild: "priority"))!
        }
        else if (self.tabBarController as! TabBarViewController).getEventOrder() == 2 {
            return ((ref?.child("event"))?.queryOrdered(byChild: "title"))!
        }
        else if (self.tabBarController as! TabBarViewController).getEventOrder() == 3 {
            return ((ref?.child("event"))?.queryOrdered(byChild: "location"))!
        }
        return (ref?.child("event"))!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

/**  Extension for the inclusion of hex colours.
 */
extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            
            alpha : alpha
        )
    }
}

extension NSMutableAttributedString {
    
    func createBoldColoredText(textToFind: String, color: UIColor) {
        
        let range = self.mutableString.range(of: textToFind, options:.caseInsensitive)
        if range.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
            self.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 22), range: range)
        }
    }
}


