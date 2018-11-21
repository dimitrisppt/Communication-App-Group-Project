//
//  TabBarViewController.swift
//  SpiderByte
//
//  Created by Alin Fulga on 26/02/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import UIKit
import FontAwesomeIconFactory

/** View controller for the tab bar that is displayed in the footer of each page of our iOS application.
 */
class TabBarViewController: UITabBarController, UISearchBarDelegate {

    //Connected outlets.
    @IBOutlet weak var searchButtonItem: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UITabBar!
    @IBOutlet weak var organiseButtonItem: UIBarButtonItem!
    
    var searchBar: UISearchBar!
    var saveSearchButtonItem: UIBarButtonItem!
    var saveOrganiseButtonItem: UIBarButtonItem!
    var email: String!
    var name: String!
    var currentTabItem: UITabBarItem!
    var searchString: String!
    var announcementOrder: Int = 1
    var eventOrder: Int = 2
    
    /** Call the other functions within view did load, as it is required upon the page load
     directy after clicking the announcement.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialTabBaritem()
        resetSearchBarText()
        removeBackButton()
        checkUserLoggedIn()
        checkUserIsKCLStudent()
        initialiseTabIcons()
        initialiseSearchBar()
        saveNavigationBarItems()
    }
    
    private func removeBackButton() {
        navigationItem.hidesBackButton = true
    }
    
    /** Function for checking is a user is currently logged in, and catches the exception, to display message.
 */
    private func checkUserLoggedIn() {
        do {
        try email = (Authentication.sharedInstance?.authenticationProvider.users()[0].displayableId)!
        try name = (Authentication.sharedInstance?.authenticationProvider.users()[0].name)!
        } catch {
            Authentication.sharedInstance?.disconnect()
            performSegue(withIdentifier: "unauthorizedUser", sender: nil)
            showError(message: "You are not logged in. Please click the Login button.")
        }
    }
    
    func getSearchText() -> String {
        return searchString
    }
    
    func getName () -> String {
        return name
    }
    
    func getEmail() -> String {
        return email
    }
    
    func getAnnouncementOrder() -> Int {
        return announcementOrder
    }
    
    func getEventOrder() -> Int {
        return eventOrder
    }
    
    /** Function checks if a user is a student, easily checked by their email. Otherwise disconnects user,
     displays message.
 */
    private func checkUserIsKCLStudent() {
        if !email.hasSuffix("@kcl.ac.uk") {
            Authentication.sharedInstance?.disconnect()
            performSegue(withIdentifier: "unauthorizedUser", sender: nil)
            showError(message: "This application is only accessible for King's College London students. Please login with a student email.")
        }
    }
    @IBAction func onSearchPressed(_ sender: Any) {
        showSearchBar()
    }
    
