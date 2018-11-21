//
//  LoginViewController.swift
//  SpiderByte
//
//  Created by Alin Fulga on 28/02/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import UIKit

/**  the view controller class for the login screen of our iOS application.
 */
class LoginViewController: UIViewController {

    // necessary outlets.
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** Function to display the view.
     
     @param animated - boolean value.
 */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /**  Function for outlet, when login button is pressed. Call authenticate method.
     
     @param sender
 */
    @IBAction func onLoginButtonPressed(_ sender: Any) {
        authenticate()
    }
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }
    
    /**  Function for the authentication of a user, authenticates via connecting to the microsoft server,
     and allows the user to sign in on a separate window using the kcl.ac.uk username and login.
 */
    private func authenticate() {
        loadingUI(show: true)
        let scopes = AuthenticationConstants.kScopes
        
        Authentication.sharedInstance?.connectToGraph( scopes: scopes) {
            (result: AuthenticationConstants.MSGraphError?, accessToken: String) -> Bool  in
            
            defer {self.loadingUI(show: false)}
            
            if let graphError = result {
                switch graphError {
                case .nsErrorType(let nsError):
                    print("Microsoft Authentification Error =", nsError.userInfo)
                    self.showError(message: "Could not connect to Microsoft server")
                }
                return false
            }
            else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
                return true
            }
        }
    }
    
    /** Function for loading the UI during the login process.
     
     @param show - take a boolean value.
 */
    private func loadingUI(show: Bool) {
        if show {
            self.activityIndicator.startAnimating()
            self.loginButton.setTitle("Connecting", for: UIControlState())
            self.loginButton.isEnabled = false
        }
        else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.loginButton.setTitle("Login", for: UIControlState())
                self.loginButton.isEnabled = true
            }
        }
    }
    
    
    /** Function for display of the error message to the user upon failed authentication.
     
     @param message - string message to user.
 */
    private func showError(message:String) {
        DispatchQueue.main.async(execute: {
            let alertControl = UIAlertController(title: "Login error", message: message, preferredStyle: .alert)
            alertControl.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            
            self.present(alertControl, animated: true, completion: nil)
        })
    }
}
