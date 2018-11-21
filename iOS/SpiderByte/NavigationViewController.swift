//
//  NavigationViewController.swift
//  SpiderByte
//
//  Created by Alin Fulga on 02/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import UIKit

@objc protocol NavigationViewControllerDelegate {
    
}
/**  Class for the navigation of our iOS application.
 */
class NavigationViewController: UINavigationController {
    
    var del: NavigationViewControllerDelegate?

    /**  Function that deals with one instance of our application being launched at a given time.
 */
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
