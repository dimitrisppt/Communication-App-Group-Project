/**
 * Created by Dimitris on 10/02/2018.
 */
package uk.ac.kcl.spiderbyte.model

/**
 * Contains static variables that are needed for Microsoft Authentication
 */
internal interface Constants {
    companion object {
        val AUTHORITY_URL = "https://login.microsoftonline.com/common"
        val AUTHORIZATION_ENDPOINT = "/oauth2/v2.0/authorize"
        val TOKEN_ENDPOINT = "/oauth2/v2.0/token"
        // The Microsoft Graph delegated permissions that you set in the application
        // registration portal must match these scope values.
        // Update this constant with the scope (permission) values for your application:
        val SCOPES = arrayOf("openid", "Mail.ReadWrite", "mail.send", "Files.ReadWrite", "User.ReadBasic.All")
    }
}
