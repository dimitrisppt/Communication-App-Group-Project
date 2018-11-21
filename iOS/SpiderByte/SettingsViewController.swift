//
//  SettingsViewController.swift
//  SpiderByte
//  Author: Mohammad Sadi
//  Copyright © 2018 King's College London. All rights reserved.



import UIKit
import Firebase
import FirebaseDatabaseUI
import FontAwesomeIconFactory

/**
 This method converts a hex number colour to a colour object
 */
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    /**
     This method converts a hex number colour to a colour object
     */
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}


/**
 The Settings class contains a Table View displaying data of the user, suitable information to report any issue, about the app's license, another way to view the tutorial and a logout button.
 */
class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var SettingsTableView: UITableView!
    var tabBar : TabBarViewController!
    let data:[String] = ["Name", "Email Address", "Feedback", "About", "Tutorial", "Version"]
   
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    /**
     The method determines how many rows the table view should have
     
     @param tableView, numberOfRowsInSection
     
     @return number of rows in section
    */
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    /**
     The method determines how many sections the table view should have
     
     @param  tableView
     @return number of sections in table view
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     The method initialises a table view with all the contents
     
     @param tableView, cellForRowAt indexPath
     @return the table view
     */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let subs:[String] = ["\(tabBar.getName())", "\(tabBar.getEmail())", "Report a problem", "More Information","Go back to the demo tutorial", "1.0"]
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let fontFactory = FontAwesomeIconFactory.button()
        let color = UIColor(hexString: "#009688")
        
        switch indexPath.row {
        case 0 : cell.imageView?.image = fontFactory.createImage(NIKFontAwesomeIcon.user).withRenderingMode(.alwaysTemplate)
        case 1: cell.imageView?.image = fontFactory.createImage(NIKFontAwesomeIcon.envelope).withRenderingMode(.alwaysTemplate)
        case 2: cell.imageView?.image = fontFactory.createImage(NIKFontAwesomeIcon.comment).withRenderingMode(.alwaysTemplate)
        case 3: cell.imageView?.image = fontFactory.createImage(NIKFontAwesomeIcon.infoCircle).withRenderingMode(.alwaysTemplate)
        case 4: cell.imageView?.image = fontFactory.createImage(NIKFontAwesomeIcon.arrowRight).withRenderingMode(.alwaysTemplate)
        case _: cell.imageView?.image = fontFactory.createImage(NIKFontAwesomeIcon.codeFork).withRenderingMode(.alwaysTemplate)
        }
        
        
        cell.imageView?.tintColor = color
        cell.textLabel?.text = data[indexPath.row]
        cell.detailTextLabel?.text = subs[indexPath.row]
        return cell
    }
    
    /**
     The method determines the height of the rows in the table view
     
     @param tableView, heightForRowAt indexPath
     @return a float value depicting the height of the rows
     */
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    /**
     The method contains three segues for the user with appropiate destinations.
     
     @param tableView, didSelectRowAt indexPath
     @return segue destinations
     */
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2: performSegue(withIdentifier: "segue", sender: self)
        case 3: performSegue(withIdentifier: "segue1", sender: self)
        case 4: performSegue(withIdentifier: "tutorialSegue", sender: self)
        default:print("Some error as it is out of cases")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar = tabBarController as? TabBarViewController

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     The method disconnects the user from the app whenever the logout button is pressed
     
     @param sender
     
     @return logs out the user from the app
     */
    @IBAction func onLogoutButtonPressed(_ sender: Any) {
        Authentication.sharedInstance?.disconnect()
        performSegue(withIdentifier: "logout", sender: nil)
    }
    
    
}

