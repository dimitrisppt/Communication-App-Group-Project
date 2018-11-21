//
//  AuthenticationConstants.swift
//  SpiderByte
//
//  Created by Alin Fulga on 03/03/2018.
//  Copyright © 2018 King's College London. All rights reserved.
//

import Foundation

struct AuthenticationConstants {
    
    static let ResourceId  = "https://graph.microsoft.com"
    static let kAuthority  = "https://login.microsoftonline.com/common/oauth2/v2.0"
    static let kGraphURI   = "https://graph.microsoft.com/v1.0/me/"
    static let kScopes: [String] = ["https://graph.microsoft.com/Mail.ReadWrite","https://graph.microsoft.com/Mail.Send","https://graph.microsoft.com/Files.ReadWrite","https://graph.microsoft.com/User.ReadBasic.All"]
    
    enum MSGraphError: Error {
        case nsErrorType(error: NSError)
        
    }
    
}
