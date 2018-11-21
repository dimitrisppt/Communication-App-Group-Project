package uk.ac.kcl.spiderbyte.model

import android.app.Activity
import com.microsoft.identity.client.User

/**
 * Created by Alin on 08/02/2018.
 */
class DataManager {

    private var authenticationListener : MSALAuthenticationCallback? = null
    private var authenticationActivity : Activity? = null
    private val mgr = AuthenticationManager.instance
    private var users: List<User>? = null
    private var student : User? = null
    private var name: String = ""
    private var email: String = ""
    private var announcementSort: Int = 1
    private var eventSort: Int = 2
    private var query: String? = null

    fun connect() {
        if (mgr != null) {
            users = mgr.publicClient?.users
        }
        if (users != null && users!!.size == 1) {
            /* We have 1 user */
            student = users!![0]
            mgr?.callAcquireTokenSilent(
                    student!!,
                    true,
                    authenticationListener!!)
        } else {
            /* We have no user */

            /* Let's do an interactive request */
            mgr?.callAcquireToken(
                    authenticationActivity!!,
                    authenticationListener!!)
        }
    }


    fun disconnect() {
        AuthenticationManager.instance!!.disconnect()
    }


    fun setContextActivity(activity: Activity) {
        this.authenticationActivity = activity
    }

    fun getContextActivity() : Activity? = authenticationActivity


    fun setAuthenticationListener(authenticationListener: MSALAuthenticationCallback) {
        this.authenticationListener = authenticationListener
    }

    fun setName(name: String) {
        this.name = name
    }
    fun setEmail(email: String) {
        this.email = email
    }
    fun getName(): String = name

    fun getEmail(): String = email

    fun getAnnouncementSort(): Int = announcementSort

    fun getEventSort(): Int = eventSort

    fun getSearchQueryText(): String? = query

    fun setAnnouncementSort(sort: Int) {
        this.announcementSort = sort
    }

    fun setEventSort(sort: Int) {
        this.eventSort = sort
    }

    fun setSearchQueryText(query: String) {
        this.query = query
    }
}