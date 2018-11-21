//
//  Authentication.swift
//  SpiderByte
//
//  Created by Alin Fulga on 02/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import Foundation
import MSAL

/**
 Microsoft Authentication class providing connection functionality.
*/
class Authentication {
    

    class var sharedInstance: Authentication? {
        struct Singleton {
            static let instance = Authentication.init()
        }
        return Singleton.instance
    }
    
    var authenticationProvider = MSALPublicClientApplication.init()
    var accessToken: String = ""
    var lastInitError: String? = ""
    
    /**
     Constructor initializes the public client and redirect URI.
    */
    init () {
        
        do {
            var redirectUrl: String = "";
            var myDict: NSDictionary?
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
                myDict = NSDictionary(contentsOfFile: path)
            }
            if let dict = myDict {
                let array: NSArray =  (dict.object(forKey: "CFBundleURLTypes") as? NSArray)!;
                redirectUrl = getRedirectUrlFromMSALArray(array: array);
            }
            let range: Range<String.Index> = redirectUrl.range(of: "msal")!;
            let kClientId = String(redirectUrl[range.upperBound...]);
            
            authenticationProvider = try MSALPublicClientApplication.init(clientId: kClientId, authority: AuthenticationConstants.kAuthority)
        } catch  let error as NSError  {
            self.lastInitError = error.userInfo.description
            authenticationProvider = MSALPublicClientApplication.init()
        }
    }
    /**
     Connection to the Microsoft Graph service, through either silent login (user already logged in), or token acquisition.
     
     @param scopes
     @param completion
    */
    func connectToGraph(scopes: [String],
                        completion:@escaping (_ error: AuthenticationConstants.MSGraphError?, _ accessToken: String) -> Bool)  {
        
        do {
            if let initError = self.lastInitError {
                if initError.lengthOfBytes(using: String.Encoding.ascii) > 1 {
                    throw NSError.init(domain: initError, code: 0, userInfo: nil)
                }
            }

            if  try authenticationProvider.users().isEmpty {
                throw NSError.init(domain: "MSALErrorDomain", code: MSALErrorCode.interactionRequired.rawValue, userInfo: nil)
            } else {

                try authenticationProvider.acquireTokenSilent(forScopes: scopes, user: authenticationProvider.users().first) { (result, error) in
                    
                    if error == nil {
                        self.accessToken = (result?.accessToken)!
                        _ = completion(nil, self.accessToken);
                        
                        
                    } else {

                        var _ = completion(AuthenticationConstants.MSGraphError.nsErrorType(error: error! as NSError), "");
                        
                    }
                }
            }
        }  catch let error as NSError {

            if error.code == MSALErrorCode.interactionRequired.rawValue {
                
                authenticationProvider.acquireToken(forScopes: scopes) { (result, error) in
                    if error == nil {
                        self.accessToken = (result?.accessToken)!
                        var _ = completion(nil, self.accessToken);
                        
                        
                    } else  {
                        var _ = completion(AuthenticationConstants.MSGraphError.nsErrorType(error: error! as NSError), "");
                        
                    }
                }
                
            } else {
                var _ = completion(AuthenticationConstants.MSGraphError.nsErrorType(error: error as NSError), error.localizedDescription);
                
            }
            
        } catch {
            
            var _ = completion(AuthenticationConstants.MSGraphError.nsErrorType(error: error as NSError), error.localizedDescription);
            
        }
    }
    /**
     Disconnect user from Microsoft Account.
    */
    func disconnect() {
        
        do {
            try authenticationProvider.remove(authenticationProvider.users().first)
            
        } catch _ {
            
        }
        
    }

    func getRedirectUrlFromMSALArray(array: NSArray) -> String {
        let arrayElement: NSDictionary = array.object(at: 0) as! NSDictionary;
        let redirectArray: NSArray = arrayElement.value(forKeyPath: "CFBundleURLSchemes") as! NSArray;
        let subString: NSString = redirectArray.object(at: 0) as! NSString;
        return subString as String;
    }
    
    
}