    /**   Code for the outlet connected, the sorting and organising of items.
 */
    @IBAction func onOrganizePressed(_ sender: Any) {
        
        let organizer = UIAlertController(title: "Please select how you would like to sort", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let tabItems = navigationBar.items
        if currentTabItem == tabItems![0]{
            organizer.addAction(UIAlertAction(title: "Sort by date", style: .default , handler:{ (UIAlertAction)in
                self.setSortingAnnouncementBy(order: 1)
            }))
            organizer.addAction(UIAlertAction(title: "Sort alphabetically", style: .default , handler:{ (UIAlertAction)in
                self.setSortingAnnouncementBy(order: 2)
            }))
            organizer.addAction(UIAlertAction(title: "Sort by author", style: .default , handler:{ (UIAlertAction)in
                self.setSortingAnnouncementBy(order: 3)
            }))
            
        }else if currentTabItem == tabItems![1]{
            organizer.addAction(UIAlertAction(title: "Sort by date", style: .default , handler:{ (UIAlertAction)in
                self.setSortingEventBy(order: 1)
            }))
            organizer.addAction(UIAlertAction(title: "Sort alphabetically", style: .default , handler:{ (UIAlertAction)in
                self.setSortingEventBy(order: 2)
            }))
            organizer.addAction(UIAlertAction(title: "Sort by venue", style: .default , handler:{ (UIAlertAction)in
                self.setSortingEventBy(order: 3)
            }))
        }
        organizer.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction) in }))
        self.present(organizer, animated: true, completion: {})
    }
    private func setSortingAnnouncementBy(order: Int) {
        if announcementOrder != order {
            let announcementView = self.selectedViewController as! AnnouncementListViewController
            announcementOrder = order
            announcementView.initialiseData()
        }
    }
    private func setSortingEventBy(order: Int) {
        if eventOrder != order {
            let eventView = self.selectedViewController as! CalendarViewController
            eventOrder = order
            eventView.initialiseData()
        }
    }
    private func saveNavigationBarItems() {
        saveSearchButtonItem = searchButtonItem
        saveOrganiseButtonItem = organiseButtonItem
    }
    /** Initialise the icons for the nagivation tab, shows that there are 3 icons.
 */
    private func initialiseTabIcons() {
        if navigationBar.items?.count == 3 {
            let factory = FontAwesomeIconFactory.tabBarItem()
            if let announcementTab = navigationBar.items?[0] {
                announcementTab.image = factory.createImage(NIKFontAwesomeIcon.bullhorn)
            }
            if let calendarTab = navigationBar.items?[1] {
                calendarTab.image = factory.createImage(NIKFontAwesomeIcon.calendar)
            }
            if let settingsTab = navigationBar.items?[2] {
                settingsTab.image = factory.createImage(NIKFontAwesomeIcon.cog)
            }
        }
    }
    
    /** Initialise the view, color and sizing of the search bar, in the header.
 */
    private func initialiseSearchBar() {
        searchBar = UISearchBar()
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        UITextField.appearance(whenContainedInInstancesOf : [UISearchBar.self]).textColor = UIColor.white
    }
    
    /** Function for the display of the search bar.
 */
    private func showSearchBar() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.setRightBarButtonItems([], animated: true)
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    
    /** Function for hiding the search bar when it is unecessary.
 */
    private func hideSearchBar() {
        navigationItem.setRightBarButtonItems([saveOrganiseButtonItem, saveSearchButtonItem], animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationItem.titleView = UILabel()
        }, completion: { finished in
            
        })
    }
    
    /** Called when view is reloaded. Or when cancelled search.
 */
    private func resetSearchBarText() {
        searchString = ""
        if let searchBar = searchBar {
            searchBar.text = searchString
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearchBarText()
        hideSearchBar()
    }
    
    func initialTabBaritem() {
        currentTabItem = navigationBar.items![0]
    }
    /** An ovveride function for then whe tab bar is selected, the search must be reset.
     
     @param tabBar
     @param item
 */
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        currentTabItem = navigationBar.selectedItem
        resetSearchBarText()
        hideSearchBar()
        if item == navigationBar.items![2] {
            navigationItem.setRightBarButtonItems([], animated: true)
        }
        else {
            navigationItem.setRightBarButtonItems([saveOrganiseButtonItem, saveSearchButtonItem], animated: true)
        }
    }
    /**
     Listener for getting text changes in the search bar and sending them to the relevant controller for filtering.
     @param searchBar
     @param searchText
    */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchText
        let tabItems = navigationBar.items
        if currentTabItem == tabItems![0]{
            let announcementView = self.selectedViewController as! AnnouncementListViewController
            announcementView.initialiseData()
        }else if currentTabItem == tabItems![1]{
            let calendarView = self.selectedViewController as! CalendarViewController
            calendarView.initialiseData()
        }
    }

    private func showError(message:String) {
        DispatchQueue.main.async(execute: {
            let alertControl = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
            alertControl.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            
            self.present(alertControl, animated: true, completion: nil)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}
