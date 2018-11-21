//
//  AppTutorialViewController.swift
//  SpiderByte
//
//  Created by Sadi Ashraful on 22/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import UIKit
import paper_onboarding

/**
 The class creates an onbaording tutorial with the help of a third party framework named "PaperOnboarding" for the user which will walk him through the existing features of the app
 */
class AppTutorialViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
  
    @IBOutlet weak var getStartedButton: UIButton!
    
    /**
     The method determines how many pages the tutorial should have
     
     returns: number of pages
     */
    internal func onboardingItemsCount() -> Int {
        return 6
    }
    
    /**
     The function enables us to configure each onbaording item.
     
     param: at index
     
     returns: all the onboading items
     */
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return [
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "spider-byte-red") ,
                               title: "Welcome to SpiderByte!",
                               description: "Please take a few minutes to learn about the features of the app",
                               pageIcon: #imageLiteral(resourceName: "active"),
                               color: UIColor(hexString: "f64c73"),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.init(name: "AvenirNext-Bold", size: 24)!,
                               descriptionFont: UIFont.init(name: "AvenirNext-Regular", size: 18)!),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "slide_gesture"),
                               title: "Navigate through the application",
                               description: "Swipe to switch between Announcements, Events and Personal Information",
                               pageIcon: #imageLiteral(resourceName: "active"),
                               color: UIColor(hexString: "20d2bb"),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.init(name: "AvenirNext-Bold", size: 23)!,
                               descriptionFont: UIFont.init(name: "AvenirNext-Regular", size: 18)!),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "lock"),
                               title: "Login with your K-number",
                               description: "You can log in with your existing email, using k-number@kcl.ac.uk",
                               pageIcon: #imageLiteral(resourceName: "active"),
                               color: UIColor(hexString: "#3395ff"),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.init(name: "AvenirNext-Bold", size: 24)!,
                               descriptionFont: UIFont.init(name: "AvenirNext-Regular", size: 18)!),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "bullhorn"),
                               title: "Announcements",
                               description: "You can click on each announcement to see more detail",
                               pageIcon: #imageLiteral(resourceName: "active"),
                               color: UIColor(hexString: "#c873f4"),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.init(name: "AvenirNext-Bold", size: 24)!,
                               descriptionFont: UIFont.init(name: "AvenirNext-Regular", size: 18)!),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "calendar"),
                               title: "Calendar",
                               description: "You can click on dates to see more details about events on that day",
                               pageIcon: #imageLiteral(resourceName: "active"),
                               color: UIColor(hexString: "f64c73"),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.init(name: "AvenirNext-Bold", size: 24)!,
                               descriptionFont: UIFont.init(name: "AvenirNext-Regular", size: 18)!),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "settings"),
                               title: "Settings",
                               description: "You can click on settings tab to see personal information and application details",
                               pageIcon: #imageLiteral(resourceName: "active"),
                               color: UIColor(hexString: "20d2bb"),
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.init(name: "AvenirNext-Bold", size: 24)!,
                               descriptionFont: UIFont.init(name: "AvenirNext-Regular", size: 18)!)
            ][index]
    
    }
    
    /**
     The method checks whether the user is on the second page of the tutorial and starts the onboarding animation after hiding the "GET STARTED" button.
     
     param: index
     */
    internal func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 {
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
        }
    }
    
    /**
     The method performs an action when it is finished transitioning to a specific item. The button "GET STARTED" starts animating in as soon as the onboarding transition is finished.
     
     param: tableView
     */
    internal func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 5 {
            UIView.animate(withDuration: 0.2, animations: {
                self.getStartedButton.alpha = 1
            })
        }
    }
    
    
    /**
     The method determines how many sections the table view should have
     
     param: tableView
     
     returns: number of sections in table view
     */
    @IBAction func gotStarted(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "onboardingComplete")
        userDefaults.synchronize()
    }
    

    @IBOutlet weak var onboardingView: OnboardingView!
    
    /**
     Apart from the usual method for loading the view, we add the datasource and delegate for the onboarding view.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self
        onboardingView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
